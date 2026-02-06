import "package:dart_scheme/dart_scheme/numbers.dart";
import "package:dart_scheme/dart_scheme/parser.dart";
import "package:dart_scheme/dart_scheme/unparsed_numbers.dart" as upn;
import "package:dartcheck/gen.dart";

/// Generates random Radixes
Gen<Radix> radixes = Gen.oneOf(Radix.values);

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
Gen<upn.Suffix> suffix = Gen.string(1, 5, Radix.dec.legalDigits).flatMap(
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
  ]).flatMap((String n) => Gen.oneOf(["f", "F"]).map((String f) => "$i$n$f.0")),
);

/// Generates "nan" in all possible capitalizations
Gen<String> nan = Gen.oneOf(["n", "N"]).flatMap(
  (String n1) => Gen.oneOf(["a", "A"]).flatMap(
    (String a) => Gen.oneOf(["n", "N"]).map((String n2) => "$n1$a$n2.0"),
  ),
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
            Gen.cnst("").map((s) => null),
            4,
            uinteger(Radix.dec).map((n) => n.input),
          ).flatMap(
            (String? right) => optSuffix.map((upn.Suffix suffix) {
              final upn.Suffix nonEmptySuffix = suffix.input == ""
                  ? upn.Suffix("E0")
                  : suffix;
              return upn.WithRadixPoint(left, right, nonEmptySuffix);
            }),
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

Gen<upn.RealString> ureal(Radix r) {
  if (r == Radix.dec) {
    return Gen.frequency([(1, decimal), (1, ufrac(r)), (1, uinteger(r))]);
  } else {
    return Gen.frequency([(1, ufrac(r)), (1, uinteger(r))]);
  }
}

Gen<upn.RealString> signedUreal(Radix r) => optSign.flatMap(
  (String sign) => ureal(
    r,
  ).map((upn.RealString n) => sign == "-" ? n.negate() as upn.RealString : n),
);

Gen<String> iI = Gen.oneOf(["i", "I"]);

Gen<upn.RealString> real(Radix r, Exactness ex) {
  if (ex == Exactness.inexact) {
    return Gen.frequency2(19, signedUreal(r), 1, infnan);
  } else {
    return signedUreal(r);
  }
}

Gen<upn.ComplexString> complex(Radix r, Exactness ex) {
  final List<(int, Gen<upn.ComplexString>)> gens = [
    (1, Gen.cnst(upn.comp("-i", upn.zero(r, ""), upn.negOne(r, "")))),
    (1, Gen.cnst(upn.comp("+i", upn.zero(r, ""), upn.one(r, "")))),
    (
      2,
      sign.flatMap(
        (String s) => ureal(r).flatMap(
          (upn.RealString ns) => iI.map(
            (String i) => upn.comp("$s${ns.input}$i", upn.zero(r, ""), ns),
          ),
        ),
      ),
    ),
    (
      2,
      real(r, ex).flatMap(
        (upn.RealString rl) => sign.flatMap(
          (String sign) => iI.map(
            (String i) => upn.comp(
              "${rl.input}$sign$i",
              rl,
              sign == "-" ? upn.negOne(r, "") : upn.one(r, ""),
            ),
          ),
        ),
      ),
    ),
    (
      5,
      real(r, ex).flatMap(
        (upn.RealString rl) => sign.flatMap(
          (String s) => ureal(r).flatMap(
            (upn.RealString im) => iI.map(
              (String i) => upn.comp(
                "${rl.input}$s${im.input}$i",
                rl,
                s == "-" ? im.negate() as upn.RealString : im,
              ),
            ),
          ),
        ),
      ),
    ),
  ];
  if (ex == Exactness.inexact) {
    gens
      ..add((
        1,
        infnan.map(
          (upn.WeirdNum wn) => upn.comp("${wn.input}i", upn.zero(r, ""), wn),
        ),
      ))
      ..add((
        1,
        real(r, ex).flatMap(
          (upn.RealString rl) => infnan.flatMap(
            (upn.WeirdNum wn) => iI.map(
              (String i) => upn.comp("${rl.input}${wn.input}$i", rl, wn),
            ),
          ),
        ),
      ));
  }
  return Gen.frequency(gens);
}

Gen<(String, Exactness)> exactnessPrefix(Radix r) {
  if (r != Radix.dec) {
    return Gen.oneOf(Exactness.values).flatMap(
      (ex) => Gen.frequency2(
        1,
        Gen.cnst((ex.prefix, ex)),
        1,
        Gen.cnst((ex.prefix.toUpperCase(), ex)),
      ),
    );
  } else {
    final List<(String, Exactness)> decs =
        Exactness.values.map((ex) => (ex.prefix, ex)).toList()
          ..add(("", Exactness.exact));
    return Gen.oneOf(decs).flatMap(
      ((String, Exactness) se) => Gen.frequency([
        (1, Gen.cnst(se)),
        (1, Gen.cnst((se.$1.toUpperCase(), se.$2))),
        (2, Gen.cnst(se)),
      ]),
    );
  }
}

Gen<(String, Radix)> radixPrefix(Radix r) {
  if (r != Radix.dec) {
    return Gen.frequency2(
      1,
      Gen.cnst((r.prefix, r)),
      1,
      Gen.cnst((r.prefix.toUpperCase(), r)),
    );
  } else {
    return Gen.frequency([
      (1, Gen.cnst((r.prefix, r))),
      (1, Gen.cnst((r.prefix.toUpperCase(), r))),
      (2, Gen.cnst(("", r))),
    ]);
  }
}

Gen<upn.Prefix> prefixes(Radix r) => radixPrefix(r).flatMap(
  (rp) => exactnessPrefix(r).flatMap(
    (ep) => Gen.frequency2(
      1,
      Gen.cnst("${ep.$1}${rp.$1}").map((s) => upn.Prefix(s, rp.$2, ep.$2)),
      1,
      Gen.cnst("${rp.$1}${ep.$1}").map((s) => upn.Prefix(s, rp.$2, ep.$2)),
    ),
  ),
);

Gen<upn.PrefixedNumString> prefixedNumStrings(Radix r) => prefixes(r).flatMap(
  (p) => complex(r, p.exactness).map((c) => upn.PrefixedNumString(p, c)),
);

