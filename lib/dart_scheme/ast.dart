import "package:petitparser/petitparser.dart";

/// Tag for exact or inexact numbers
enum Exactness {
  /// an exact number
  exact,
  /// an inexact number
  inexact
}

/// A Scheme abstract syntax tree
abstract class SExpr<T> {
  /// the semantic value of the AST
  final T value;
  /// a token containing the string and start and stop information
  final Token<String> token;
  /// the type of the AST
  final SExprType type;

  /// constructor
  SExpr(this.value, this.token, this.type);
}

/// AST for primitives: booleans, characters, strings, numbers
class Atom<T> extends SExpr<T> {
  /// constructor
  Atom(super.value, super.token, super.type);
}

/// AST for non-atomic values, pairs and (proper) lists
class Pair<T1, T2> extends SExpr<(SExpr<T1>, SExpr<T2>)> {
  /// constructor
  Pair(SExpr<T1> car, SExpr<T2> cdr, Token<String> token)
    : super((car, cdr), token, SExprType.pair);

  /// the first value in the pair
  T1 get car => value.$1.value;
  /// the second value in the pain
  T2 get cdr => value.$2.value;
}

/// Types of Scheme ASTs
enum SExprType {
  /// boolean
  boolean,
  /// string
  string,
  /// number
  number,
  /// character
  char,
  /// pair
  pair
}
