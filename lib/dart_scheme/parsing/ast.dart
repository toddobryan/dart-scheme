import "package:characters/characters.dart";
import "package:collection/collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:petitparser/petitparser.dart";

import "../error_messages.dart" as err;
import "../utils.dart";
import "numbers.dart";

interface class Literal {}
interface class SelfEvaluating extends Literal {}

sealed class SAst<T> extends Token<T> {
  const SAst(super.value, super.buffer, super.start, super.stop);
}

sealed class SExpr<T> extends Token<T> {
  const SExpr(super.value, super.buffer, super.start, super.stop);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SExpr &&
          value == other.value &&
          start == other.start &&
          stop == other.stop;
}

class SIdentifier extends SExpr<String> {
  const SIdentifier(super.value, super.buffer, super.start, super.stop);

  factory SIdentifier.fromToken(Token<String> t) =>
      SIdentifier(t.value, t.buffer, t.start, t.stop);
}

class SProcedureCall extends SExpr<(SExpr<dynamic>, IList<SExpr<dynamic>>)> {
  const SProcedureCall(super.value, super.buffer, super.start, super.stop);

  factory SProcedureCall.fromToken(Token<(SExpr<dynamic>, IList<SExpr<dynamic>>)> t) =>
    SProcedureCall(t.value, t.buffer, t.start, t.stop);
}

sealed class Datum<T> extends SExpr<T> {
  const Datum(super.value, super.buffer, super.start, super.stop);
}

sealed class SimpleDatum<T> extends Datum<T> {
  const SimpleDatum(
    super.value,
    super.buffer,
    super.start,
    super.stop,
  );
}

class SBoolean extends SimpleDatum<bool> implements SelfEvaluating {
  const SBoolean(bool value, String buffer, int start, int stop)
    : super(value, buffer, start, stop);

  factory SBoolean.fromToken(Token<bool> t) =>
      SBoolean(t.value, t.buffer, t.start, t.stop);
}

class SNumber extends SimpleDatum<SNumberValue> implements SelfEvaluating {
  const SNumber(SNumberValue value, String buffer, int start, int stop)
    : super(value, buffer, start, stop);

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
      super(char, buffer, start, stop);

  factory SCharacter.fromToken(Token<String> oldToken) => SCharacter(
    oldToken.value,
    oldToken.buffer,
    oldToken.start,
    oldToken.stop,
  );
}

class SString extends SimpleDatum<String> {
  const SString(super.value, super.buffer, super.start, super.stop);

  factory SString.fromToken(Token<String> token) =>
      SString(token.value, token.buffer, token.start, token.stop);
}

class SSymbol extends SimpleDatum<String> {
  const SSymbol(super.value, super.buffer, super.start, super.stop);

  factory SSymbol.fromToken(Token<String> token) =>
      SSymbol(token.value, token.buffer, token.start, token.stop);
}

class SByteVector extends SimpleDatum<IList<SNumber>> {
  const SByteVector(super.value, super.buffer, super.start, super.stop);

  factory SByteVector.fromToken(Token<IList<SNumber>> token) {
    final SNumber? bad = token.value.firstWhereOrNull((n) => !n.isByte());
    if (bad != null) {
      throw ParserException(Failure(bad.buffer, bad.start, err.byteVector));
    }
    return SByteVector(token.value, token.buffer, token.start, token.stop);
  }
}

sealed class CompoundDatum<T> extends Datum<T> {
  const CompoundDatum(super.value, super.buffer, super.start, super.stop);
}

sealed class SPairOrNil<T> extends CompoundDatum<T> {
  const SPairOrNil(super.value, super.buffer, super.start, super.stop);
}

// We represent a list (which is possibly an improper list) this way so that
// we retain the token information. If we tried to translate into a pair at
// this point, there would be constituents that don't correspond to contiguous
// regions of the buffer
class SList<T1, T2> extends CompoundDatum<VList<T1, T2>> {
  const SList(super.value, super.buffer, super.start, super.stop);

  factory SList.fromToken(Token<VList<T1, T2>> token) =>
      SList(token.value, token.buffer, token.start, token.stop);
}

class VList<T1, T2> {
  final IList<Datum<T1>> init;
  final Datum<T2>? last;

  VList(this.init, this.last);
}

class SVector<T> extends CompoundDatum<IList<Datum<T>>> {
  const SVector(super.value, super.buffer, super.start, super.stop);

  factory SVector.fromToken(Token<IList<Datum<T>>> token) =>
      SVector(token.value, token.buffer, token.start, token.stop);
}

class SQuotation<T> extends SExpr<Datum<T>> {
  const SQuotation(super.value, super.buffer, super.start, super.stop);

  factory SQuotation.fromToken(Token<Datum<T>> t) =>
      SQuotation(t.value, t.buffer, t.start, t.stop);
}

class SAbbreviation<T> extends CompoundDatum<(SAbbrevPrefix, Datum<T>)> {
  const SAbbreviation(super.value, super.buffer, super.start, super.stop);
  
  factory SAbbreviation.fromToken(Token<(SAbbrevPrefix, Datum<T>)> t) =>
      SAbbreviation(t.value, t.buffer, t.start, t.stop);

  SAbbrevType get abbrevType => value.$1.value;
}

class SAbbrevPrefix extends SAst<SAbbrevType> {
  const SAbbrevPrefix(super.value, super.buffer, super.start, super.stop);

  factory SAbbrevPrefix.fromToken(Token<SAbbrevType> t) =>
      SAbbrevPrefix(t.value, t.buffer, t.start, t.stop);
}

enum SAbbrevType { quote, backtick, comma, commaAt }

class SLabelDef<T> extends Datum<(int, Datum<T>)> {
  const SLabelDef(super.value, super.buffer, super.start, super.stop);

  factory SLabelDef.fromToken(Token<(int, Datum<T>)> token) =>
      SLabelDef(token.value, token.buffer, token.start, token.stop);

  int get label => value.$1;

  Datum<T> get datum => value.$2;
}

class SLabelRef extends Datum<int> {
  const SLabelRef(super.value, super.buffer, super.start, super.stop);

  factory SLabelRef.fromToken(Token<int> token) =>
      SLabelRef(token.value, token.buffer, token.start, token.stop);
}

enum CommentKind { line, nested, datum }

sealed class SComment extends SAst<String> {
  final CommentKind kind;

  const SComment(this.kind, super.value, super.buffer, super.start, super.stop);
}

class SLineComment extends SComment {
  const SLineComment(String value, String buffer, int start, int stop)
    : super(CommentKind.line, value, buffer, start, stop);

  factory SLineComment.fromToken(Token<String> t) =>
      SLineComment(t.value, t.buffer, t.start, t.stop);
}

class SNestedComment extends SComment {
  const SNestedComment(String value, String buffer, int start, int stop)
    : super(CommentKind.nested, value, buffer, start, stop);

  factory SNestedComment.fromToken(Token<String> t) =>
      SNestedComment(t.value, t.buffer, t.start, t.stop);
}

class SDatumComment extends SComment {
  const SDatumComment(String value, String buffer, int start, int stop)
    : super(CommentKind.datum, value, buffer, start, stop);

  factory SDatumComment.fromToken(Token<String> t) =>
      SDatumComment(t.value, t.buffer, t.start, t.stop);
}

enum DirectiveKind { fold, noFold }

sealed class SDirective extends Token<String> {
  final DirectiveKind kind;

  const SDirective(
    this.kind,
    super.value,
    super.buffer,
    super.start,
    super.stop,
  );
}

class SFoldCase extends SDirective {
  const SFoldCase(String value, String buffer, int start, int stop)
    : super(DirectiveKind.fold, value, buffer, start, stop);

  factory SFoldCase.fromToken(Token<String> t) =>
      SFoldCase(t.value, t.buffer, t.start, t.stop);
}

class SNoFoldCase extends SDirective {
  const SNoFoldCase(String value, String buffer, int start, int stop)
    : super(DirectiveKind.noFold, value, buffer, start, stop);

  factory SNoFoldCase.fromToken(Token<String> t) =>
      SNoFoldCase(t.value, t.buffer, t.start, t.stop);
}

extension MapValue<T, U> on Token<T> {
  Token<U> mapValue<U>(U Function(T) f) => Token(f(value), buffer, start, stop);
}
