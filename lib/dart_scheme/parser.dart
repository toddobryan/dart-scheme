import 'package:big_decimal/big_decimal.dart';
import 'package:dart_scheme/dart_scheme/ast.dart';
import 'package:dart_scheme/dart_scheme/error_messages.dart' as err;
import 'package:dart_scheme/dart_scheme/numbers.dart';
import 'package:petitparser/petitparser.dart';

extension MapToParser<T1, T2> on Parser<T1> {
  Parser<T2> mapTo(T2 value) => map((t) => value);
}

class SchemeGrammar extends GrammarDefinition {
  /* SETTINGS
     allow non-base-10 values with points and exponents
  */

  @override
  Parser start() => ref(program);

  // 7.1.6 Programs and definitions

  Parser program() => ref0(commandOrDefinition).star();

  Parser commandOrDefinition() => [
    ref(command),
    ref(definition),
    ref(syntaxDefinition),
    seq3(lParen(), begin(), ref0(commandOrDefinition).plus()),
  ].toChoiceParser();

  Parser definition() => [
    seq5(lParen(), define(), variable(), ref0(expression).trim(), ref0(rParen)),
    seq8(
      lParen(),
      define(),
      lParen(),
      variable(),
      ref0(defFormals),
      rParen(),
      ref0(body),
      rParen(),
    ),
    seq4(lParen(), begin(), ref0(definition).star(), rParen()),
  ].toChoiceParser();

  Parser defFormals() =>
      seq2(variable().star(), seq2(dot(), variable()).optional());

  Parser syntaxDefinition() => seq5(
    lParen(),
    defineSyntax(),
    keyword(),
    ref0(transformerSpec),
    rParen(),
  );

  // 7.1.5 Transformers

  Parser transformerSpec() => seq6(
    lParen(),
    syntaxRules(),
    lParen(),
    identifier().star(),
    ref0(syntaxRule).star(),
    rParen(),
  );

  Parser syntaxRule() =>
      seq4(lParen(), ref0(sPattern), ref0(template), rParen());

  Parser sPattern() => [
    patternIdentifier(),
    seq3(lParen(), ref0(sPattern).star(), rParen()),
    seq5(lParen(), ref0(sPattern).plus(), dot(), ref0(sPattern), rParen()),
    seq4(lParen(), ref0(sPattern).plus(), ellipsis(), rParen()),
    seq3(hashParen(), ref0(sPattern).star(), rParen()),
    seq4(hashParen(), ref0(sPattern).plus(), ellipsis(), rParen()),
    ref0(patternDatum),
  ].toChoiceParser();

  Parser patternDatum() =>
      [sString(), character(), boolean(), number()].toChoiceParser();

  Parser template() => [
    patternIdentifier(),
    seq3(lParen(), ref0(templateElement).star(), rParen()),
    seq5(
      lParen(),
      ref0(templateElement).plus(),
      dot(),
      ref0(template),
      rParen(),
    ),
    seq3(hashParen(), ref0(templateElement).star(), rParen()),
    ref0(templateDatum),
  ].toChoiceParser();

  Parser templateElement() =>
      [ref0(template), seq2(ref0(template), ellipsis())].toChoiceParser();

  Parser templateDatum() => ref0(patternDatum);

  Parser patternIdentifier() => ellipsis().not().seq(identifier());

  // 7.1.4 Quasiquotations

  Parser quasiquotation(int depth) => [
    seq2(backtick(), ref1(qqTemplate, depth)),
    seq4(lParen(), quasiquote(), ref1(qqTemplate, depth), rParen()),
  ].toChoiceParser();

  Parser qqTemplate(int depth) {
    if (depth == 0) {
      return ref0(expression);
    } else {
      return [
        simpleDatum(),
        ref1(listQqTemplate, depth),
        ref1(vectorQqTemplate, depth),
        ref1(unquotation, depth),
      ].toChoiceParser();
    }
  }

  Parser listQqTemplate(int depth) => [
    seq3(lParen(), ref1(qqTemplateOrSplice, depth).star(), rParen()),
    seq5(
      lParen(),
      ref1(qqTemplateOrSplice, depth).plus(),
      dot(),
      ref1(qqTemplate, depth),
      rParen(),
    ),
    seq2(quote(), ref1(qqTemplate, depth)),
    ref1(quasiquotation, depth + 1),
  ].toChoiceParser();

  Parser vectorQqTemplate(int depth) =>
      seq3(hashParen(), ref1(qqTemplateOrSplice, depth).star(), rParen());

  Parser unquotation(int depth) => [
    seq2(comma(), ref1(qqTemplate, depth - 1)),
    seq4(lParen(), unquote(), ref1(qqTemplate, depth - 1), rParen()),
  ].toChoiceParser();

  Parser qqTemplateOrSplice(int depth) => [
    ref1(qqTemplate, depth),
    ref1(splicingUnquotation, depth),
  ].toChoiceParser();

  Parser splicingUnquotation(int depth) => [
    seq2(commaAt(), ref1(qqTemplate, depth - 1)),
    seq4(lParen(), unquoteSplicing(), ref1(qqTemplate, depth - 1), rParen()),
  ].toChoiceParser();

  // 7.1.3 Expressions

  Parser expression() => [
    variable(),
    ref0(literal),
    ref0(procedureCall),
    ref0(lambdaExpression),
    ref0(conditional),
    ref0(assignment),
    ref0(macroUse),
    ref0(macroBlock),
  ].toChoiceParser();

  Parser literal() => [ref0(quotation), ref0(selfEvaluating)].toChoiceParser();

  Parser selfEvaluating() => [
    ref0(boolean),
    ref0(number),
    ref0(character),
    ref0(sString),
  ].toChoiceParser();

  Parser quotation() => [
    seq2(ref0(quote), ref0(datum)),
    seq4(lParen(), ref0(quote), ref0(datum), ref0(rParen)),
  ].toChoiceParser();

  Parser procedureCall() =>
      seq4(lParen(), ref0(operator), ref0(operand).star(), ref0(rParen));

  Parser operator() => ref0(expression);

  Parser operand() => ref0(expression);

  Parser lambdaExpression() =>
      seq5(lParen(), ref0(lambda), ref0(formals), ref0(body), ref0(rParen));

  Parser formals() => [
    seq3(lParen(), variable().star(), ref0(rParen)),
    variable(),
    seq5(lParen(), variable().plus(), ref0(dot), variable(), ref0(rParen)),
  ].toChoiceParser();

  Parser body() => seq2(ref0(definition).star(), ref0(sequence));

  Parser sequence() => seq2(ref0(command).star(), ref0(expression));

  Parser command() => ref0(expression);

  Parser conditional() =>
      seq5(lParen(), ref0(test), ref0(consequent), ref0(alternate), rParen());

  Parser test() => ref0(expression);

  Parser consequent() => ref0(expression);

  Parser alternate() => ref0(expression).optional();

  Parser assignment() =>
      seq5(lParen(), setBang(), variable(), ref0(expression), rParen());

  // derived expressions come here

  Parser macroUse() => seq3(lParen(), keyword(), ref0(datum).star());

  Parser macroBlock() => [
    seq7(
      lParen(),
      letSyntax(),
      lParen(),
      ref0(syntaxSpec).star(),
      rParen(),
      ref0(body),
      rParen(),
    ),
    seq7(
      lParen(),
      letrecSyntax(),
      lParen(),
      ref0(syntaxSpec).star(),
      rParen(),
      ref0(body),
      rParen(),
    ),
  ].toChoiceParser();

  Parser syntaxSpec() =>
      seq4(lParen(), keyword(), ref0(transformerSpec), rParen());

  Parser keyword() => identifier();

  // 7.1.2 External Representations

  Parser datum() => [ref0(simpleDatum), ref0(compoundDatum)].toChoiceParser();

  Parser simpleDatum() =>
      [boolean(), number(), character(), sString(), symbol()].toChoiceParser();

  Parser symbol() => identifier();

  Parser compoundDatum() => [ref0(list), ref0(vector)].toChoiceParser();

  Parser list() => [
    seq3(lParen(), ref0(datum).star(), rParen()),
    seq5(lParen(), ref0(datum).plus(), dot(), ref0(datum), rParen()),
    ref0(abbreviation),
  ].toChoiceParser();

  Parser abbreviation() => seq2(abbrevPrefix(), ref0(datum));

  Parser abbrevPrefix() =>
      [quote(), backtick(), comma(), commaAt()].toChoiceParser();

  Parser vector() => seq3(hashParen(), ref0(datum).star(), rParen());

  // 7.1.1 Lexical Structure

  Parser sToken() => [
    identifier(),
    boolean(),
    number(),
    character(),
    sString(),
    lParen(),
    rParen(),
    hashParen(),
    hashU8Paren(),
    quote(),
    backtick(),
    comma(),
    commaAt(),
    dot(),
  ].toChoiceParser();

  Parser delimiter() => [
    sWhitespace(),
    verticalLine(),
    lParen(),
    rParen(),
    doubleQuote(),
    semicolon(),
  ].toChoiceParser();

  Parser<String> intralineWhitespace() => pattern(" \t");
  Parser<String> sWhitespace() =>
      [intralineWhitespace(), lineEnding()].toChoiceParser();
  Parser<String> lineEnding() =>
      [char("\n"), string("\r\n"), char("\r")].toChoiceParser();

  Parser<String> lParen() => char("(");
  Parser<String> rParen() => char(")");
  Parser<String> hashParen() => string("#(");
  Parser<String> hashU8Paren() => string("#u8(");
  Parser<String> backtick() => char("`");
  Parser<String> comma() => char(",");
  Parser<String> commaAt() => string(",@");
  Parser<String> dot() => char(".");
  Parser<String> verticalLine() => char("|");
  Parser<String> doubleQuote() => char('"');
  Parser<String> semicolon() => char(";");

  Parser<String> comment() => [
    seq2(char(";"), (lineEnding().not() & any()).star()).flatten(),
    nestedComment(),
    seq3(string("#;"), intertokenSpace(), ref0(datum)).flatten(),
  ].toChoiceParser();

  Parser<String> nestedComment() => seq4(
    string("#|"),
    commentText(),
    ref0(commentCont).star(),
    string("|#"),
  ).flatten();
  Parser<String> commentText() => seq2(
    [string("#|"), string("|#")].toChoiceParser().not(),
    any(),
  ).flatten();
  Parser<String> commentCont() =>
      seq2(ref0(nestedComment), commentText()).flatten();
  Parser directive() => [
    string("#!fold-case"),
    string("#!no-fold-case"),
  ].toChoiceParser().and().seq([delimiter(), eof()].toChoiceParser());

  Parser atmosphere() =>
      [sWhitespace(), comment(), directive()].toChoiceParser();
  Parser intertokenSpace() => ref0(atmosphere).star();
  Parser eof() => endOfInput();

  Parser identifier() => [
    seq2(initial(), subsequent().star()),
    seq3(verticalLine(), ref0(symbolElement).star(), verticalLine()),
    peculiarIdentifier(),
  ].toChoiceParser();

  Parser initial() => [letter(), specialInitial()].toChoiceParser();
  Parser specialInitial() => anyOf("!\$%&*/:<=>?@^_~");
  Parser subsequent() =>
      [initial(), digit(10), specialSubsequent()].toChoiceParser();
  Parser digit() => pattern("0-9");
  Parser hexDigit() =>
      [digit(), pattern("a-f", ignoreCase: true)].toChoiceParser();
  Parser explicitSign() => anyOf("+-");
  Parser specialSubsequent() => [explicitSign(), anyOf(".@")].toChoiceParser();
  Parser inlineHexEscape() => seq2(string("\\x"), hexScalarValue());
  Parser hexScalarValue() => hexDigit().plus();
  Parser mnemonicEscape() => [
    string(r"\a"),
    string(r"\b"),
    string(r"\n"),
    string(r"\r"),
    string(r"\t"),
  ].toChoiceParser();
  Parser peculiarIdentifier() => seq2(
    seq2(
      [string("+i"), string("-i"), infnan()].toChoiceParser(),
      [delimiter(), eof()].toChoiceParser(),
    ).not(),
    [
      explicitSign(),
      seq3(explicitSign(), signSubsequent(), subsequent().star()),
      seq4(explicitSign(), dot(), dotSubsequent(), subsequent().star()),
      seq3(dot(), dotSubsequent(), subsequent().star()),
    ].toChoiceParser(),
  );
  Parser dotSubsequent() => [signSubsequent(), dot()].toChoiceParser();
  Parser signSubsequent() =>
      [initial(), explicitSign(), char("@")].toChoiceParser();
  Parser symbolElement() => [
    initial(),
    mnemonicEscape(),
    char("\\"),
    pattern("^|\\"),
  ].toChoiceParser();

  Parser<bool> boolean() => [
    [string("#true"), string("#t")].toChoiceParser().mapTo(true),
    [string("#false"), string("#f")].toChoiceParser().mapTo(false),
  ].toChoiceParser() as Parser<bool>;

  Parser character() => [
    seq2(string("#\\"), characterName()),
    seq2(string("#\\x"), hexScalarValue()),
    seq2(string("#\\"), any()),
  ].toChoiceParser();
  Parser characterName() => [
    string("alarm"),
    string("backspace"),
    string("delete"),
    string("escape"),
    string("newline"),
    string("null"),
    string("return"),
    string("space"),
    string("tab"),
  ].toChoiceParser();

  Parser sString() => seq3(doubleQuote(), stringElement().star(), doubleQuote());
  Parser stringElement() => [
    inlineHexEscape(),
    seq4(char(r"\"), intralineWhitespace().star(), lineEnding(), intralineWhitespace().star()),
    mnemonicEscape(),
    string(r'\"'),
    string(r"\\"),
    string(r"\|"),
    pattern(r'^"\'),
  ].toChoiceParser();

  Parser byteVector() => seq3(hashU8Paren(), sByte().star(), rParen());
  Parser sByte() => fail("TODO") // integer value from 0-255



  Parser syntacticKeyword() => [
    expressionKeyword(),
    sElse(),
    arrow(),
    define(),
    unquote(),
    unquoteSplicing(),
    defineSyntax(),
    syntaxRules(),
    ellipsis(),
    letSyntax(),
    letrecSyntax(),
  ].toChoiceParser();

  Parser expressionKeyword() => [
    quote(),
    lambda(),
    sIf(),
    setBang(),
    begin(),
    cond(),
    and(),
    or(),
    sCase(),
    sLet(),
    letStar(),
    letrec(),
    sDo(),
    delay(),
    quasiquote(),
  ].toChoiceParser();

  Parser variable() => ref0(keyword).not().seq(identifier());

  Parser<SBoolean> boolean() =>
      [
        string("#t").token().map((t) => SBoolean(true, t)),
        string("#f").token().map((t) => SBoolean(false, t)),
      ].toChoiceParser(
        failureJoiner: (f1, f2) {
          assert(
            f1.position == f2.position,
            "the positions should be the same",
          );
          return Failure(f1.buffer, f1.position, err.boolean);
        },
      );



  Parser<SString> sString() => seq3(
    char('"'),
    ref0(stringElement).star(),
    char('"'),
  ).map3((_, chs, _) => chs.join("")).token().map((t) => SString(t.value, t));

  Parser<String> stringElement() => [
    string('\\"').map((s) => '"'),
    string('\\\\').map((s) => "\\"),
    pattern('^\\"', unicode: true),
  ].toChoiceParser();

  Parser sElse() => string("else");
  Parser arrow() => string("=>");
  Parser<String> define() => string("define");
  Parser unquote() => string("unquote");
  Parser unquoteSplicing() => string("unquote-splicing");
  Parser defineSyntax() => string("define-syntax");
  Parser syntaxRules() => string("syntax-rules");
  Parser ellipsis() => string("...");

  Parser<String> quote() => char("'");
  Parser<String> lambda() => string("lambda");
  Parser sIf() => string("if");
  Parser<String> setBang() => string("set!");
  Parser<String> begin() => string("begin");
  Parser cond() => string("cond");
  Parser and() => string("and");
  Parser or() => string("or");
  Parser sCase() => string("case");
  Parser sLet() => string("let");
  Parser letStar() => string("let*");
  Parser letrec() => string("letrec");
  Parser sDo() => string("do");
  Parser delay() => string("delay");
  Parser quasiquote() => string("quasiquote");
  Parser letSyntax() => string("let-syntax");
  Parser letrecSyntax() => string("letrec-syntax");

  // Numbers

  Parser<SNumber> number() => [
    ref1(sNum, 2),
    ref1(sNum, 8),
    ref1(sNum, 10),
    ref1(sNum, 16),
  ].toChoiceParser();

  Parser<SNumeric> sNum(int r) => seq2(ref1(prefix, r), ref1(complex, r));

  Parser plusOrMinus() => pattern("+-");

  Parser complex(int r) => [
    seq3(ref1(real, r), char("@"), ref1(real, r)),
    seq4(
      ref1(real, r),
      plusOrMinus(),
      ref(ureal, r),
      char("i", ignoreCase: true),
    ),
    seq3(ref1(real, r), plusOrMinus(), char("i", ignoreCase: true)),
    seq2(plusOrMinus(), ref1(ureal, r)),
    seq2(plusOrMinus(), char("i", ignoreCase: true)),
    ref1(real, r),
  ].toChoiceParser();

  Parser real(int r) => seq2(ref0(sign).optional(), ref1(ureal, r));

  Parser ureal(int r) => [
    ref(pointed, r),
    seq3(ref1(uinteger, r), char("/"), ref1(uinteger, r)),
    ref1(uinteger, r),
  ].toChoiceParser();

  Parser pointed(int r) => [
    seq2(ref1(uinteger, r), ref1(suffix, r)),
    seq4(
      char("."),
      ref1(digit, r).plus(),
      char("#").star(),
      ref1(suffix, r).optional(),
    ),
    seq5(
      ref1(digit, r).plus(),
      char("."),
      ref1(digit, r).star(),
      char("#").star(),
      ref1(suffix, r).optional(),
    ),
    seq5(
      ref1(digit, r).plus(),
      char("#").plus(),
      char("."),
      char("#"),
      ref1(suffix, r).optional(),
    ),
  ].toChoiceParser();

  Parser<SNumber> uinteger(int r) => seq2(ref1(digit, r), char("#").star())
      .map2(
        (digits, hashes) => // int and whether it's exact
        (
          BigInt.parse(digits + "0" * hashes.length, radix: r),
          hashes.isEmpty,
        ),
      )
      .token()
      .map((Token<(BigInt, bool)> t) {
        var (bi, isExact) = t.value;
        Token<String> stringToken = t.toStringToken;
        return isExact
            ? SNumber(SInt(bi), stringToken)
            : SNumber(SDouble(bi.toDouble()), stringToken);
      });

  Parser<(int, Exactness)> prefix(int r) => [
    seq2(
      ref1(radix, r),
      ref0(exactness).optionalWith(Exactness.exact),
    ).map2((rad, isExact) => (rad, isExact)),
    seq2(
      ref0(exactness).optionalWith(Exactness.exact),
      ref1(radix, r),
    ).map2((isExact, rad) => (rad, isExact)),
  ].toChoiceParser();

  Parser suffix(int r) => seq3(
    ref1(exponentMarker, r),
    ref0(sign).optional(),
    ref1(digit, r).plus(),
  );

  Parser exponentMarker(int r) {
    if (r == 16) {
      return anyOf("ls", ignoreCase: true);
    } else {
      return anyOf("defls", ignoreCase: true);
    }
  }

  Parser sign() => anyOf("+-");

  Parser<Exactness> exactness() => seq2(
    char("#"),
    char("e", ignoreCase: true).mapTo(Exactness.exact) |
        char("i", ignoreCase: true).mapTo(Exactness.inexact),
  ).map2((_, ex) => ex);

  // TODO: clean up the cases
  Parser<int> radix(int r) {
    if (r == 2) {
      return seq2(char("#"), char("b", ignoreCase: true)).map((_) => 2);
    } else if (r == 8) {
      return seq2(char("#"), char("o", ignoreCase: true)).map((_) => 8);
    } else if (r == 10) {
      return [
        seq2(char("#"), char("d", ignoreCase: true)),
        epsilon(),
      ].toChoiceParser().map((_) => 10);
    } else if (r == 16) {
      return seq2(char("#"), char("x", ignoreCase: true)).map((_) => 16);
    } else {
      throw ArgumentError(
        "only a radix of 2, 8, 10, or 16 is allowed, given $r",
      );
    }
  }

  Parser digit(int r) {
    if (r == 2) {
      return anyOf("01");
    } else if (r == 8) {
      return anyOf("01234567");
    } else if (r == 10) {
      return anyOf("0123456789");
    } else if (r == 16) {
      return anyOf("012345789abcdef", ignoreCase: true);
    } else {
      throw ArgumentError("only a radix of 2, 8, 10, or 16 is allowed");
    }
  }
}

extension ToStringToken<T> on Token<T> {
  Token<String> get toStringToken =>
      Token(buffer.substring(start, stop), buffer, start, stop);
}
