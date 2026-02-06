import "package:checks/checks.dart";
import "package:dart_scheme/dart_scheme/ast.dart";
import "package:dart_scheme/dart_scheme/error_messages.dart" as error_messages;
import "package:dart_scheme/dart_scheme/numbers.dart";
import "package:dart_scheme/dart_scheme/parser.dart";
import "package:petitparser/petitparser.dart";
import "package:petitparser/reflection.dart";
import "package:test/test.dart";

import "result_checks_helpers.dart";

void main() {
  final g = SchemeGrammar();

  test("linter", () {
    final Parser p = g.build();
    check(linter(p)).isEmpty();
  });

  group("parsing primitives", () {
    test("identifiers", () {
      final Parser<SExpr<String>> p = g.buildFrom(g.identifier().end());
      check(p.parse("a")).succeeds("a", SExprType.symbol, "a", 0, 1);
      check(p.parse("|H\\x65;llo|")).succeeds(
        "|H\\x65;llo|",
        SExprType.symbol,
        "Hello",
        0,
        "|H\\x65;llo|".length,
      );
      check(p.parse("+")).succeeds("+", SExprType.symbol, "+", 0, 1);
      check(p.parse("a")).succeeds("a", SExprType.symbol, "a", 0, 1);
    });

    test("booleans", () {
      final Parser<SExpr<bool>> p = g.buildFrom(g.boolean().end());

      check(p.parse("#t")).succeeds("#t", SExprType.boolean, true, 0, 2);
      check(p.parse("#true")).succeeds("#true", SExprType.boolean, true, 0, 5);
      check(p.parse("#f")).succeeds("#f", SExprType.boolean, false, 0, 2);
      check(
        p.parse("#false"),
      ).succeeds("#false", SExprType.boolean, false, 0, 6);

      check(p.parse("")).fails(error_messages.boolean, 0);
      check(p.parse("true")).fails(error_messages.boolean, 0);
      check(p.parse("#T")).fails(error_messages.boolean, 0);
      check(p.parse("#ft")).fails(error_messages.eof, 2);
    });

    test("characters", () {
      final Parser<SExpr<String>> p = g.buildFrom(g.character().end());

      final String alarm = r"#\alarm";
      check(
        p.parse(alarm),
      ).succeeds(alarm, SExprType.char, "\u0007", 0, alarm.length);
      final String backspace = r"#\backspace";
      check(
        p.parse(backspace),
      ).succeeds(backspace, SExprType.char, "\u0008", 0, backspace.length);
      final String delete = r"#\delete";
      check(
        p.parse(delete),
      ).succeeds(delete, SExprType.char, "\u007f", 0, delete.length);
      final String escape = r"#\escape";
      check(
        p.parse(escape),
      ).succeeds(escape, SExprType.char, "\u001b", 0, escape.length);
      final String newline = r"#\newline";
      check(
        p.parse(newline),
      ).succeeds(newline, SExprType.char, "\u000a", 0, newline.length);
      final String nul = r"#\null";
      check(
        p.parse(nul),
      ).succeeds(nul, SExprType.char, "\u0000", 0, nul.length);
      final String retn = r"#\return";
      check(
        p.parse(retn),
      ).succeeds(retn, SExprType.char, "\u000d", 0, retn.length);
      final String space = r"#\space";
      check(
        p.parse(space),
      ).succeeds(space, SExprType.char, "\u0020", 0, space.length);
      final String tab = r"#\tab";
      check(
        p.parse(tab),
      ).succeeds(tab, SExprType.char, "\u0009", 0, tab.length);
      final String capA = r"#\A";
      check(p.parse(capA)).succeeds(capA, SExprType.char, "A", 0, capA.length);
      final String hexForA = r"#\x41;";
      check(
        p.parse(hexForA),
      ).succeeds(hexForA, SExprType.char, "A", 0, hexForA.length);
      final String cyrillicC = "#\\\u0421";
      check(
        p.parse(cyrillicC),
      ).succeeds(cyrillicC, SExprType.char, "\u0421", 0, cyrillicC.length);
      final String rocketAsSurr = "#\\\ud83d\uDE80";
      check(p.parse("#\\\ud83d\uDE80")).succeeds(
        rocketAsSurr,
        SExprType.char,
        "\u{1f680}",
        0,
        rocketAsSurr.length,
      );
      final String rocketAsCodePt = "#\\\u{1f680}";
      check(p.parse(rocketAsCodePt)).succeeds(
        rocketAsCodePt,
        SExprType.char,
        "\ud83d\uDE80",
        0,
        rocketAsCodePt.length,
      );
      final String spaceAwk = r"#\ ";
      check(
        p.parse(spaceAwk),
      ).succeeds(spaceAwk, SExprType.char, " ", 0, spaceAwk.length);
      final String newlineAwk = "#\\\n";
      check(
        p.parse(newlineAwk),
      ).succeeds(newlineAwk, SExprType.char, "\n", 0, newlineAwk.length);
    });

    test("strings", () {
      final Parser<SExpr<String>> p = g.buildFrom(g.sString().end());

      final String empty = '""';
      check(
        p.parse(empty),
      ).succeeds(empty, SExprType.string, "", 0, empty.length);
      final String escapes = '"\\"\\n\\\\"';
      check(
        p.parse(escapes),
      ).succeeds(escapes, SExprType.string, '"\n\\', 0, escapes.length);
      final String withSlashToSuppressNewline =
          r'"abc\'
          "\n"
          r'123"';
      check(p.parse(withSlashToSuppressNewline)).succeeds(
        withSlashToSuppressNewline,
        SExprType.string,
        "abc123",
        0,
        withSlashToSuppressNewline.length,
      );
      final String simpleString = '"abc123"';
      check(p.parse(simpleString)).succeeds(
        simpleString,
        SExprType.string,
        "abc123",
        0,
        simpleString.length,
      );
      final String unicodeMess = '"⁭╳⌦⒲∛≥⥂⧹⅂⊇⇐⦨⑟⎫⭰⯊⾕⳰✪↢❯♁⮶⪎"';
      check(p.parse(unicodeMess)).succeeds(
        unicodeMess,
        SExprType.string,
        "⁭╳⌦⒲∛≥⥂⧹⅂⊇⇐⦨⑟⎫⭰⯊⾕⳰✪↢❯♁⮶⪎",
        0,
        unicodeMess.length,
      );
      final String surrogatePairs = '"🍗🍋🍦🍥🍅🌭🍤🍫🍎🍱"';
      check(p.parse(surrogatePairs)).succeeds(
        surrogatePairs,
        SExprType.string,
        "🍗🍋🍦🍥🍅🌭🍤🍫🍎🍱",
        0,
        surrogatePairs.length,
      );
    });

    test("parsing bytevector", () {
      final Parser<SExpr<SList<SExpr<SNumber>>>> p = g.buildFrom(
        g.byteVector().end(),
      );
      check(
        p.parse("#u8()"),
      ).succeeds("#u8()", SExprType.byteVector, SList([]), 0, 5);
      final String bv = "#u8(0 128 255)";
      check(p.parse(bv)).succeeds(
        bv,
        SExprType.byteVector,
        SList([
          Atom(
            Token(SExactInteger(Radix.dec, BigInt.zero), "0", 4, 5),
            SExprType.number,
          ),
          Atom(
            Token(SExactInteger(Radix.dec, BigInt.from(128)), "128", 6, 9),
            SExprType.number,
          ),
          Atom(
            Token(SExactInteger(Radix.dec, maxByte), "255", 10, 13),
            SExprType.number,
          ),
        ]),
        0,
        bv.length,
      );
      final String bad = "#u8(0 128 256)";
      check(p.parse(bad)).fails('")" expected', 10);
    });

    test("parsing sByte", () {
      final Parser<SExpr<SNumber>> p = g.buildFrom(g.sByte().end());
      check(p.parse("0")).succeeds(
        "0",
        SExprType.number,
        SExactInteger(Radix.dec, BigInt.zero),
        0,
        1,
      );
      check(p.parse("1/2")).fails(
        "Failure at [1:1]: byte-vector values must be exact integers in the range [0, 255]",
        0,
      );
      check(p.parse("-3")).fails(
        "Failure at [1:1]: byte-vector values must be exact integers in the range [0, 255]",
        0,
      );
      check(p.parse("260")).fails(
        "Failure at [1:1]: byte-vector values must be exact integers in the range [0, 255]",
        0,
      );
    });
  });
}
