import "package:dart_scheme/dart_scheme/parser.dart";
import "package:dart_scheme/dart_scheme/unparsed_numbers.dart" as upn;
import "package:dartcheck/gen.dart";

/// Generates random Radixes
Gen<Radix> radixes() => Gen.oneOf(Radix.values);

/// Generates random strings of 1-30 digits in the given Radix
Gen<upn.IntString> uinteger(Radix r) => Gen.string(
  1,
  30,
  r.legalDigits,
).map((String digits) => upn.IntString(digits, r, digits));

/// Generates "+", "-", or ""
Gen<String> optSign = Gen.oneOf(["+", "-", ""]);

/// Generates "+" or "-"
Gen<String> sign = Gen.oneOf(["+", "-"]);

/// Generates "xsd" where x is "e" or "E", s is "", "+", or "-" and
/// d is decimal digits
Gen<upn.Suffix> suffix = uinteger(Radix.dec)
    .map((n) => n.input)
    .flatMap(
      (String n) => Gen.oneOf(["e", "E"]).flatMap(
        (String e) => optSign.map((String sign) => upn.Suffix("$e$sign$n")),
      ),
    );

Gen<upn.Suffix> optSuffix = Gen.frequency2(
  1,
  Gen.cnst("").map((_) => upn.Suffix("")),
  4,
  suffix,
);

/// Generates "inf" in all possible capitalizations
Gen<String> inf = Gen.oneOf(["i", "I"]).flatMap(
  (String i) => Gen.oneOf([
    "n",
    "N",
  ]).flatMap((String n) => Gen.oneOf(["f", "F"]).map((String f) => "$i$n$f")),
);

/// Generates "nan" in all possible capitalizations
Gen<String> nan = Gen.oneOf(["n", "N"]).flatMap(
  (String n1) => Gen.oneOf(
    ["a", "A"],
  ).flatMap((String a) => Gen.oneOf(["n", "N"]).map((String n2) => "$n1$a$n2")),
);

/// Generates all possible forms of inf and nan
Gen<upn.WeirdNum> infnan = sign.flatMap(
  (String sign) => Gen.frequency([
    (
      1,
      inf.map(
        (String infCap) =>
            sign == "-" ? upn.negInf("$sign$infCap") : upn.inf("$sign$infCap"),
      ),
    ),
    (1, nan.map((String nanCap) => upn.nan("$sign$nanCap"))),
  ]),
);

Gen<upn.WithRadixPoint> decimal = Gen.frequency([
  (1, decimalWithLeft),
  (1, decimalNoLeft),
  (1, decimalWithSuffix),
]);

Gen<upn.WithRadixPoint> decimalWithLeft = uinteger(Radix.dec)
    .map((n) => n.input)
    .flatMap(
      (String left) =>
          Gen.frequency2(
            1,
            Gen.cnst(""),
            4,
            uinteger(Radix.dec).map((n) => n.input),
          ).flatMap(
            (String right) => optSuffix.map(
              (upn.Suffix suffix) => upn.WithRadixPoint(left, right, suffix),
            ),
          ),
    );

Gen<upn.WithRadixPoint> decimalNoLeft = uinteger(Radix.dec)
    .map((n) => n.input)
    .flatMap(
      (String right) => optSuffix.map(
        (upn.Suffix suffix) => upn.WithRadixPoint("", right, suffix),
      ),
    );

Gen<upn.WithRadixPoint> decimalWithSuffix = uinteger(Radix.dec)
    .map((n) => n.input)
    .flatMap(
      (String left) => suffix.map(
        (upn.Suffix suffix) => upn.WithRadixPoint(left, null, suffix),
      ),
    );

Gen<upn.FracString> ufrac(Radix r) => uinteger(r)
    .map((n) => n.input)
    .flatMap(
      (String numerator) => uinteger(r)
          .map((n) => n.input)
          .map(
            (String denominator) => upn.FracString(r, numerator, denominator),
          ),
    );

Gen<upn.NumString> ureal(Radix r) =>
    Gen.frequency([(1, decimal), (1, ufrac(r)), (1, uinteger(r))]);

Gen<upn.NumString> signedUreal(Radix r) => optSign.flatMap(
  (String sign) =>
      ureal(r).map((upn.NumString n) => sign == "-" ? n.negate() : n),
);

Gen<upn.NumString> real(Radix r) =>
    Gen.frequency2(19, signedUreal(r), 1, infnan);
