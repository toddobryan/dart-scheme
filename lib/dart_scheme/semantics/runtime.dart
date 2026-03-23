import "package:fast_immutable_collections/fast_immutable_collections.dart";

import "vm.dart";

sealed class SExpr {}

class SClosure extends SExpr {
  SExpr body;
  Env env;
  IList<SSymbol> vars;

  SClosure(this.body, this.env, this.vars);

  factory SClosure.continuation(Stack s) {
    final SSymbol theVar = SSymbol("contVar");
    return SClosure(Nuate(s, theVar), Env(null), IList([theVar]));
  }
}

class SSymbol extends SExpr {
  String name;

  SSymbol(this.name);
}

class SPair extends SExpr {
  SExpr car;
  SExpr cdr;

  SPair(this.car, this.cdr);
}

class SQuote extends SExpr {
  SExpr obj;

  SQuote(this.obj);
}

class SLambda extends SExpr {
  final IList<SSymbol> vars;
  final SExpr body;

  SLambda(this.vars, this.body);
}

class SIf extends SExpr {
  final SExpr test;
  final SExpr thenExpr;
  final SExpr elseExpr;

  SIf(this.test, this.thenExpr, this.elseExpr);
}

class SSet extends SExpr {
  final SSymbol varb;
  final SExpr x;

  SSet(this.varb, this.x);
}

class SCallCc extends SExpr {
  final SExpr x;

  SCallCc(this.x);
}

class SNil extends SExpr {
  static final SNil _singleton = SNil._();

  factory SNil() => _singleton;

  SNil._();
}

sealed class VmOp extends SExpr {
  VmOp();
}

class Halt extends VmOp {
  static final Halt _singleton = Halt._();

  factory Halt() => _singleton;

  Halt._();

//SExpr halt() => accumulator;
}

class Refer extends VmOp {
  final SSymbol varb;
  final SExpr x;

  Refer(this.varb, this.x);

/*void refer(SSymbol v, SExpr x) {
    accumulator = environment[v.name]!;
    next = x;
  }*/
}

class Constant extends VmOp {
  final SExpr obj;
  final SExpr x;

   Constant(this.obj, this.x);

/*void constant(SExpr obj, SExpr x) {
    accumulator = obj;
    next = x;
  }*/
}

class Close extends VmOp {
  final IList<SSymbol> vars;
  final SExpr body;
  final SExpr x;

   Close(this.vars, this.body, this.x);

/*void close(List<SSymbol> vars, SExpr body, SExpr x) {
    // TODO
    // creates a closure from body, vars and the current environment,
    // places the closure into the accumulator, and sets the next
    // expression to x
  }*/
}

class Test extends VmOp {
  final SExpr thenExpr;
  final SExpr elseExpr;

   Test(this.thenExpr, this.elseExpr);

/*
  void test(SExpr ifTrue, SExpr ifFalse) {
    if (accumulator != SNil()) {
      next = ifTrue;
    } else {
      next = ifFalse;
    }
  }
   */
}

class Assign extends VmOp {
  final SSymbol varb;
  final SExpr x;

   Assign(this.varb, this.x);

/*
  void assign(SSymbol v, SExpr x) {
    environment[v.name] = accumulator;
    next = x;
  }*/
}

class Conti extends VmOp {
  final SExpr x;

  Conti(this.x);

/*
  void conti(SExpr x) {
    // creates a continuation from the current stack, places this
    // continuation in the accumulator, and sets the next expression to x
  }
   */
}

class Nuate extends VmOp {
  final Stack s;
  final SSymbol varb;

  Nuate(this.s, this.varb);

/*
  void nuate(Frame s, SSymbol v) {
    currentFrame = s;
    accumulator = environment[v.name]!;
    next = Return();
  }
  */
}

class Frame extends VmOp {
  final SExpr x;
  final SExpr ret;

  Frame(this.x, this.ret);

/*
  void frame(SExpr x, SExpr ret) {
    currentFrame = Frame(ret, environment, rib, currentFrame);
    rib = [];
    next = x;
  }
*/
}

class Argument extends VmOp {
  final SExpr x;

  Argument(this.x);

/*
  void argument(SExpr x) {
    rib.add(accumulator);
    next = x;
  }
*/
}

class Apply extends VmOp {
  /*
  void apply() {
    assert(accumulator is SClosure, "apply implies SClosure in accumulator");
    // extends the closure's environment with the closure's variable list and
    // the current rib, sets the current environment to this new environment,
    // sets the current rib to the empty list, and sets the next expression
    // to the closure's body
  }
   */
}

class Return extends VmOp {

  /*void doReturn() {
    currentFrame = currentFrame.parent;
    environment = currentFrame.environment;
    rib = currentFrame.rib;
    next = currentFrame.next;
  }*/
}
