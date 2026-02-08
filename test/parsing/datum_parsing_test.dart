import "package:big_decimal/big_decimal.dart";
import "package:checks/checks.dart";
import "package:dart_scheme/dart_scheme/parsing/ast.dart";
import "package:dart_scheme/dart_scheme/parsing/numbers.dart";
import "package:dart_scheme/dart_scheme/parsing/parser.dart";
import "package:dart_scheme/dart_scheme/parsing/unparsed_numbers.dart";
import "package:dart_scheme/dart_scheme/utils.dart";
import "package:petitparser/petitparser.dart";
import "package:test/test.dart";

import "result_checks_helpers.dart";

void main() {
  final SchemeGrammar g = SchemeGrammar();

  final Parser<Datum<dynamic>> p = g.buildFrom(g.datum());

  test("parse simple datum", () {
    check(
      p.parse("#t"),
    ).succeeds(Atom(const Token(true, "#t", 0, 2), SExprType.boolean), 2);
    check(p.parse("3-2i")).succeeds(
      Atom(
            Token<SNumber>(
              SExactComplex(
                Radix.dec,
                SExactInteger(Radix.dec, BigInt.from(3)),
                SExactInteger(Radix.dec, BigInt.from(-2)),
              ),
              "3-2i",
              0,
              4,
            ),
            SExprType.number,
          )
          as Datum<dynamic>,
      4,
    );
    check(
      p.parse("#\\q"),
    ).succeeds(Atom(const Token<String>("q", "#\\q", 0, 3), SExprType.char), 3);
    check(p.parse('"abc"')).succeeds(
      Atom(const Token<String>("abc", "'abc'", 0, 5), SExprType.string),
      5,
    );
    check(
      p.parse("a"),
    ).succeeds(Atom(const Token<String>("a", "a", 0, 1), SExprType.symbol), 1);
    final String bv = "#u8(16 0)";
    check(p.parse(bv)).succeeds(
      Atom(
        Token(
          ImmutableList([
            Atom(
              Token(SExactInteger(Radix.hex, BigInt.from(16)), bv, 4, 6),
              SExprType.number,
            ),
            Atom(
              Token(SExactInteger(Radix.hex, BigInt.zero), bv, 7, 8),
              SExprType.number,
            ),
          ]),
          bv,
          0,
          9,
        ),
        SExprType.byteVector,
      ),
      9,
    );
    final String ld = "#12=a";
    check(p.parse(ld)).succeeds(
      LabelDef(
        Token(
          (
            IntString("12", Radix.dec, "12"),
            Atom(Token("a", ld, 4, 5), SExprType.symbol),
          ),
          ld,
          0,
          5,
        ),
      ),
      5,
    );
    final String lr = "#15#";
    check(
      p.parse(lr),
    ).succeeds(LabelRef(Token(IntString("15", Radix.dec, "15"), lr, 0, 4)), 4);
  });

  test("parse list, improper list, and vector", () {
    final String l = "(1 2 a)";
    check(p.parse(l)).succeeds(
      SList<dynamic>(
        Token(
          (
            ImmutableList<Datum<dynamic>>([
              Atom(
                Token(SExactInteger(Radix.dec, BigInt.one), l, 1, 2),
                SExprType.number,
              ),
              Atom(
                Token(SExactInteger(Radix.dec, BigInt.two), l, 3, 4),
                SExprType.number,
              ),
              Atom(Token("a", l, 5, 6), SExprType.symbol),
            ]),
            null,
          ),
          l,
          0,
          7,
        ),
      ),
      7,
    );
    final String il = "(1 2 . a)";
    check(p.parse(il)).succeeds(
      SList<dynamic>(
        Token(
          (
            ImmutableList<Datum<dynamic>>([
              Atom(
                Token(SExactInteger(Radix.dec, BigInt.one), il, 1, 2),
                SExprType.number,
              ),
              Atom(
                Token(SExactInteger(Radix.dec, BigInt.two), il, 3, 4),
                SExprType.number,
              ),
            ]),
            Atom(Token("a", il, 7, 8), SExprType.symbol),
          ),
          il,
          0,
          9,
        ),
      ),
      9,
    );
    final String v = '#(x 3.14 "s")';
    check(p.parse(v)).succeeds(
      SVector(
            Token(
              ImmutableList<Datum<dynamic>>([
                Atom(Token("x", v, 2, 3), SExprType.symbol),
                Atom(
                  Token(
                    SExactWithRadixPoint(BigDecimal.parse("3.14")),
                    v,
                    4,
                    8,
                  ),
                  SExprType.number,
                ),
                Atom(Token("s", v, 9, 12), SExprType.string),
              ]),
              v,
              0,
              13,
            ),
          )
          as Datum<dynamic>,
      13,
    );
  });

  test("parse abbreviations", () {
    final String q = "'a";
    check(p.parse(q)).succeeds(
      SAbbrev<dynamic>(
        Token(
          (Abbrev.quote, Atom(Token("a", q, 1, 2), SExprType.symbol)),
          q,
          0,
          2,
        ),
      ),
      2,
    );
    final String qq = "`(x 1)";
    check(p.parse(qq)).succeeds(
      SAbbrev<dynamic>(
        Token(
          (
            Abbrev.backtick,
            SList<dynamic>(
              Token(
                (
                  ImmutableList([
                    Atom(Token("x", qq, 2, 3), SExprType.symbol),
                    Atom(
                      Token(SExactInteger(Radix.dec, BigInt.one), qq, 4, 5),
                      SExprType.number,
                    ),
                  ]),
                  null,
                ),
                qq,
                1,
                6,
              ),
            ),
          ),
          qq,
          0,
          6,
        ),
      ),
      6,
    );
    final String uq = ",x";
    check(p.parse(uq)).succeeds(
      SAbbrev(
        Token(
          (Abbrev.comma, Atom(Token("x", uq, 1, 2), SExprType.symbol)),
          uq,
          0,
          2,
        ),
      ),
      2,
    );
    final String uqs = ",@(x 1)";
    check(p.parse(uqs)).succeeds(
      SAbbrev<dynamic>(
        Token(
          (
          Abbrev.commaAt,
          SList<dynamic>(
            Token(
              (
              ImmutableList([
                Atom(Token("x", uqs, 3, 4), SExprType.symbol),
                Atom(
                  Token(SExactInteger(Radix.dec, BigInt.one), uqs, 5, 6),
                  SExprType.number,
                ),
              ]),
              null,
              ),
              uqs,
              2,
              7,
            ),
          ),
          ),
          qq,
          0,
          7,
        ),
      ),
      7,
    );
  });

  test("check", () {
    final Parser<SList<dynamic>> lp = g.buildFrom(g.list());
    print(lp.parse("(1 2)"));
  });
}
