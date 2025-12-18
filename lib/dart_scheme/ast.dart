import 'package:dart_scheme/dart_scheme/numbers.dart';
import 'package:petitparser/petitparser.dart';

enum Exactness { exact, inexact }

abstract class SExpr<T> {
  final T value;
  final Token<String> token;
  final SExprType type;

  SExpr(this.value, this.token, this.type);
}

class Atom<T> extends SExpr<T> {
  Atom(super.value, super.token, super.type);
}

class Pair<T1, T2> extends SExpr<(SExpr<T1>, SExpr<T2>)> {
  Pair(SExpr<T1> car, SExpr<T2> cdr, Token<String> token)
    : super((car, cdr), token, SExprType.pair);

  T1 get car => value.$1.value;
  T2 get cdr => value.$2.value;
}

enum SExprType { boolean, string, number, char, pair }
