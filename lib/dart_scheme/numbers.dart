abstract class SNumeric {
  bool get isExact;
}

class SComplex extends SNumeric {
  SReal real;
  SReal imag;

  SComplex(this.real, this.imag);

  @override
  bool get isExact => real.isExact && imag.isExact;
}

abstract class SReal extends SNumeric {}

class SRational extends SReal {
  SInt num;
  SInt denom;

  SRational(this.num, this.denom);

  @override
  bool get isExact => true;
}

class SDouble extends SReal {
  double value;

  SDouble(this.value);

  @override
  bool get isExact => false;
}

class SInt extends SNumeric {
  BigInt value;

  SInt(this.value);

  @override
  bool get isExact => true;
}
