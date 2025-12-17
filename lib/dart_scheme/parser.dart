import 'package:big_decimal/big_decimal.dart';
import 'package:dart_scheme/dart_scheme/ast.dart';
import 'package:dart_scheme/dart_scheme/error_messages.dart' as err;
import 'package:dart_scheme/dart_scheme/numbers.dart';
import 'package:path/path.dart';
import 'package:petitparser/petitparser.dart';

extension MapToParser<T1> on Parser<T1> {
  Parser<T2> mapTo<T2>(T2 t2) => map((t1) => t2);
}

class SchemeGrammar extends GrammarDefinition {
  /* SETTINGS
     allow non-base-10 values with points and exponents
     whether values with points are exact or inexact by default
     true/false, #t/#f, #true/#false
     allow improper cons
     use null? or empty?
     use '() or empty
     keep numbers in radix or not
  */

  Parser<T1> ps1<T1>(Parser<T1> p1) =>
      seq3(lParen(), p1, rParen()).map3((_, t1, _) => t1);
  Parser<(T1, T2)> ps2<T1, T2>(Parser<T1> p1, Parser<T2> p2) =>
      seq4(lParen(), p1, p2, rParen()).map4((_, t1, t2, _) => (t1, t2));
  Parser<(T1, T2, T3)> ps3<T1, T2, T3>(
    Parser<T1> p1,
    Parser<T2> p2,
    Parser<T3> p3,
  ) => seq5(
    lParen(),
    p1,
    p2,
    p3,
    rParen(),
  ).map5((_, t1, t2, t3, _) => (t1, t2, t3));

  @override
  Parser start() => ref(program);

  // 7.1.6 Programs and definitions

  Parser program() =>
      seq2(ref0(importDeclaration).plus(), ref0(commandOrDefinition).plus());

  Parser commandOrDefinition() => [
    ref(command),
    ref(definition),
    seq4(lParen(), begin(), ref0(commandOrDefinition).plus(), rParen()),
  ].toChoiceParser();

  Parser definition() => [
    seq5(lParen(), define(), identifier(), ref0(expression), rParen()),
    seq8(
      lParen(),
      define(),
      lParen(),
      identifier(),
      ref0(defFormals),
      rParen(),
      ref0(body),
      rParen(),
    ),
    ref0(syntaxDefinition),
    seq7(
      lParen(),
      defineRecordType(),
      identifier(),
      constructor(),
      identifier(),
      ref0(fieldSpec).star(),
      rParen(),
    ),
    seq4(lParen(), begin(), ref0(definition).star(), rParen()),
  ].toChoiceParser();

  Parser defFormals() => [
    seq3(identifier().star(), dot(), identifier()),
    identifier().star(),
  ].toChoiceParser();

  Parser constructor() =>
      seq4(lParen(), identifier(), fieldName().star(), rParen());
  Parser fieldSpec() => [
    seq5(lParen(), fieldName(), accessor(), mutator(), rParen()),
    seq4(lParen(), fieldName(), accessor(), rParen()),
  ].toChoiceParser();
  Parser fieldName() => identifier();
  Parser accessor() => identifier();
  Parser mutator() => identifier();

  Parser syntaxDefinition() => seq5(
    lParen(),
    defineSyntax(),
    keyword(),
    ref0(transformerSpec),
    rParen(),
  );

  // 7.1.7 Libraries
  Parser library() => seq5(
    lParen(),
    defineLibrary(),
    ref0(libraryName),
    ref0(libraryDeclaration).star(),
    rParen(),
  );
  Parser libraryName() => seq3(lParen(), libraryNamePart().plus(), rParen());
  Parser libraryNamePart() => [identifier(), uinteger(10)].toChoiceParser();
  Parser libraryDeclaration() => [
    seq4(lParen(), export(), exportSpec().star(), rParen()),
    ref0(importDeclaration),
    seq4(lParen(), begin(), ref0(commandOrDefinition).star(), rParen()),
    includer(),
    seq4(
      lParen(),
      string("include-library-declarations"),
      sString().plus(),
      rParen(),
    ),
    seq4(lParen(), condExpand(), ref0(condExpandClause).plus(), rParen()),
    seq8(
      lParen(),
      condExpand(),
      ref0(condExpandClause).plus(),
      lParen(),
      sElse(),
      ref0(libraryDeclaration).star(),
      rParen(),
      rParen(),
    ),
  ].toChoiceParser();
  Parser importDeclaration() =>
      seq4(lParen(), import(), ref0(importSet).plus(), rParen());
  Parser exportSpec() => [
    identifier(),
    ps3(string("rename"), identifier(), identifier()),
  ].toChoiceParser();
  Parser importSet() => [
    libraryName(),
    seq5(
      lParen(),
      string("only"),
      ref0(importSet),
      identifier().plus(),
      rParen(),
    ),
    seq5(
      lParen(),
      string("except"),
      ref0(importSet),
      identifier().plus(),
      rParen(),
    ),
    seq5(lParen(), string("prefix"), ref0(importSet), identifier(), rParen()),
    seq5(
      lParen(),
      string("rename"),
      ref0(importSet),
      seq4(lParen(), identifier(), identifier(), rParen()).plus(),
      rParen(),
    ),
  ].toChoiceParser();
  Parser condExpandClause() => seq4(
    lParen(),
    ref0(featureRequirement),
    ref0(libraryDeclaration),
    rParen(),
  );
  Parser featureRequirement() => [
    identifier(),
    ps2(string("library"), ref0(libraryName)),
    ps2(string("and"), ref0(featureRequirement).star()),
    ps2(string("or"), ref0(featureRequirement).star()),
    ps2(string("not"), ref0(featureRequirement)),
  ].toChoiceParser();

  // 7.1.5 Transformers

  Parser transformerSpec() => [
    seq6(
      lParen(),
      syntaxRules(),
      lParen(),
      identifier().star(),
      ref0(syntaxRule).star(),
      rParen(),
    ),
    seq8(
      lParen(),
      syntaxRules(),
      identifier(),
      lParen(),
      identifier().star(),
      rParen(),
      ref0(syntaxRule).star(),
      rParen(),
    ),
  ].toChoiceParser();

  Parser syntaxRule() =>
      seq4(lParen(), ref0(sPattern), ref0(template), rParen());

  Parser sPattern() => [
    patternIdentifier(),
    underscore(),
    seq3(lParen(), ref0(sPattern).star(), rParen()),
    seq5(lParen(), ref0(sPattern).plus(), dot(), ref0(sPattern), rParen()),
    seq6(
      lParen(),
      ref0(sPattern).star(),
      ref0(sPattern),
      ellipsis(),
      ref0(sPattern).star(),
      rParen(),
    ),
    seq8(
      lParen(),
      ref0(sPattern).star(),
      ref0(sPattern),
      ellipsis(),
      ref0(sPattern).star(),
      dot(),
      ref0(sPattern),
      rParen(),
    ),
    seq3(hashParen(), ref0(sPattern).star(), rParen()),
    seq4(hashParen(), ref0(sPattern).plus(), ellipsis(), rParen()),
    ref0(patternDatum),
  ].toChoiceParser();

  Parser patternDatum() => [
    sString(),
    character(),
    boolean(),
    number(),
    byteVector(),
  ].toChoiceParser();

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

  Parser patternIdentifier() => seq2(ellipsis().not(), identifier());

  Parser underscore() => char("_");

  // 7.1.4 Quasiquotations

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

  Parser quasiquotation(int depth) => [
    seq2(backtick(), ref1(qqTemplate, depth)),
    seq4(lParen(), quasiquote(), ref1(qqTemplate, depth), rParen()),
  ].toChoiceParser();

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
    identifier(),
    literal(),
    ref0(procedureCall),
    ref0(lambdaExpression),
    ref0(conditional),
    ref0(assignment),
    ref0(macroUse),
    ref0(macroBlock),
    ref0(includer),
  ].toChoiceParser();

  Parser literal() => [ref0(quotation), selfEvaluating()].toChoiceParser();

  Parser selfEvaluating() => [
    boolean(),
    number(),
    character(),
    sString(),
    byteVector(),
  ].toChoiceParser();

  Parser quotation() => [
    seq2(ref0(quote), ref0(datum)),
    seq4(lParen(), ref0(quote), ref0(datum), ref0(rParen)),
  ].toChoiceParser();

  Parser procedureCall() =>
      seq4(lParen(), ref0(operator), ref0(operand).star(), rParen());

  Parser operator() => ref0(expression);

  Parser operand() => ref0(expression);

  Parser lambdaExpression() =>
      seq5(lParen(), lambda(), formals(), ref0(body), ref0(rParen));

  Parser formals() => [
    seq3(lParen(), identifier().star(), ref0(rParen)),
    identifier(),
    seq5(lParen(), identifier().plus(), ref0(dot), identifier(), ref0(rParen)),
  ].toChoiceParser();

  Parser body() => seq2(ref0(definition).star(), ref0(sequence));

  Parser sequence() => seq2(ref0(command).star(), ref0(expression));

  Parser command() => ref0(expression);

  Parser conditional() => seq6(
    lParen(),
    string("if"),
    ref0(test),
    ref0(consequent),
    ref0(alternate),
    rParen(),
  );

  Parser test() => ref0(expression);

  Parser consequent() => ref0(expression);

  Parser alternate() => ref0(expression).optional();

  Parser assignment() =>
      seq5(lParen(), setBang(), identifier(), ref0(expression), rParen());

  // derived expressions come here

  Parser macroUse() => seq3(lParen(), keyword(), ref0(datum).star());
  Parser keyword() => identifier();

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

  Parser includer() => [
    seq4(lParen(), string("include"), sString().plus(), rParen()),
    seq4(lParen(), string("include-ci"), sString().plus(), rParen()),
  ].toChoiceParser();

  // 7.1.2 External Representations

  Parser datum() => [
    ref0(simpleDatum),
    ref0(compoundDatum),
    seq3(label(), char("="), ref0(datum)),
    seq2(label(), char("#")),
  ].toChoiceParser();

  Parser simpleDatum() => [
    boolean(),
    number(),
    character(),
    sString(),
    symbol(),
    byteVector(),
  ].toChoiceParser();

  Parser symbol() => identifier();

  Parser compoundDatum() =>
      [ref0(list), ref0(vector), ref0(abbreviation)].toChoiceParser();

  Parser list() => [
    seq3(lParen(), ref0(datum).star(), rParen()),
    seq5(lParen(), ref0(datum).plus(), dot(), ref0(datum), rParen()),
  ].toChoiceParser();

  Parser abbreviation() => seq2(abbrevPrefix(), ref0(datum));

  Parser abbrevPrefix() =>
      [quote(), backtick(), comma(), commaAt()].toChoiceParser();

  Parser vector() => seq3(hashParen(), ref0(datum).star(), rParen());
  Parser label() => seq2(char("#"), uinteger(10));

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
      [initial(), digit10(), specialSubsequent()].toChoiceParser();
  Parser digit10() => pattern("0-9");
  Parser hexDigit() =>
      [digit10(), pattern("a-f", ignoreCase: true)].toChoiceParser();
  Parser explicitSign() => anyOf("+-");
  Parser specialSubsequent() => [explicitSign(), anyOf(".@")].toChoiceParser();

  Parser<String> inlineHexEscape() => seq3(
    string("\\x"),
    hexScalarValue(),
    char(";"),
  ).map3((_, h, _) => String.fromCharCode(int.parse(h, radix: 16)));

  Parser<String> hexScalarValue() => hexDigit().plus().flatten();
  Parser<String> mnemonicEscape() =>
      [
            string(r"\a").mapTo("\u0007"),
            string(r"\b").mapTo("\u0008"),
            string(r"\n").mapTo("\u000a"),
            string(r"\r").mapTo("\u000d"),
            string(r"\t").mapTo("\u0009"),
          ].toChoiceParser()
          as Parser<String>;
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

  Parser<SExpr<bool>> boolean() =>
      [
        [
          string("#true"),
          string("#t"),
        ].toChoiceParser().token().map((t) => Atom(true, t, SExprType.boolean)),
        [string("#false"), string("#f")].toChoiceParser().token().map(
          (t) => Atom(false, t, SExprType.boolean),
        ),
      ].toChoiceParser(
        failureJoiner: (f1, _) => Failure(f1.buffer, f1.position, err.boolean),
      );

  Parser<SExpr<String>> character() => [
    seq2(string("#\\"), characterName())
        .map2((_, c) => c)
        .token()
        .map((t) => Atom(t.value, t.toStringToken, SExprType.char)),
    seq3(string("#\\x"), hexScalarValue(), char(";"))
        .map3((_, h, _) => int.parse(h, radix: 16))
        .token()
        .map(
          (t) => Atom(
            String.fromCharCode(t.value),
            t.toStringToken,
            SExprType.char,
          ),
        ),
    seq2(string("#\\"), any(unicode: true))
        .map2((_, c) => c)
        .token()
        .map((t) => Atom(t.value, t.toStringToken, SExprType.char)),
  ].toChoiceParser();

  Parser<String> characterName() => [
    string("alarm").mapTo("\u0007"),
    string("backspace").mapTo("\u0008"),
    string("delete").mapTo("\u007f"),
    string("escape").mapTo("\u001b"),
    string("newline").mapTo("\u000a"),
    string("null").mapTo("\u0000"),
    string("return").mapTo("\u000d"),
    string("space").mapTo("\u0020"),
    string("tab").mapTo("\u0009"),
  ].toChoiceParser();

  Parser<SExpr<String>> sString() =>
      seq3(
            doubleQuote(),
            stringElement().star().map((ss) => ss.join("")),
            doubleQuote(),
          )
          .map3((_, s, _) => s)
          .token()
          .map((t) => Atom(t.value, t.toStringToken, SExprType.string));

  Parser<String> stringElement() => [
    inlineHexEscape(),
    seq4(
      char(r"\"),
      intralineWhitespace().star(),
      lineEnding(),
      intralineWhitespace().star(),
    ).mapTo(""),
    mnemonicEscape(),
    string(r'\"').mapTo('"'),
    string(r"\\").mapTo(r"\"),
    string(r"\|").mapTo("|"),
    pattern(r'^"\'),
  ].toChoiceParser();

  Parser byteVector() => seq3(hashU8Paren(), sByte().star(), rParen());
  Parser sByte() => failure(message: "TODO"); // integer value from 0-255

  Parser<SNumber> number() =>
      [sNum(2), sNum(8), sNum(10), sNum(16)].toChoiceParser();

  Parser<SNumber> sNum(int r) =>
      seq2(prefix(r), complex(r)).map2((exact, number) => SNumber.make(exact, number));

  Parser<NumString> complex(int r) => [
    real(r),
    //seq3(real(r), char("@"), real(r)), TODO: polar coordinates
    seq4(real(r), char("+"), ureal(r), char("i", ignoreCase: true)).map4((rl, _, im, _) => ComplexString(rl, im)),
    seq4(real(r), char("-"), ureal(r), char("i", ignoreCase: true)).map4((rl, _, im, _) => ComplexString(rl, im.negate())),
    seq3(real(r), char("+"), char("i", ignoreCase: true)).map3((rl, _, _) => ComplexString(rl, IntString("1", r))),
    seq3(real(r), char("-"), char("i", ignoreCase: true)).map3((rl, _, _) => ComplexString(rl, IntString("-1", r))),
    seq3(real(r), infnan(), char("i", ignoreCase: true)).map3((rl, inf, _) => ComplexString(rl, inf)),
    seq3(char("+"), ureal(r), char("i", ignoreCase: true)).map3((_, rl, _) => ComplexString(IntString("0", r), rl)),
    seq3(char("-"), ureal(r), char("i", ignoreCase: true)).map3((_, rl, _) => ComplexString(IntString("0", r), rl.negate())),
    seq2(infnan(), char("i", ignoreCase: true)).map2((wn, _) => ComplexString(IntString("0", r), wn)),
    string("+i", ignoreCase: true).mapTo(ComplexString(IntString("0", r), IntString("1", r))),
    string("-i", ignoreCase: true).mapTo(ComplexString(IntString("0", r), IntString("-1", r))),
  ].toChoiceParser();

  Parser<NumString> real(int r) => [
    seq2(sign(), ureal(r)).map2((s, u) => s < 0 ? u.negate() : u),
    infnan(),
  ].toChoiceParser();

  Parser<NumString> ureal(int r) => [
    uinteger(r),
    seq3(uinteger(r), char("/"), uinteger(r)).map3((n, _, d) => FracString(n.digits, d.digits, r)),
    decimal(r),
  ].toChoiceParser();

  Parser<WithRadix> decimal(int r) {
    if (r != 10) {
      return failure(message: "decimal only defined for radix 10");
    } else {
      return [
        seq2(
          uinteger(10),
          suffix(),
        ).map2((bi, expt) => WithRadix(bi.toString(), "", expt)),
        seq3(
          dot(),
          digit10().plus().flatten(),
          suffix(),
        ).map3((_, aft, expt) => WithRadix("", aft, expt)),
        seq4(
          digit10().plus().flatten(),
          dot(),
          digit10().star().flatten(),
          suffix(),
        ).map4((bef, _, aft, expt) => WithRadix(bef, aft, expt)),
      ].toChoiceParser();
    }
  }

  Parser<IntString> uinteger(int r) =>
      digit(r).plus().flatten().map((s) => IntString(s, r));

  Parser<(int, Exactness)> prefix(int r) => [
    seq2(radix(r), exactness()).map2((r, e) => (r, e)),
    seq2(exactness(), radix(r)).map2((e, r) => (r, e)),
  ].toChoiceParser();

  Parser<WeirdNum> infnan() => [
    string("+inf.0", ignoreCase: true).mapTo(WeirdNum(double.infinity)),
    string("-inf.0", ignoreCase: true).mapTo(WeirdNum(double.negativeInfinity)),
    string("+nan.0", ignoreCase: true).mapTo(WeirdNum(double.nan)),
    string("-nan.0", ignoreCase: true).mapTo(WeirdNum(double.nan)),
  ].toChoiceParser();

  // returns the value of the exponent, positive or negative
  Parser<int> suffix() => seq3(
    exponentMarker(),
    sign(), // returns 1 or -1
    digit10().plus().flatten(),
  ).map3((_, s, ds) => s * int.parse(ds)).optional().map((i) => i ?? 0);

  Parser exponentMarker() => char("e", ignoreCase: true);

  // returns 1 or -1
  Parser<int> sign() =>
      pattern("+-").optional().flatten().map((s) => s == "-" ? -1 : 1);

  Parser<Exactness> exactness() =>
      seq2(char("#"), pattern("ie", ignoreCase: true)).optional().flatten().map(
        (s) =>
            s.toLowerCase().endsWith("i") ? Exactness.inexact : Exactness.exact,
      );

  Parser<int> radix(int r) {
    if (r == 2) {
      return string("#b", ignoreCase: true).mapTo(2);
    } else if (r == 8) {
      return string("#o", ignoreCase: true).mapTo(8);
    } else if (r == 16) {
      return string("#x", ignoreCase: true).mapTo(16);
    } else if (r == 10) {
      return string("#d", ignoreCase: true).optional().mapTo(10);
    } else {
      throw ArgumentError(
        "only a radix of 2, 8, 10, or 16 is allowed, given $r",
      );
    }
  }

  Parser digit(int r) {
    if (r == 2) {
      return pattern("01");
    } else if (r == 8) {
      return pattern("0-7");
    } else if (r == 10) {
      return digit10();
    } else if (r == 16) {
      return [digit10(), pattern("abcdef", ignoreCase: true)].toChoiceParser();
    } else {
      throw ArgumentError(
        "only a radix of 2, 8, 10, or 16 is allowed, given $r",
      );
    }
  }

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

  Parser sElse() => string("else");
  Parser arrow() => string("=>");
  Parser<String> define() => string("define");
  Parser unquote() => string("unquote");
  Parser unquoteSplicing() => string("unquote-splicing");
  Parser defineSyntax() => string("define-syntax");
  Parser defineLibrary() => string("define-library");
  Parser defineRecordType() => string("define-record-type");
  Parser syntaxRules() => string("syntax-rules");
  Parser ellipsis() => string("...");

  Parser<String> quote() => char("'");
  Parser<String> lambda() => string("lambda");
  Parser sIf() => string("if");
  Parser<String> setBang() => string("set!");
  Parser<String> begin() => string("begin");
  Parser import() => string("import");
  Parser export() => string("export");
  Parser cond() => string("cond");
  Parser condExpand() => string("cond-expand");
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
}

extension ToStringToken<T> on Token<T> {
  Token<String> get toStringToken =>
      Token(buffer.substring(start, stop), buffer, start, stop);
}

abstract class NumString {
  NumString negate();
}

// A number of the form <beforeDot>.<afterDot>E<exponent>
class WithRadix extends NumString {
  final String beforeDot;
  final String afterDot;
  final int exponent;

  WithRadix(this.beforeDot, this.afterDot, this.exponent);

  WithRadix negate() {
    return WithRadix("-$beforeDot", afterDot, exponent);
  }
}

class WeirdNum extends NumString {
  double value;

  WeirdNum(this.value);

  WeirdNum negate() {
    throw UnimplementedError("shouldn't be able to negate Inf or NaN");
  }
}

class IntString extends NumString {
  final String digits;
  final int radix;

  IntString(this.digits, this.radix);

  IntString negate() {
    return IntString("-$digits", radix);
  }
}

class FracString extends NumString {
  final String num;
  final String denom;
  final int radix;

  FracString(this.num, this.denom, this.radix);

  FracString negate() {
    return FracString("-$num", denom, radix);
  }
}

class ComplexString extends NumString {
  final NumString real;
  final NumString imag;

  ComplexString(this.real, this.imag);

  ComplexString negate() {
    throw UnimplementedError("shouldn't have to negate complex number");
  }
}
