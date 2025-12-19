import 'package:big_decimal/big_decimal.dart';
import 'package:dart_scheme/dart_scheme/ast.dart';
import 'package:dart_scheme/dart_scheme/unparsed_strings.dart';

abstract class SNumber {
  int radix;

  SNumber(this.radix);

  static SNumber make(Exactness ex, NumString number) {
    print("$ex, $number");
    if (ex == Exactness.exact) {
      if (number is WeirdNum) {
        throw Exception("Can't create exact Inf or NaN value");
      } else if (number is IntString) {
        return SExactInteger(
          number.radix,
          BigInt.parse(number.digits, radix: number.radix),
        );
      } else if (number is FracString) {
        return SExactRational(
          number.radix,
          BigInt.parse(number.num, radix: number.radix),
          BigInt.parse(number.denom, radix: number.radix),
        );
      } else if (number is WithRadixPoint) {
        return SExactWithRadixPoint(BigDecimal.parse(number.asDecimalString()));
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

  SExactComplex toComplex();
}

abstract class SInexact extends SNumber {
  SInexact(super.radix);

  SInexactComplex toComplex();
}

abstract class SExactReal extends SExact {
  SExactReal(super.radix);

  SExactRational toRational();

  @override
  SExactComplex toComplex() =>
      SExactComplex(radix, this, SExactInteger(radix, BigInt.zero));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is SExactReal) {
      return toRational() == other.toRational();
    } else {
      return false;
    }
  }

  @override
  int get hashCode => toRational().hashCode;
}

class SExactRational extends SExactReal {
  final BigInt num;
  final BigInt denom;

  SExactRational(super.radix, this.num, this.denom);

  factory SExactRational.fromBigInts(int radix, BigInt num, BigInt denom) {
    assert(denom > BigInt.zero, "denominator should be positive");
    BigInt gcd = num.gcd(denom);
    return SExactRational(radix, num ~/ gcd, denom ~/ gcd);
  }

  @override
  SExactRational toRational() => this;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SExactRational &&
        other.num == num &&
        other.denom == denom;
  }

  @override
  int get hashCode => Object.hash(num, denom);

  @override
  String toString() => "$num/$denom";
}

// For now, only handles base 10
class SExactWithRadixPoint extends SExactReal {
  final BigDecimal value;

  SExactWithRadixPoint(this.value) : super(10);

  factory SExactWithRadixPoint.fromBigDecimal(BigDecimal value) {
    return SExactWithRadixPoint(value);
  }

  SExactRational toRational() {
    if (value.scale <= 0) {
      return SExactRational(radix, value.toBigInt(), BigInt.one);
    }
    BigInt num = value.intVal;
    BigInt denom = BigInt.from(10).pow(value.scale);
    return SExactRational(radix, num, denom);
  }

  @override
  String toString() => value.toString();

}

class SExactInteger extends SExactReal {
  final BigInt value;

  SExactInteger(super.radix, this.value);

  @override
  SExactRational toRational() => SExactRational(radix, value, BigInt.one);

  @override
  String toString() => value.toString();
}

class SInexactReal extends SInexact {
  double value;

  SInexactReal(super.radix, this.value);

  SInexactComplex toComplex() =>
      SInexactComplex(radix, this, SInexactReal(radix, 0.0));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SInexactReal &&
      value == other.value;
  }

  @override
  int get hashCode => value.hashCode;
}

class SExactComplex extends SExact {
  SExactReal real;
  SExactReal imag;

  SExactComplex(super.radix, this.real, this.imag);

  @override
  SExactComplex toComplex() => this;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SExactComplex
        && real == other.real
        && imag == other.imag;
  }

  @override
  int get hashCode => Object.hash(real, imag);
}

class SInexactComplex extends SInexact {
  SInexactReal real;
  SInexactReal imag;

  SInexactComplex(super.radix, this.real, this.imag);

  @override
  SInexactComplex toComplex() => this;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SInexactComplex
        && real == other.real
        && imag == other.imag;
  }

  @override
  int get hashCode => Object.hash(real, imag);
}
