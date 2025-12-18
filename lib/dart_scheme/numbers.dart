import 'package:dart_scheme/dart_scheme/ast.dart';
import 'package:dart_scheme/dart_scheme/parser.dart';
import 'package:dart_scheme/dart_scheme/unparsed_strings.dart';

abstract class SNumber {
  int radix;

  SNumber(this.radix);

  static SNumber make(Exactness ex, NumString number) {
    if (ex == Exactness.exact) {
      if (number is WeirdNum) {
        throw Exception("Can't create exact Inf or NaN value");
      } else if (number is IntString) {
        return SExactInteger(
          number.radix,
          BigInt.parse(number.digits, radix: number.radix),
        );
      } else if (number is FracString) {
        return SExactReal(
          number.radix,
          BigInt.parse(number.num, radix: number.radix),
          BigInt.parse(number.denom, radix: number.radix),
          true,
        );
      } else if (number is WithRadixPoint) {
        var (num, denom) = number.toFrac();
        return SExactReal(10, num, denom, false);
      } else if (number is ComplexString) {
        SExactReal real = SNumber.make(ex, number.real) as SExactReal;
        SExactReal imag = SNumber.make(ex, number.imag) as SExactReal;
        return SExactComplex(real.radix, real, imag);
      } else {
        throw ArgumentError("Unexpected NumberString: $number");
      }
    } else { // it's an inexact number, so store as a double
      if (number is WeirdNum) {
        return SInexactReal(10, number.value);
      } else if (number is FracString) {
        double num = BigInt.parse(number.num, radix: number.radix).toDouble();
        double denom = BigInt.parse(number.denom, radix: number.radix).toDouble();
        return SInexactReal(number.radix, num / denom);
      } else if (number is IntString) {
        return SInexactReal(number.radix, BigInt.parse(number.digits, radix: number.radix).toDouble());
      } else if (number is ComplexString) {
        SInexactReal real = SNumber.make(ex, number.real) as SInexactReal;
        SInexactReal imag = SNumber.make(ex, number.imag) as SInexactReal;
        return SInexactComplex(real.radix, real, imag);
      } else {
        throw ArgumentError("Unexpected NumberString: $number");
      }
    }
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
  bool showAsFraction = true;

  SExactReal(super.radix, this.num, this.denom, this.showAsFraction);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SExactReal &&
    other.num == num &&
    other.denom == denom;
  }
}

class SExactInteger extends SExactReal {
  SExactInteger(int radix, BigInt num) : super(radix, num, BigInt.one, false);
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
