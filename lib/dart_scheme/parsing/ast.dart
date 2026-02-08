import "package:dart_scheme/dart_scheme/parsing/unparsed_numbers.dart";
import "package:dart_scheme/dart_scheme/utils.dart";
import "package:petitparser/petitparser.dart";

/// A Scheme abstract syntax tree
abstract class SExpr<T> {
  /// a token containing the string and start and stop information
  final Token<T>? token;

  /// the type of the AST
  final SExprType type;

  /// constructor
  SExpr(this.token, this.type);

  T? get value => token?.value;
  String? get input => token?.input;
  int? get start => token?.start;
  int? get stop => token?.stop;
  String? get buffer => token?.buffer;
}

abstract class Datum<T> extends SExpr<T> {
  Datum(super.token, super.type);
}

abstract class SimpleDatum<T> extends Datum<T> {
  SimpleDatum(super.token, super.type);
}

/// AST for primitives: booleans, characters, strings, numbers
class Atom<T> extends SimpleDatum<T> {
  /// constructor
  Atom(super.token, super.type);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Atom && token == other.token && type == other.type;

  @override
  int get hashCode => Object.hash(token, type);

  @override
  String toString() => "Atom(${token!.value}, $type)";
}

class LabelDef<T> extends Datum<(IntString, Datum<T>)> {
  LabelDef(Token<(IntString, Datum<T>)> token) : super(token, SExprType.labelDef);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LabelDef && token == other.token && type == other.type;

  @override
  int get hashCode => Object.hash(token, type);

  @override
  String toString() => "LabelDef(${token!.value.$1}, ${token!.value.$2})";
}

class LabelRef extends Datum<IntString> {
  LabelRef(Token<IntString> token) : super(token, SExprType.labelRef);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LabelRef && token == other.token && type == other.type;

  @override
  int get hashCode => Object.hash(token, type);

  @override
  String toString() => "LabelRef(${token!.value})";
}

abstract class CompoundDatum<T> extends Datum<T> {
  CompoundDatum(super.token, super.type);
}

class SList<T2> extends CompoundDatum<(ImmutableList<Datum<dynamic>>, Datum<T2>?)> {
  SList(Token<(ImmutableList<Datum<dynamic>>, Datum<T2>?)> token) : super(token, SExprType.list);
  
  factory SList.fromList(Token<ImmutableList<Datum<dynamic>>> token) =>
      SList(token.mapValue((v) => (v, null)));

  factory SList.fromDottedList(Token<(ImmutableList<Datum<dynamic>>, Datum<T2>?)> token) =>
      SList(token);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
        other is SList && token == other.token && type == other.type;

  @override
  int get hashCode => Object.hash(token, type);

  @override
  String toString() => "SList(${token!.value.$1}, ${token!.value.$2})";
}

class SVector extends CompoundDatum<ImmutableList<Datum<dynamic>>> {
  SVector(Token<ImmutableList<Datum<dynamic>>> elements) : super(elements, SExprType.vector);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SVector && token == other.token && type == other.type;

  @override
  int get hashCode => Object.hash(token, type);

  @override
  String toString() => "SVector(${token!.value})";
}

class SAbbrev<T> extends CompoundDatum<(Abbrev, Datum<T>)> {
  SAbbrev(Token<(Abbrev, Datum<T>)> token) : super(token, SExprType.abbrev);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SAbbrev && token == other.token && type == other.type;

  @override
  int get hashCode => Object.hash(token, type);

  @override
  String toString() => "Abbrev(${token!.value.$1}, ${token!.value.$2}";
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

  /// list
  list,

  /// vector
  vector,

  /// abbrev
  abbrev,

  /// labelDef
  labelDef,

  /// labelRef
  labelRef,
}

enum Abbrev {
  quote,
  backtick,
  comma,
  commaAt,
}

extension MapValue<T, U> on Token<T> {
  Token<U> mapValue<U>(U Function(T) f) =>
      Token(f(value), buffer, start, stop);
}
