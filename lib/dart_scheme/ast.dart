import "dart:math";

import "package:collection/collection.dart";
import "package:dart_mappable/dart_mappable.dart";
import "package:dart_scheme/dart_scheme/unparsed_numbers.dart";
import "package:petitparser/petitparser.dart";

part "ast.mapper.dart";

/// A Scheme abstract syntax tree
@MappableClass()
abstract class SExpr<T> with SExprMappable<T> {
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

/// AST for primitives: booleans, characters, strings, numbers
@MappableClass()
class Atom<T> extends SExpr<T> with AtomMappable<T> {
  /// constructor
  Atom(super.token, super.type);
}

class SList<T> {
  final List<T> _list;
  final ListEquality<T> _listEq = ListEquality<T>();

  SList(this._list);

  @override
  String toString() => "SList($_list)";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SList<T> &&
          runtimeType == other.runtimeType &&
          _listEq.equals(_list, other._list);

  @override
  int get hashCode => _list.hashCode;
}

@MappableClass()
class Pair<T1, T2> extends SExpr<(T1, T2)> with PairMappable<T1, T2> {
  SExpr<T1> car;
  SExpr<T2> cdr;

  Pair._(this.car, this.cdr, super.token, super.type);

  factory Pair(SExpr<T1> car, SExpr<T2> cdr) {
    final Token<(T1, T2)> pairToken = Token(
      (car.value!, cdr.value!),
      car.buffer!,
      car.start!,
      cdr.stop!,
    );
    return Pair._(car, cdr, pairToken, SExprType.pair);
  }
}

class Nil extends SExpr<SList<dynamic>> with NilMappable {
  Nil(Token<SList<dynamic>>? token) : super(token, SExprType.nil);
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

  /// pair
  pair,
}
