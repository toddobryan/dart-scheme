import "dart:collection";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "runtime.dart";

class Env extends MapBase<SSymbol, SExpr> {
  final Env? parent;
  final Map<SSymbol, SExpr> _wrapped = {};

  Env(this.parent);

  @override
  SExpr? operator [](Object? key) => _wrapped[key] ?? parent?[key];

  @override
  void operator []=(SSymbol key, SExpr value) => _wrapped[key] = value;

  @override
  void clear() => throw UnimplementedError("don't clear an Env");

  @override
  Iterable<SSymbol> get keys => [... _wrapped.keys, ... parent?.keys ?? []];

  @override
  SExpr? remove(Object? key) => _wrapped.remove(key);
}

class Stack {
  SExpr next;
  Env environment;
  IList<SExpr> rib;
  Stack parent;

  Stack(this.next, this.environment, this.rib, this.parent);
}

class VirtualMachine {
  SExpr accumulator;
  SExpr next;
  Env environment;
  List<SExpr> rib;
  Stack currentFrame;

  VirtualMachine(this.accumulator,
      this.next,
      this.environment,
      this.rib,
      this.currentFrame,);
}

SExpr compile(SExpr x, SExpr next) =>
  switch (x) {
    SSymbol(name: _) => Refer(x, next),
    SPair(car: _, cdr: _) => switch (x) {
      SQuote(obj: final obj) => Constant(obj, next),
      SLambda(vars: final vars, body: final body) => Close(vars, compile(body, Return()), next),
      SIf(test: final test, thenExpr: final thenExpr, elseExpr: final elseExpr) => compile(test, Test(compile(thenExpr, next), compile(elseExpr, next))),
      SSet(varb: final varb, x: final xx) => compile(xx, Assign(varb, next)),
      SCallCc(x: final xx) => doCallCc(xx, next),
      _ => doRecurrence(x, next),
    },
    _ => Constant(x, next),
  };

SExpr doCallCc(SExpr x, SExpr next) {
  final c = Conti(Argument(compile(x, Apply())));
  return isTail(next) ? c : Frame(next, c);
}

bool isTail(SExpr next) => next is SPair && next.car == Return();

SExpr doRecurrence(SPair x, SExpr next) {
  SExpr loop(SExpr args, SExpr c) {
    if (args == SNil()) {
      return isTail(next) ? c : Frame(next, c);
    } else {
      args as SPair;
      return loop(args.cdr, compile(args.car, Argument(c)));
    }
  }
  return loop(x.cdr, compile(x.car, Apply()));
}

SExpr vm(SExpr a, SExpr x, Env e, IList<SExpr> r, Stack s) {
  SExpr doAssign(SSymbol v, SExpr expr) {
    e[v] = a;
    return vm(a, expr, e, r, s);
  }

  SExpr doApply() {
    assert(a is SClosure);
    final SClosure(:body, :env, :vars) = a as SClosure;
    return vm(a, body, extend(e, vars, r), const IList.empty(), s);
  }

  SExpr doReturn() {
    final Stack(:next, :environment, :rib, :parent) = s;
    return vm(a, next, environment, rib, parent);
  }

  return switch (x) {
    Halt() => a,
    Refer(varb: final varb, x: final xx) => vm(e[varb]!, x, e, r, s),
    Constant(obj: final obj, x: final xx) => vm(obj, xx, e, r, s),
    Close(vars: final vars, body: final body, x: final xx) => vm(SClosure(body, e, vars), xx, e, r, s),
    Test(thenExpr: final t, elseExpr: final f) => vm(a, a == SNil() ? t : f, e, r, s),
    Assign(varb: final varb, x: final xx) => doAssign(varb, xx),
    Conti(x: final xx) => vm(SClosure.continuation(s), xx, e, r, s),
    Nuate(s: final ss, varb: final varb) => vm(e[varb.name]!, Return(), e, r, ss),
    Frame(ret: final ret, x: final xx) => vm(a, xx, e, const IList.empty(), Stack(ret, e, r, s)),
    Argument(x: final xx) => vm(a, xx, e, IList([a, ...r]), s),
    Apply() => doApply(),
    Return() => doReturn(),
    _ => throw ArgumentError("Expected VmOp, found $x"),
  };
}

Env extend(Env e, IList<SSymbol> vars, IList<SExpr> values) {
  final Env newEnv = Env(e);
  for (int i = 0; i < vars.length; i++) {
    newEnv[vars[i]] = values[i];
  }
  return newEnv;
}


