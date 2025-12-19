// Parts of numeric values in (mostly) String form, before they've
// been parsed. Depending on prefix, could end up as exact or inexact numbers

abstract class NumString {
  NumString negate();
}

// A number of the form <beforeDot>.<afterDot>E<exponent>
class WithRadixPoint extends NumString {
  final String beforeDot;
  final String afterDot;
  final int exponent;

  WithRadixPoint(this.beforeDot, this.afterDot, this.exponent);

  String asDecimalString() {
    String expPart = exponent == 0 ? "" : "e$exponent";
    return "$beforeDot.$afterDot$expPart";
  }

  @override
  String toString() => asDecimalString();

  @override
  WithRadixPoint negate() {
    return WithRadixPoint("-$beforeDot", afterDot, exponent);
  }

  double toDouble() {
    return double.parse(asDecimalString());
  }

  (BigInt, BigInt) toFrac() {
    if (beforeDot.startsWith("-")) {
      (BigInt, BigInt) bad = WithRadixPoint(beforeDot.substring(1), afterDot, exponent).toFrac();
      return (bad.$1 * BigInt.from(-1), bad.$2);
    } else {
      (String, String) bad = withZeroExponent();
      String bd = bad.$1;
      String ad = bad.$2;
      ad = ad.replaceAll("0+\$", "");
      BigInt num = BigInt.parse(bd + ad);
      BigInt denom = BigInt.from(10).pow(ad.length);
      return (num, denom);
    }
  }

  (String, String) withZeroExponent() {
    int expAbs = exponent.abs();
    String bd;
    String ad;
    if (exponent < 0) { // move left
      if (beforeDot.length < expAbs) {
        ad = ("0" * (expAbs - beforeDot.length)) + beforeDot + afterDot;
        bd = "";
      } else {
        bd = beforeDot.substring(0, beforeDot.length - expAbs);
        ad = beforeDot.substring(beforeDot.length - expAbs);
      }
    } else if (exponent > 0) { // move right
      if (afterDot.length < expAbs) {
        bd = beforeDot + afterDot + ("0" * (expAbs - afterDot.length));
        ad = "";
      } else {
        bd = beforeDot + afterDot.substring(0, expAbs);
        ad = afterDot.substring(expAbs);
      }
    } else {
      bd = beforeDot;
      ad = afterDot;
    }
    return (bd, ad);
  }
}

class WeirdNum extends NumString {
  double value;

  WeirdNum(this.value);

  @override
  WeirdNum negate() {
    throw UnimplementedError("shouldn't be able to negate Inf or NaN");
  }
}

class IntString extends NumString {
  final String digits;
  final int radix;

  IntString(this.digits, this.radix);

  @override
  IntString negate() {
    return IntString("-$digits", radix);
  }

  @override
  String toString() => digits;
}

class FracString extends NumString {
  final String num;
  final String denom;
  final int radix;

  FracString(this.num, this.denom, this.radix);

  @override
  FracString negate() {
    return FracString("-$num", denom, radix);
  }
}

class ComplexString extends NumString {
  final NumString real;
  final NumString imag;

  ComplexString(this.real, this.imag);

  @override
  ComplexString negate() {
    throw UnimplementedError("shouldn't have to negate complex number");
  }
}
