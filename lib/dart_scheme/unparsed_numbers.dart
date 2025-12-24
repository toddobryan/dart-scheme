// Parts of numeric values in (mostly) String form, before they've
// been parsed. Depending on prefix, could end up as exact or inexact numbers

import "package:dart_scheme/dart_scheme/parser.dart";

/// A partial representation of a Scheme number as it's being parsed
abstract class NumString {
  /// the original String from which this NumString was parsed
  String input;

  /// radix
  Radix radix;

  /// constructor
  NumString(this.input, this.radix);

  /// negates this NumString, usually by just adding "-" in the appropriate spot
  /// Note that except for Inf and NaN, numbers should not have negative signs
  NumString negate();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NumString &&
          runtimeType == other.runtimeType &&
          input == other.input &&
          radix == other.radix;

  @override
  int get hashCode => Object.hash(input, radix);
}

class Suffix {
  String input;

  Suffix(this.input);

  int get value {
    final String withoutE = input.substring(1);
    final String stripPlus = withoutE.startsWith("+")
        ? withoutE.substring(1)
        : withoutE;
    return int.parse(stripPlus);
  }

  @override
  String toString() => "Suffix($input)";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Suffix &&
          runtimeType == other.runtimeType &&
          input == other.input;

  @override
  int get hashCode => input.hashCode;
}

/// A number of the form <beforeDot>.<afterDot>(E<exponent>)?
class WithRadixPoint extends NumString {
  /// The part before the radix point
  final String beforeDot;

  /// The part after the radix point, null if there is no radix point
  final String? afterDot;

  /// The integer representing the exponent, will be zero if absent
  final Suffix suffix;

  WithRadixPoint._(
    super.input,
    super.radix,
    this.beforeDot,
    this.afterDot,
    this.suffix,
  );

  /// Constructor
  factory WithRadixPoint(String beforeDot, String? afterDot, Suffix suffix) =>
      WithRadixPoint._(
        "$beforeDot.$afterDot$suffix",
        Radix.dec,
        beforeDot,
        afterDot,
        suffix,
      );

  /// as a "canonical" decimal string
  String asDecimalString() => "$beforeDot$_dotPlusAfterDot${suffix.input}";

  String get _dotPlusAfterDot {
    if (afterDot == null) {
      return "";
    } else {
      return ".$afterDot";
    }
  }

  /// Negates this WithRadixPoint
  @override
  WithRadixPoint negate() => WithRadixPoint("-$beforeDot", afterDot, suffix);

  /// Converts the String to a double
  double toDouble() => double.parse(asDecimalString());

  /// Returns the numerator and denominator of this WithRadixString as a
  /// reduceds fraction
  (BigInt, BigInt) toFrac() {
    if (beforeDot.startsWith("-")) {
      final (BigInt, BigInt) bad = WithRadixPoint(
        beforeDot.substring(1),
        afterDot,
        suffix,
      ).toFrac();
      return (bad.$1 * BigInt.from(-1), bad.$2);
    } else {
      final (String, String) bad = withZeroExponent();
      final String bd = bad.$1;
      final String ad = bad.$2.replaceAll("0+\$", "");
      BigInt numerator = BigInt.parse(bd + ad);
      BigInt denominator = BigInt.from(10).pow(ad.length);
      return (numerator, denominator);
    }
  }

  /// Returns the before and after dot of this WithRadixPoint if the exponent
  /// were zero
  (String, String) withZeroExponent() {
    final int exp = suffix.value;
    final int expAbs = exp.abs();
    String bd;
    String ad;
    if (exp < 0) {
      // move left
      if (beforeDot.length < expAbs) {
        ad = ("0" * (expAbs - beforeDot.length)) + beforeDot + (afterDot ?? "");
        bd = "";
      } else {
        bd = beforeDot.substring(0, beforeDot.length - expAbs);
        ad = beforeDot.substring(beforeDot.length - expAbs);
      }
    } else if (exp > 0) {
      // move right
      String nonNullAfterDot = afterDot ?? "";
      if (nonNullAfterDot.length < expAbs) {
        bd = beforeDot + nonNullAfterDot + ("0" * (expAbs - nonNullAfterDot.length));
        ad = "";
      } else {
        bd = beforeDot + nonNullAfterDot.substring(0, expAbs);
        ad = nonNullAfterDot.substring(expAbs);
      }
    } else {
      bd = beforeDot;
      ad = afterDot ?? "";
    }
    return (bd, ad);
  }
  @override
  String toString() =>
      "WithRadixPoint($beforeDot, a$afterDot, $suffix)";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is WithRadixPoint &&
          runtimeType == other.runtimeType &&
          beforeDot == other.beforeDot &&
          afterDot == other.afterDot &&
          suffix == other.suffix;

  @override
  int get hashCode => Object.hash(super.hashCode, beforeDot, afterDot, suffix);
}

/// Wrapper class for Inf and NaN values
class WeirdNum extends NumString {
  /// This WeirdNum's double value, either double.
  /// infinity, negativeInfinity, or nan
  double value;

  WeirdNum._(super.input, super.radix, this.value);

  /// constructor
  factory WeirdNum(String input, double value) =>
      WeirdNum._(input, Radix.infNan, value);

  @override
  WeirdNum negate() {
    throw UnimplementedError("shouldn't be able to negate Inf or NaN");
  }

  @override
  String toString() => "WeirdNum($input, $value)";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is WeirdNum &&
          runtimeType == other.runtimeType &&
          (value.isNaN && other.value.isNaN ||
          value == other.value);

  @override
  int get hashCode => Object.hash(super.hashCode, value);
}

/// Represents an integer in a given base
class IntString extends NumString {
  /// digits understood (may be "0" in, e.g., "+i")
  String digits;

  /// constructor
  IntString(super.input, super.radix, this.digits);

  @override
  IntString negate() => IntString("-$input", radix, "-$digits");

  @override
  String toString() => "IntString($input, $radix, $digits)";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is IntString &&
          runtimeType == other.runtimeType &&
          digits == other.digits;

  @override
  int get hashCode => Object.hash(super.hashCode, digits);
}

/// Represents a rational number
class FracString extends NumString {
  /// numerator
  final String numerator;

  /// denominator
  final String denominator;

  FracString._(super.input, super.radix, this.numerator, this.denominator);

  /// constructor
  factory FracString(Radix r, String numerator, String denominator) =>
      FracString._("$numerator/$denominator", r, numerator, denominator);

  @override
  FracString negate() => FracString(radix, "-$numerator", denominator);

  @override
  String toString() =>
      "FracString($radix, $numerator, $denominator)";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is FracString &&
          runtimeType == other.runtimeType &&
          numerator == other.numerator &&
          denominator == other.denominator;

  @override
  int get hashCode => Object.hash(super.hashCode, numerator, denominator);
}

/// Represents a complex number, note that radixes should match unless
/// one or more of real and imag is Inf or NaN.
class ComplexString extends NumString {
  /// real part
  final NumString real;

  /// imaginary part
  final NumString imag;

  /// constructor
  ComplexString._(super.input, super.radix, this.real, this.imag);

  /// constructor that reads radix from the real and imag parts
  factory ComplexString(String input, NumString real, NumString imag) {
    Radix radix = real.radix == Radix.infNan ? imag.radix : real.radix;
    return ComplexString._(input, radix, real, imag);
  }

  @override
  ComplexString negate() {
    throw UnimplementedError("shouldn't have to negate complex number");
  }

  @override
  String toString() => "ComplexString($input, $real, $imag)";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ComplexString &&
          runtimeType == other.runtimeType &&
          real == other.real &&
          imag == other.imag;

  @override
  int get hashCode => Object.hash(super.hashCode, real, imag);
}

/// A complex number in the form radius@thetai
class PolarComplexString extends NumString {
  /// magnitude of the represented complex number
  final NumString radius;

  /// angle of the represented complex number
  final NumString theta;

  PolarComplexString._(super.input, super.radix, this.radius, this.theta);

  /// constructor that reads the radix from the radius or theta
  factory PolarComplexString(String input, NumString radius, NumString theta) {
    Radix radix = radius.radix == Radix.infNan ? theta.radix : radius.radix;
    return PolarComplexString._(input, radix, radius, theta);
  }

  @override
  PolarComplexString negate() {
    throw UnimplementedError("shouldn't have to negate complex number");
  }


  @override
  String toString() => "PolarComplexString($input, $radius, $theta)";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is PolarComplexString &&
          runtimeType == other.runtimeType &&
          radius == other.radius &&
          theta == other.theta;

  @override
  int get hashCode => Object.hash(super.hashCode, radius, theta);
}

/// convenience method for IntString in base 2
IntString binInt(String digits) => IntString(digits, Radix.bin, digits);

/// convenience method for IntString in base 8
IntString octInt(String digits) => IntString(digits, Radix.oct, digits);

/// convenience method for IntString in base 10
IntString decInt(String digits) => IntString(digits, Radix.dec, digits);

/// convenience method for IntString in base 16
IntString hexInt(String digits) => IntString(digits, Radix.hex, digits);

/// convenience method for IntString zero in given radix
IntString zero(Radix radix, String input) => IntString(input, radix, "0");

/// convenience method for IntString one in given radix
IntString one(Radix radix, String input) => IntString(input, radix, "1");

/// convenience method for IntString negative one in given radix
IntString negOne(Radix radix, String input) => IntString(input, radix, "-1");

/// convenience method for WithRadixPoint
WithRadixPoint decPoint(String before, String after, String exponent) =>
    WithRadixPoint(before, after, Suffix(exponent));

/// convenience method for FractionString in binary
FracString binFrac(String numerator, String denominator) =>
    FracString(Radix.bin, numerator, denominator);

/// convenience method for FractionString in octal
FracString octFrac(String numerator, String denominator) =>
    FracString(Radix.oct, numerator, denominator);

/// convenience method for FractionString in decimal
FracString decFrac(String numerator, String denominator) =>
    FracString(Radix.dec, numerator, denominator);

/// convenience method for FractionString in hexadecimal
FracString hexFrac(String numerator, String denominator) =>
    FracString(Radix.hex, numerator, denominator);

/// convenience method for WeirdNum constructor for positive infinity
WeirdNum inf(String input) => WeirdNum(input, double.infinity);

/// convenience method for WeirdNum constructor for negative infinity
WeirdNum negInf(String input) => WeirdNum(input, double.negativeInfinity);

/// convenience method for WeirdNum constructor for NaN
WeirdNum nan(String input) => WeirdNum(input, double.nan);

ComplexString comp(String input, NumString real, NumString imag) =>
    ComplexString(input, real, imag);
