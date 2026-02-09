import "dart:math";

import "package:big_decimal/big_decimal.dart";
import "package:dart_scheme/dart_scheme/parsing/parser.dart";
import "package:dart_scheme/dart_scheme/parsing/unparsed_numbers.dart";
import "package:petitparser/parser.dart";

import "../utils.dart";

abstract class SNumberValue {
  final Radix radix;

  const SNumberValue(this.radix);

  static SNumberValue make(PrefixedNumString number) {
    assert(number.prefix.radix ==
        number.numString.radix, "Radix values don't match");
    return _make(number.prefix.exactness, number.numString);
  }

  static SNumberValue _make(Exactness ex, NumString numString) =>
      switch (ex) {
        Exactness.exact =>
        switch (numString) {
          WeirdNum() =>
          throw ArgumentError("Can't create exact Inf or NaN value"),
          IntString(radix: final Radix r, digits: final String d) =>
              SExactInteger(r, FlexInt.fromBigInt(BigInt.parse(d, radix: r.value))),
          FracString(
          radix: final Radix r,
          numerator: final String n,
          denominator: final String d
          ) =>
              SExactRational(
                r,
                FlexInt.fromBigInt(BigInt.parse(n, radix: r.value)),
                FlexInt.fromBigInt(BigInt.parse(d, radix: r.value)),
              ),
          WithRadixPoint(input: final String i) =>
              SExactWithRadixPoint(BigDecimal.parse(i)),
          CartesianComplexString(
          radix: final Radix r,
          real: final NumString re,
          imag: final NumString im
          ) =>
              SExactComplex(
                r,
                SNumberValue._make(ex, re) as SExactReal,
                SNumberValue._make(ex, im) as SExactReal,
              ),
          PolarComplexString(
          radix: final Radix r,
          radius: final RealString magString,
          theta: final RealString angleString,
          ) => _makeExactComplexFromPolar(r, magString, angleString),
        },
        Exactness.inexact =>
        switch (numString) {
          WeirdNum(radix: final Radix r, value: final double v) =>
              SInexactReal(r, v),
          WithRadixPoint(input: final String i) =>
              SInexactReal(Radix.dec, double.parse(i)),
          FracString(radix: final Radix r, numerator: final String n, denominator: final String d) =>
              _makeInexactFraction(r, n, d),
          IntString(radix: final Radix r, digits: final String d) =>
              SInexactReal(r, BigInt.parse(d, radix: r.value).toDouble()),
          CartesianComplexString(
          radix: final Radix r,
          real: final RealString re,
          imag: final RealString im,
          ) =>
              SInexactComplex(
                r,
                SNumberValue._make(Exactness.inexact, re) as SInexactReal,
                SNumberValue._make(Exactness.inexact, im) as SInexactReal,
              ),
          PolarComplexString(
          radix: final Radix r,
          radius: final RealString magString,
          theta: final RealString angleString,
          ) => _makeInexactComplexFromPolar(r, magString, angleString),
        },
      };
}

SExactComplex _makeExactComplexFromPolar(Radix r, RealString magString, RealString angleString) {
  final double mag = (SNumberValue._make(Exactness.exact, magString) as SExactReal).toDouble();
  if (mag.isInfinite || mag.isNaN) {
    throw ArgumentError("polar coordinates must be representable as finite doubles, but ${magString.input} is not");
  }
  final double angle = (SNumberValue._make(Exactness.exact, angleString) as SExactReal).toDouble();
  if (angle.isInfinite || angle.isNaN) {
    throw ArgumentError("polar coordinates must be representable as finite doubles, but ${angleString.input} is not");
  }
  final SExactReal re = SExactWithRadixPoint(BigDecimal.parse("${mag * cos(angle)}"));
  final SExactReal im = SExactWithRadixPoint(BigDecimal.parse("${mag * sin(angle)}"));
  return SExactComplex(Radix.dec, re, im);
}

SInexactComplex _makeInexactComplexFromPolar(Radix r, RealString magString, RealString angleString) {
  final double mag = (SNumberValue._make(Exactness.exact, magString) as SExactReal).toDouble();
  final double angle = (SNumberValue._make(Exactness.exact, angleString) as SExactReal).toDouble();
  return SInexactComplex(r, SInexactReal(r, mag * cos(angle)), SInexactReal(r, mag * sin(angle)));
}

SInexactReal _makeInexactFraction(Radix r, String n, String d) {
  final BigInt numer = BigInt.parse(n, radix: r.value);
  final BigInt denom = BigInt.parse(d, radix: r.value);
  return SInexactReal(r, numer / denom);
}

abstract class SExact extends SNumberValue {
  const SExact(super.radix);

  SExactComplex toComplex();
}

abstract class SInexact extends SNumberValue {
  const SInexact(super.radix);

  SInexactComplex toComplex();
}

abstract class SExactReal extends SExact {
  const SExactReal(super.radix);

  double toDouble();

  SExactRational toRational();

  @override
  SExactComplex toComplex() =>
      SExactComplex(radix, this, SExactInteger(radix, FlexInt.zero));
}

class SExactRational extends SExactReal {
  final FlexInt numerator;
  final FlexInt denominator;

  const SExactRational(super.radix, this.numerator, this.denominator);

  factory SExactRational.fromFlexInts(Radix radix, FlexInt numerator, FlexInt denominator) {
    assert(denominator > FlexInt.zero, "denominator should be positive");
    final FlexInt gcd = numerator.gcd(denominator);
    return SExactRational(radix, numerator ~/ gcd, denominator ~/ gcd);
  }

  @override
  SExactRational toRational() => this;

  @override
  double toDouble() => numerator / denominator;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SExactRational  &&
              numerator == other.numerator && denominator == other.denominator;

  @override
  int get hashCode => Object.hash(numerator, denominator);
}

// For now, only handles base 10
class SExactWithRadixPoint extends SExactReal {
  final BigDecimal value;

  const SExactWithRadixPoint(this.value) : super(Radix.dec);

  factory SExactWithRadixPoint.fromBigDecimal(BigDecimal value) =>
      SExactWithRadixPoint(value);

  @override
  SExactRational toRational() {
    if (value.scale <= 0) {
      return SExactRational(radix, FlexInt.fromBigInt(value.toBigInt()), FlexInt.one);
    }
    final FlexInt num = FlexInt.fromBigInt(value.intVal);
    final FlexInt denom = FlexInt.fromBigInt(BigInt.from(10).pow(value.scale));
    return SExactRational(radix, num, denom);
  }

  @override
  double toDouble() => value.toDouble();

  @override
  String toString() => value.toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SExactWithRadixPoint &&
              value == other.value;

  @override
  int get hashCode => value.hashCode;

}

class SExactInteger extends SExactReal {
  final FlexInt value;

  const SExactInteger(super.radix, this.value);

  @override
  SExactRational toRational() => SExactRational(radix, value, FlexInt.one);

  @override
  double toDouble() => value.toDouble();

  @override
  String toString() => value.toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SExactInteger && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class SInexactReal extends SInexact {
  final double value;

  const SInexactReal(super.radix, this.value);

  @override
  SInexactComplex toComplex() =>
      SInexactComplex(radix, this, SInexactReal(radix, 0.0));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SInexactReal &&
              (value.isNaN && value.isNaN ||
              value == other.value);

  @override
  int get hashCode => value.hashCode;
}

class SExactComplex extends SExact {
  final SExactReal real;
  final SExactReal imag;

  const SExactComplex(super.radix, this.real, this.imag);

  @override
  SExactComplex toComplex() => this;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SExactComplex &&
              real == other.real && imag == other.imag;

  @override
  int get hashCode => Object.hash(real, imag);

}

class SInexactComplex extends SInexact {
  final SInexactReal real;
  final SInexactReal imag;

  SInexactComplex(super.radix, this.real, this.imag);

  @override
  SInexactComplex toComplex() => this;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SInexactComplex &&
              real == other.real && imag == other.imag;

  @override
  int get hashCode => Object.hash(real, imag);
}

/// Tag for exact or inexact numbers
enum Exactness {
  /// an exact number
  exact("#e"),
  /// an inexact number
  inexact("#i");

  final String prefix;

  Parser<(String, Exactness)> exactnessParser() =>
    string(prefix, ignoreCase: true).map((s) => (s, this));

  const Exactness(this.prefix);
}
