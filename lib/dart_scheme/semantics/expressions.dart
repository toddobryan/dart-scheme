import "package:petitparser/core.dart";

import "../parsing/ast.dart";

class Pair<T1, T2> extends SExpr<(T1, T2)> {
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
    return Pair._(car, cdr, pairToken, SExprType.list);
  }
}