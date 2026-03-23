import "package:checks/checks.dart";
import "package:dart_scheme/dart_scheme/parsing/ast.dart";
import "package:dart_scheme/dart_scheme/parsing/numbers.dart";
import "package:dart_scheme/dart_scheme/parsing/parser.dart";
import "package:dart_scheme/dart_scheme/parsing/unparsed_numbers.dart";
import "package:dartcheck/gen.dart";
import "package:dartcheck/prop.dart";
import "package:petitparser/parser.dart";
import "package:test/test.dart";

import "generators.dart" as scheme_gen;
import "result_checks_helpers.dart";

void main() {
  final SchemeGrammar g = SchemeGrammar();

  final Map<(Radix, Parser Function(Radix)), Parser> memoTable = {};

  Parser<T> getParser<T>(Radix r, Parser<T> Function(Radix) parserGetter) {
    if (!memoTable.containsKey((r, parserGetter))) {
      memoTable[(r, parserGetter)] = g.buildFrom(parserGetter(r));
    }
    return memoTable[(r, parserGetter)] as Parser<T>;
  }

  group("parsing numbers", () {
    final Parser<SNumber> p = g.buildFrom(g.number()).end();

    forAll(scheme_gen.radixes.flatMap(scheme_gen.prefixedNumStrings))
        .test("all kinds of numbers", (PrefixedNumString pns) {
          check(
              p.parse(pns.input),
          ).succeeds(
              SNumber(SNumberValue.make(pns), pns.input, 0, pns.input.length),
              0,
          );
    });

  });

  group("testing NumStrings with generators", () {
    final Gen<(Radix, IntString)> uints = scheme_gen.radixes.flatMap(
      (Radix r) => scheme_gen.uinteger(r).map((IntString n) => (r, n)),
    );

    forAll(uints).test("unsigned integers", ((Radix, IntString) rn) {
      check(
        getParser(rn.$1, g.uinteger).parse(rn.$2.input),
      ).succeeds(rn.$2, rn.$2.input.length);
    });

    final Gen<(Radix, FracString)> ufracs = scheme_gen.radixes.flatMap(
      (Radix r) => scheme_gen.ufrac(r).map((FracString n) => (r, n)),
    );

    forAll(ufracs).test("unsigned fractions", ((Radix, FracString) rf) {
      check(
        getParser(rf.$1, g.ufrac).parse(rf.$2.input),
      ).succeeds(rf.$2, rf.$2.input.length);
    });

    final Gen<ComplexString> complexNumbers =
        scheme_gen.radixes.flatMap((r) =>
            scheme_gen.prefixes(r).flatMap((p) =>
                scheme_gen.complex(r, p.exactness)));

    forAll(complexNumbers).test("complex numbers parse", (ComplexString cs) {
      check(
        getParser(cs.radix, g.complex).parse(cs.input),
      ).succeeds(cs, cs.input.length);
    });

    forAll(scheme_gen.radixes.flatMap(scheme_gen.prefixes)).test(
      "prefixes parse",
      (Prefix p) {
        check(
          getParser(p.radix, g.prefix).parse(p.input),
        ).succeeds(p, p.input.length);
      },
    );
  });

  group("parsing parts of numbers", () {
    test("digits", () {
      final Parser<String> p2 = g.buildFrom(g.digit(Radix.bin).end());
      final Parser<String> p8 = g.buildFrom(g.digit(Radix.oct).end());
      final Parser<String> p10 = g.buildFrom(g.digit(Radix.dec).end());
      final Parser<String> p16 = g.buildFrom(g.digit(Radix.hex).end());

      check(p2.parse("0")).succeeds("0", 1);
      check(p2.parse("1")).succeeds("1", 1);
      check(p2.parse("2")).fails("[01] expected", 0);

      check(p8.parse("0")).succeeds("0", 1);
      check(p8.parse("1")).succeeds("1", 1);
      check(p8.parse("2")).succeeds("2", 1);
      check(p8.parse("3")).succeeds("3", 1);
      check(p8.parse("4")).succeeds("4", 1);
      check(p8.parse("5")).succeeds("5", 1);
      check(p8.parse("6")).succeeds("6", 1);
      check(p8.parse("7")).succeeds("7", 1);
      check(p8.parse("8")).fails("[0-7] expected", 0);

      check(p10.parse("0")).succeeds("0", 1);
      check(p10.parse("1")).succeeds("1", 1);
      check(p10.parse("2")).succeeds("2", 1);
      check(p10.parse("3")).succeeds("3", 1);
      check(p10.parse("4")).succeeds("4", 1);
      check(p10.parse("5")).succeeds("5", 1);
      check(p10.parse("6")).succeeds("6", 1);
      check(p10.parse("7")).succeeds("7", 1);
      check(p10.parse("8")).succeeds("8", 1);
      check(p10.parse("9")).succeeds("9", 1);
      check(p10.parse("a")).fails("[0-9] expected", 0);

      check(p16.parse("0")).succeeds("0", 1);
      check(p16.parse("1")).succeeds("1", 1);
      check(p16.parse("2")).succeeds("2", 1);
      check(p16.parse("3")).succeeds("3", 1);
      check(p16.parse("4")).succeeds("4", 1);
      check(p16.parse("5")).succeeds("5", 1);
      check(p16.parse("6")).succeeds("6", 1);
      check(p16.parse("7")).succeeds("7", 1);
      check(p16.parse("8")).succeeds("8", 1);
      check(p16.parse("9")).succeeds("9", 1);
      check(p16.parse("a")).succeeds("a", 1);
      check(p16.parse("A")).succeeds("A", 1);
      check(p16.parse("b")).succeeds("b", 1);
      check(p16.parse("B")).succeeds("B", 1);
      check(p16.parse("c")).succeeds("c", 1);
      check(p16.parse("C")).succeeds("C", 1);
      check(p16.parse("d")).succeeds("d", 1);
      check(p16.parse("D")).succeeds("D", 1);
      check(p16.parse("e")).succeeds("e", 1);
      check(p16.parse("E")).succeeds("E", 1);
      check(p16.parse("f")).succeeds("f", 1);
      check(p16.parse("F")).succeeds("F", 1);
      check(p16.parse("g")).fails("[0-9a-f] (case-insensitive) expected", 0);
    });

    test("unsigned integers", () {
      final Parser<IntString> p2 = getParser(Radix.bin, g.uinteger);
      final Parser<IntString> p8 = getParser(Radix.oct, g.uinteger);
      final Parser<IntString> p10 = getParser(Radix.dec, g.uinteger);
      final Parser<IntString> p16 = getParser(Radix.hex, g.uinteger);

      check(
        p2.parse("1010010001110101010"),
      ).succeeds(binInt("1010010001110101010"), 19);
      check(
        p2.parse("00110000100000011001"),
      ).succeeds(binInt("00110000100000011001"), 20);
      check(
        p2.parse("010010010000111100"),
      ).succeeds(binInt("010010010000111100"), 18);
      check(p2.parse("11001")).succeeds(binInt("11001"), 5);
      check(
        p2.parse("1110111011010100000"),
      ).succeeds(binInt("1110111011010100000"), 19);
      check(p2.parse("101100111")).succeeds(binInt("101100111"), 9);
      check(p2.parse("01001")).succeeds(binInt("01001"), 5);
      check(
        p2.parse("001000011111001110"),
      ).succeeds(binInt("001000011111001110"), 18);
      check(p2.parse("01")).succeeds(binInt("01"), 2);
      check(
        p2.parse("01100101000100001"),
      ).succeeds(binInt("01100101000100001"), 17);

      check(
        p8.parse("571544000017171373"),
      ).succeeds(octInt("571544000017171373"), 18);
      check(p8.parse("774")).succeeds(octInt("774"), 3);
      check(
        p8.parse("1217131723537242472"),
      ).succeeds(octInt("1217131723537242472"), 19);
      check(p8.parse("4231242")).succeeds(octInt("4231242"), 7);
      check(p8.parse("74541127")).succeeds(octInt("74541127"), 8);
      check(p8.parse("3441")).succeeds(octInt("3441"), 4);
      check(p8.parse("21")).succeeds(octInt("21"), 2);
      check(
        p8.parse("413530505524137271"),
      ).succeeds(octInt("413530505524137271"), 18);
      check(p8.parse("352423")).succeeds(octInt("352423"), 6);
      check(
        p8.parse("20545123551014707"),
      ).succeeds(octInt("20545123551014707"), 17);

      check(p10.parse("02212102")).succeeds(decInt("02212102"), 8);
      check(p10.parse("2735601887")).succeeds(decInt("2735601887"), 10);
      check(
        p10.parse("766543528993103"),
      ).succeeds(decInt("766543528993103"), 15);
      check(p10.parse("55343006475")).succeeds(decInt("55343006475"), 11);
      check(p10.parse("0")).succeeds(decInt("0"), 1);
      check(p10.parse("709918886814")).succeeds(decInt("709918886814"), 12);
      check(p10.parse("118")).succeeds(decInt("118"), 3);
      check(p10.parse("0923891836440")).succeeds(decInt("0923891836440"), 13);
      check(
        p10.parse("203174411258013149"),
      ).succeeds(decInt("203174411258013149"), 18);
      check(p10.parse("51")).succeeds(decInt("51"), 2);

      check(p16.parse("335F23D525")).succeeds(hexInt("335F23D525"), 10);
      check(
        p16.parse("aF9cdfcDC69E599C9"),
      ).succeeds(hexInt("aF9cdfcDC69E599C9"), 17);
      check(p16.parse("AAeBBeC")).succeeds(hexInt("AAeBBeC"), 7);
      check(p16.parse("FcbaF2643Ac23")).succeeds(hexInt("FcbaF2643Ac23"), 13);
      check(p16.parse("9aAE779a18a1")).succeeds(hexInt("9aAE779a18a1"), 12);
      check(p16.parse("0cBc8b8Eb")).succeeds(hexInt("0cBc8b8Eb"), 9);
      check(p16.parse("daA8d")).succeeds(hexInt("daA8d"), 5);
      check(p16.parse("72")).succeeds(hexInt("72"), 2);
      check(p16.parse("4d55B4")).succeeds(hexInt("4d55B4"), 6);
      check(p16.parse("AB888ed5A88")).succeeds(hexInt("AB888ed5A88"), 11);
    });

    // R7RS only allows base-10 decimals. Need to decide if we want to allow
    // other bases.
    test("unsigned decimals", () {
      final Parser<WithRadixPoint> p = g.buildFrom(g.decimal(Radix.dec).end());

      check(p.parse("0.")).succeeds(decPoint("0", null, ""), 2);
      check(p.parse(".0")).succeeds(decPoint("", "0", ""), 2);
      check(p.parse("0.e17")).succeeds(decPoint("0", null, "e17"), 5);
      check(p.parse("3.14159")).succeeds(decPoint("3", "14159", ""), 7);
      check(p.parse("6.023E23")).succeeds(decPoint("6", "023", "E23"), 8);
      check(
        p.parse("6.62607015e-34"),
      ).succeeds(decPoint("6", "62607015", "e-34"), 14);
      check(p.parse("250")).fails('"e" (case-insensitive) expected', 3);
    });

    test("ureal", () {
      final Parser<NumString> p2 = getParser(Radix.bin, g.ureal);
      final Parser<NumString> p8 = getParser(Radix.oct, g.ureal);
      final Parser<NumString> p10 = getParser(Radix.dec, g.ureal);
      final Parser<NumString> p16 = getParser(Radix.hex, g.ureal);

      check(p2.parse("101")).succeeds(binInt("101"), 3);
      check(p2.parse("11/100")).succeeds(binFrac("11", "100"), 6);
      check(p8.parse("72")).succeeds(octInt("72"), 2);
      check(p8.parse("32/10")).succeeds(octFrac("32", "10"), 5);
      check(p16.parse("FF")).succeeds(hexInt("FF"), 2);
      check(p16.parse("ff/10e")).succeeds(hexFrac("ff", "10e"), 6);

      check(p10.parse("321")).succeeds(decInt("321"), 3);
      check(p10.parse("321E+7")).succeeds(decPoint("321", null, "E+7"), 6);
      check(p10.parse("3.21E-3")).succeeds(decPoint("3", "21", "E-3"), 7);
      check(p10.parse(".321E128")).succeeds(decPoint("", "321", "E128"), 8);
    });

    test("real", () {
      final Parser<NumString> p2 = getParser(Radix.bin, g.real);
      final Parser<NumString> p8 = getParser(Radix.oct, g.real);
      final Parser<NumString> p10 = getParser(Radix.dec, g.real);
      final Parser<NumString> p16 = getParser(Radix.hex, g.real);

      check(p2.parse("-101")).succeeds(binInt("-101"), 4);
      check(p2.parse("-11/100")).succeeds(binFrac("-11", "100"), 7);
      check(p2.parse("+101")).succeeds(binInt("101"), 4);
      check(p2.parse("11/100")).succeeds(binFrac("11", "100"), 6);

      check(p8.parse("+72")).succeeds(octInt("72"), 3);
      check(p8.parse("-32/10")).succeeds(octFrac("-32", "10"), 6);
      check(p8.parse("72")).succeeds(octInt("72"), 2);

      check(p16.parse("FF")).succeeds(hexInt("FF"), 2);
      check(p16.parse("ff/10e")).succeeds(hexFrac("ff", "10e"), 6);
      check(p16.parse("-FF")).succeeds(hexInt("-FF"), 3);
      check(p16.parse("+ff/10e")).succeeds(hexFrac("ff", "10e"), 7);

      check(p10.parse("-321")).succeeds(decInt("-321"), 4);
      check(p10.parse("-321E+7")).succeeds(decPoint("-321", null, "E+7"), 7);
      check(p10.parse("+3.21E-3")).succeeds(decPoint("3", "21", "E-3"), 8);
      check(p10.parse(".321e128")).succeeds(decPoint("", "321", "e128"), 8);
      check(p10.parse("22/7")).succeeds(decFrac("22", "7"), 4);
      check(p10.parse("-3/4")).succeeds(decFrac("-3", "4"), 4);
    });

    test("real numbers parsed by complex rule", () {
      final Parser<NumString> p2 = getParser(Radix.bin, g.complex);
      final Parser<NumString> p8 = getParser(Radix.oct, g.complex);
      final Parser<NumString> p10 = getParser(Radix.dec, g.complex);
      final Parser<NumString> p16 = getParser(Radix.hex, g.complex);

      // Repeat parsers for real
      check(p2.parse("-101")).succeeds(binInt("-101"), 4);
      check(p2.parse("-11/100")).succeeds(binFrac("-11", "100"), 7);
      check(p2.parse("+101")).succeeds(binInt("101"), 4);
      check(p2.parse("11/100")).succeeds(binFrac("11", "100"), 6);

      check(p8.parse("+72")).succeeds(octInt("72"), 3);
      check(p8.parse("-32/10")).succeeds(octFrac("-32", "10"), 6);
      check(p8.parse("72")).succeeds(octInt("72"), 2);

      check(p16.parse("FF")).succeeds(hexInt("FF"), 2);
      check(p16.parse("ff/10e")).succeeds(hexFrac("ff", "10e"), 6);
      check(p16.parse("-FF")).succeeds(hexInt("-FF"), 3);
      check(p16.parse("+ff/10e")).succeeds(hexFrac("ff", "10e"), 7);

      check(p10.parse("-321")).succeeds(decInt("-321"), 4);
      check(p10.parse("-321E+7")).succeeds(decPoint("-321", null, "E+7"), 7);
      check(p10.parse("+3.21E-3")).succeeds(decPoint("3", "21", "E-3"), 8);
      check(p10.parse(".321e128")).succeeds(decPoint("", "321", "e128"), 8);
      check(p10.parse("22/7")).succeeds(decFrac("22", "7"), 4);
      check(p10.parse("-3/4")).succeeds(decFrac("-3", "4"), 4);

      // inf and nan
      check(p10.parse("+inf.0")).succeeds(inf("+inf.0"), 6);
      check(p10.parse("-INF.0")).succeeds(negInf("-INF.0"), 6);
      check(p10.parse("+NaN.0")).succeeds(nan("+NaN.0"), 6);
      check(p10.parse("-naN.0")).succeeds(nan("-naN.0"), 6);
    });

    test("+/- i and infnan i", () {
      final Parser<NumString> p2 = getParser(Radix.bin, g.complex);
      final Parser<NumString> p8 = getParser(Radix.oct, g.complex);
      final Parser<NumString> p10 = getParser(Radix.dec, g.complex);
      final Parser<NumString> p16 = getParser(Radix.hex, g.complex);

      check(
        p2.parse("+i"),
      ).succeeds(comp("+i", zero(Radix.bin, ""), one(Radix.bin, "")), 2);
      check(
        p2.parse("-I"),
      ).succeeds(comp("-I", zero(Radix.bin, ""), negOne(Radix.bin, "")), 2);
      check(
        p2.parse("+INF.0i"),
      ).succeeds(comp("+INF.0i", zero(Radix.bin, ""), inf("+INF.0")), 7);
      check(
        p2.parse("-nan.0i"),
      ).succeeds(comp("-nan.0i", zero(Radix.bin, ""), nan("-nan.0")), 7);

      check(
        p8.parse("+I"),
      ).succeeds(comp("+I", zero(Radix.oct, ""), one(Radix.oct, "")), 2);
      check(
        p8.parse("-i"),
      ).succeeds(comp("-i", zero(Radix.oct, ""), negOne(Radix.oct, "")), 2);
      check(
        p8.parse("-Inf.0i"),
      ).succeeds(comp("-Inf.0i", zero(Radix.oct, ""), negInf("-Inf.0")), 7);
      check(
        p8.parse("+NAN.0i"),
      ).succeeds(comp("+NAN.0i", zero(Radix.oct, ""), nan("+NAN.0")), 7);

      check(
        p10.parse("+I"),
      ).succeeds(comp("+I", zero(Radix.dec, ""), one(Radix.dec, "")), 2);
      check(
        p10.parse("-i"),
      ).succeeds(comp("-i", zero(Radix.dec, ""), negOne(Radix.dec, "")), 2);
      check(
        p10.parse("+inf.0i"),
      ).succeeds(comp("+inf.0i", zero(Radix.dec, ""), inf("+inf.0")), 7);
      check(
        p10.parse("-NAN.0i"),
      ).succeeds(comp("-NAN.0i", zero(Radix.dec, ""), nan("-NAN.0")), 7);

      check(
        p16.parse("+I"),
      ).succeeds(comp("+I", zero(Radix.hex, ""), one(Radix.hex, "")), 2);
      check(
        p16.parse("-i"),
      ).succeeds(comp("-i", zero(Radix.hex, ""), negOne(Radix.hex, "")), 2);
      check(
        p16.parse("+inf.0i"),
      ).succeeds(comp("+inf.0i", zero(Radix.hex, ""), inf("+inf.0")), 7);
      check(
        p16.parse("-NAN.0i"),
      ).succeeds(comp("-NAN.0i", zero(Radix.hex, ""), nan("-NAN.0")), 7);
    });
  });
}
