import "package:characters/characters.dart";
import "package:collection/collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:petitparser/petitparser.dart";

import "../utils.dart";
import "../error_messages.dart" as err;
import "numbers.dart";

sealed class Expr<T> extends Token<T> {
  final SExprType type;

  const Expr(this.type, super.value, super.buffer, super.start, super.stop);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Expr &&
          type == other.type &&
          value == other.value &&
          buffer == other.buffer &&
          start == other.start &&
          stop == other.stop;

  @override
  int get hashCode => Object.hash(super.hashCode, type);
}

sealed class Datum<T> extends Expr<T> {
  const Datum(super.type, super.value, super.buffer, super.start, super.stop);
}

sealed class SimpleDatum<T> extends Datum<T> {
  const SimpleDatum(super.type, super.value, super.buffer, super.start, super.stop);
}

class SBoolean extends SimpleDatum<bool> {
  const SBoolean(bool value, String buffer, int start, int stop)
    : super(.boolean, value, buffer, start, stop);

  factory SBoolean.fromToken(Token<bool> t) =>
      SBoolean(t.value, t.buffer, t.start, t.stop);
}

class SNumber extends SimpleDatum<SNumberValue> {
  const SNumber(SNumberValue value, String buffer, int start, int stop)
    : super(.number, value, buffer, start, stop);

  factory SNumber.fromToken(Token<SNumberValue> token) =>
      SNumber(token.value, token.buffer, token.start, token.stop);

  bool isByte() {
    if (value is! SExactInteger) {
      return false;
    }
    final FlexInt val = (value as SExactInteger).value;
    return FlexInt.zero <= val && val <= FlexInt.maxByte;
  }
}

class SCharacter extends SimpleDatum<String> {
  SCharacter(String char, String buffer, int start, int stop)
    : assert(char.characters.length == 1),
      super(.char, char, buffer, start, stop);
  
  factory SCharacter.fromToken(Token<String> oldToken) =>
      SCharacter(oldToken.value, oldToken.buffer, oldToken.start, oldToken.stop);
}

class SString extends SimpleDatum<String> {
  const SString(String s, String buffer, int start, int stop)
    : super(.string, s, buffer, start, stop);

  factory SString.fromToken(Token<String> token) =>
      SString(token.value, token.buffer, token.start, token.stop);
}

class SSymbol extends SimpleDatum<String> {
  const SSymbol(String s, String buffer, int start, int stop) :
      super(.symbol, s, buffer, start, stop);

  factory SSymbol.fromToken(Token<String> token) =>
      SSymbol(token.value, token.buffer, token.start, token.stop);
}

class SByteVector extends SimpleDatum<IList<SNumber>> {
  const SByteVector(IList<SNumber> bytes, String buffer, int start, int stop)
    : super(.byteVector, bytes, buffer, start, stop);

  factory SByteVector.fromToken(Token<IList<SNumber>> token) {
    final SNumber? bad = token.value.firstWhereOrNull((n) => !n.isByte());
    if (bad != null) {
      throw ParserException(
          Failure(bad.buffer, bad.start, err.byteVector)
      );
    }
    return SByteVector(token.value, token.buffer, token.start, token.stop);
  }
}

sealed class CompoundDatum<T> extends Datum<T> {
  const CompoundDatum(super.type, super.value, super.buffer, super.start, super.stop);
}

sealed class SPairOrNil<T> extends CompoundDatum<T> {
  const SPairOrNil(super.type, super.value, super.buffer, super.start, super.stop);
}

// We represent a list (which is possibly an improper list) this way so that
// we retain the token information. If we tried to translate into a pair at
// this point, their would be constituents that don't correspond to contiguous
// regions of the buffer
class SList<T1, T2> extends CompoundDatum<VList<T1, T2>> {
  const SList(VList<T1, T2> list, String buffer, int start, int stop) :
      super(.list, list, buffer, start, stop);

  factory SList.fromToken(Token<VList<T1, T2>> token) =>
      SList(token.value, token.buffer, token.start, token.stop);
}

class VList<T1, T2> {
  final IList<Datum<T1>> init;
  final Datum<T2>? last;

  VList(this.init, this.last);
}

class SVector<T> extends CompoundDatum<IList<Datum<T>>> {
  const SVector(IList<Datum<T>> elements, String buffer, int start, int stop)
    : super(.vector, elements, buffer, start, stop);

  factory SVector.fromToken(Token<IList<Datum<T>>> token) =>
      SVector(token.value, token.buffer, token.start, token.stop);
}

class SAbbreviation<T> extends CompoundDatum<VAbbrev<T>> {
  const SAbbreviation(VAbbrev<T> abbrev, String buffer, int start, int stop)
    : super(.abbrev, abbrev, buffer, start, stop);

  factory SAbbreviation.fromToken(Token<VAbbrev<T>> token) =>
    SAbbreviation(token.value, token.buffer, token.start, token.stop);
}

class VAbbrev<T> {
  final AbbrevType type;
  final Datum<T> value;

  VAbbrev(this.type, this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VAbbrev && type == other.type && value == other.value;

  @override
  int get hashCode => Object.hash(type, value);
}

enum AbbrevType { quote, backtick, comma, commaAt }

class SLabelDef<T> extends Datum<VLabelDef<T>> {
  const SLabelDef(VLabelDef<T> value, String buffer, int start, int stop) :
      super(.labelDef, value, buffer, start, stop);

  factory SLabelDef.fromToken(Token<VLabelDef<T>> token) =>
      SLabelDef(token.value, token.buffer, token.start, token.stop);
}

class VLabelDef<T> {
  final int labelNumber;
  final Datum<T> value;

  VLabelDef(this.labelNumber, this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is VLabelDef &&
              labelNumber == other.labelNumber && value == other.value;

  @override
  int get hashCode => Object.hash(labelNumber, value);
}

class SLabelRef extends Datum<int> {
  const SLabelRef(int labelNumber, String buffer, int start, int stop) :
      super(.labelRef, labelNumber, buffer, start, stop);

  factory SLabelRef.fromToken(Token<int> token) =>
    SLabelRef(token.value, token.buffer, token.start, token.stop);
}

/// Types of Scheme ASTs
enum SExprType {
  /// symbol
  symbol,

  /// boolean
  boolean,

  /// string
  string,

  /// number
  number,

  /// character
  char,

  /// byteVector
  byteVector,

  /// nil
  nil,

  /// vector
  vector,

  /// abbrev
  abbrev,

  /// labelDef
  labelDef,

  /// labelRef
  labelRef,

  /// pair
  pair,
  
  /// list
  list,
}

extension MapValue<T, U> on Token<T> {
  Token<U> mapValue<U>(U Function(T) f) => Token(f(value), buffer, start, stop);
}
