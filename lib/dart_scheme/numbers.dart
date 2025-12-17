import 'package:dart_scheme/dart_scheme/ast.dart';

abstract class SNumber {
  int radix;

  SNumber(this.radix);

  factory SNumber.make(Exactness ex, NumString num) {
  }
}

abstract class SExact extends SNumber {
  SExact(super.radix);
}

abstract class SInexact extends SNumber {
  SInexact(super.radix);
}

class SExactReal extends SExact {
  BigInt num;
  BigInt denom;

  SExactReal(super.radix, this.num, this.denom);
}

class SInexactReal extends SInexact {
  double value;

  SInexactReal(super.radix, this.value);
}

class SExactComplex extends SExact {
  SExactReal real;
  SExactReal imag;

  SExactComplex(super.radix, this.real, this.imag);
}

class SInexactComplex extends SInexact {
  SInexactReal real;
  SInexactReal imag;

  SInexactComplex(super.radix, this.real, this.imag);
}
