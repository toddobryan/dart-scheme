import 'package:dart_scheme/dart_scheme/ast.dart';
import 'package:petitparser/petitparser.dart';

class SchemeGrammar extends GrammarDefinition {
  @override
  Parser start() => ref(program);

  // 7.1.6 Programs and definitions

  Parser program() => ref0(commandOrDefinition).star();

  Parser commandOrDefinition() => [
    ref(command),
    ref(definition),
    ref(syntaxDefinition),
    [
      ref0(lParen),
      ref0(begin),
      ref0(commandOrDefinition).plus(),
    ].toSequenceParser(),
  ].toChoiceParser();

  Parser definition() => [
    [
      lParen(),
      ref0(define),
      ref0(variable),
      ref0(expression).trim(),
      ref0(rParen),
    ].toSequenceParser(),
    [
      lParen(),
      define(),
      lParen(),
      variable(),
      ref0(defFormals),
      rParen(),
      ref0(body),
      rParen(),
    ].toSequenceParser(),
    [lParen(), begin(), ref0(definition).star()].toSequenceParser(),
  ].toChoiceParser();

  Parser defFormals() => [
    ref0(variable).star(),
    [dot(), ref0(variable)].toSequenceParser().optional(),
  ].toSequenceParser();

  Parser syntaxDefinition() => [
    lParen(),
    defineSyntax(),
    keyword(),
    ref0(transformerSpec),
    rParen(),
  ].toSequenceParser();

  // 7.1.5 Transformers

  Parser transformerSpec() => [
    lParen(),
    syntaxRules(),
    lParen(),
    identifier().star(),
    ref0(syntaxRule).star(),
    rParen(),
  ].toSequenceParser();

  Parser syntaxRule() =>
      [lParen(), ref0(sPattern), ref0(template), rParen()].toSequenceParser();

  Parser sPattern() => [
    patternIdentifier(),
    [lParen(), ref0(sPattern).star(), rParen()].toSequenceParser(),
    [
      lParen(),
      ref0(sPattern).plus(),
      dot(),
      ref0(sPattern),
      rParen(),
    ].toSequenceParser(),
    [lParen(), ref0(sPattern).plus(), ellipsis(), rParen()].toSequenceParser(),
    [hashParen(), ref0(sPattern).star(), rParen()].toSequenceParser(),
    [
      hashParen(),
      ref0(sPattern).plus(),
      ellipsis(),
      rParen(),
    ].toSequenceParser(),
    ref0(patternDatum),
  ].toChoiceParser();

  Parser patternDatum() =>
      [sString(), character(), boolean(), number()].toChoiceParser();

  Parser template() => [
    patternIdentifier(),
    [lParen(), ref0(templateElement).star(), rParen()].toSequenceParser(),
    [
      lParen(),
      ref0(templateElement).plus(),
      dot(),
      ref0(template),
      rParen(),
    ].toSequenceParser(),
    [hashParen(), ref0(templateElement).star(), rParen()].toSequenceParser(),
    ref0(templateDatum),
  ].toChoiceParser();

  Parser templateElement() => [
    ref0(template),
    [ref0(template), ellipsis()].toSequenceParser(),
  ].toChoiceParser();

  Parser templateDatum() => ref0(patternDatum);

  Parser patternIdentifier() => ellipsis().not().seq(identifier());

  // 7.1.4 Quasiquotations

  Parser quasiquotation(int depth) => [
    [backtick(), ref1(qqTemplate, depth)].toSequenceParser(),
    [
      lParen(),
      quasiquote(),
      ref1(qqTemplate, depth),
      rParen(),
    ].toSequenceParser(),
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
    [
      lParen(),
      ref1(qqTemplateOrSplice, depth).star(),
      rParen(),
    ].toSequenceParser(),
    [
      lParen(),
      ref1(qqTemplateOrSplice, depth).plus(),
      dot(),
      ref1(qqTemplate, depth),
      rParen(),
    ].toSequenceParser(),
    [quote(), ref1(qqTemplate, depth)].toSequenceParser(),
    ref1(quasiquotation, depth + 1),
  ].toChoiceParser();

  Parser vectorQqTemplate(int depth) => [
    hashParen(),
    ref1(qqTemplateOrSplice, depth).star(),
    rParen(),
  ].toSequenceParser();

  Parser unquotation(int depth) => [
    [comma(), ref1(qqTemplate, depth - 1)].toSequenceParser(),
    [
      lParen(),
      unquote(),
      ref1(qqTemplate, depth - 1),
      rParen(),
    ].toSequenceParser(),
  ].toChoiceParser();

  Parser qqTemplateOrSplice(int depth) => [
    ref1(qqTemplate, depth),
    ref1(splicingUnquotation, depth),
  ].toChoiceParser();

  Parser splicingUnquotation(int depth) => [
    [commaAt(), ref1(qqTemplate, depth - 1)].toSequenceParser(),
    [
      lParen(),
      unquoteSplicing(),
      ref1(qqTemplate, depth - 1),
      rParen(),
    ].toSequenceParser(),
  ].toChoiceParser();

  // 7.1.3 Expressions

  Parser expression() => [
    ref0(variable),
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
    [ref0(quote), ref0(datum)].toSequenceParser(),
    [ref0(lParen), ref0(quote), ref0(datum), ref0(rParen)].toSequenceParser(),
  ].toChoiceParser();

  Parser procedureCall() => [
    ref0(lParen),
    ref0(operator),
    ref0(operand).star(),
    ref0(rParen),
  ].toSequenceParser();

  Parser operator() => ref0(expression);

  Parser operand() => ref0(expression);

  Parser lambdaExpression() => [
    ref0(lParen),
    ref0(lambda),
    ref0(formals),
    ref0(body),
    ref0(rParen),
  ].toSequenceParser();

  Parser formals() => [
    [ref0(lParen), ref0(variable).star(), ref0(rParen)].toSequenceParser(),
    ref0(variable),
    [
      ref0(lParen),
      ref0(variable).plus(),
      ref0(dot),
      ref0(variable),
      ref0(rParen),
    ].toSequenceParser(),
  ].toChoiceParser();

  Parser body() => [ref0(definition).star(), ref0(sequence)].toSequenceParser();

  Parser sequence() =>
      [ref0(command).star(), ref0(expression)].toSequenceParser();

  Parser command() => ref0(expression);

  Parser conditional() => [
    lParen(),
    ref0(test),
    ref0(consequent),
    ref0(alternate),
    rParen(),
  ].toSequenceParser();

  Parser test() => ref0(expression);

  Parser consequent() => ref0(expression);

  Parser alternate() => ref0(expression).optional();

  Parser assignment() => [
    lParen(),
    setBang(),
    ref0(variable),
    ref0(expression),
    rParen(),
  ].toSequenceParser();

  // derived expressions come here

  Parser macroUse() =>
      [lParen(), keyword(), ref0(datum).star()].toSequenceParser();

  Parser macroBlock() => [
    [
      lParen(),
      letSyntax(),
      lParen(),
      ref0(syntaxSpec).star(),
      rParen(),
      ref0(body),
      rParen(),
    ].toSequenceParser(),
    [
      lParen(),
      letrecSyntax(),
      lParen(),
      ref0(syntaxSpec).star(),
      rParen(),
      ref0(body),
      rParen(),
    ].toSequenceParser(),
  ].toChoiceParser();

  Parser syntaxSpec() =>
      [lParen(), keyword(), ref0(transformerSpec), rParen()].toSequenceParser();

  Parser keyword() => identifier();

  // 7.1.2 External Representations

  Parser datum() => [ref0(simpleDatum), ref0(compoundDatum)].toChoiceParser();

  Parser simpleDatum() =>
      [boolean(), number(), character(), sString(), symbol()].toChoiceParser();

  Parser symbol() => identifier();

  Parser compoundDatum() => [ref0(list), ref0(vector)].toChoiceParser();

  Parser list() => [
    [lParen(), ref0(datum).star(), rParen()].toSequenceParser(),
    [
      lParen(),
      ref0(datum).plus(),
      dot(),
      ref0(datum),
      rParen(),
    ].toSequenceParser(),
    ref0(abbreviation),
  ].toChoiceParser();

  Parser abbreviation() => [abbrevPrefix(), ref0(datum)].toSequenceParser();

  Parser abbrevPrefix() =>
      [quote(), backtick(), comma(), commaAt()].toChoiceParser();

  Parser vector() =>
      [hashParen(), ref0(datum).star(), rParen()].toSequenceParser();

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
    quote(),
    backtick(),
    comma(),
    commaAt(),
    dot(),
  ].toChoiceParser();

  Parser delimiter() =>
      [whitespace(), lParen(), rParen(), char('"'), char(";")].toChoiceParser();

  Parser<String> lParen() => char("(");
  Parser<String> rParen() => char(")");
  Parser<String> hashParen() => string("#(");
  Parser<String> backtick() => char("`");
  Parser<String> comma() => char(",");
  Parser<String> commaAt() => string(",@");
  Parser<String> dot() => char(".");

  Parser<String> comment() => [
    char(";"),
    ref0(newline).neg().star(),
    ref0(newline).optional(),
  ].toSequenceParser().flatten();

  // atmosphere   ???
  // intertokenSpace  ???

  Parser identifier() => [
    [initial(), subsequent().star()].toSequenceParser(),
    peculiarIdentifier(),
  ].toChoiceParser();

  Parser initial() => [letter(), specialInitial()].toChoiceParser();

  Parser specialInitial() => anyOf("!\$%&*/:<=>?^_~");

  Parser subsequent() =>
      [initial(), digit(10), specialSubsequent()].toChoiceParser();

  Parser specialSubsequent() => anyOf("+-.@");

  Parser peculiarIdentifier() => [anyOf("+-"), string("...")].toChoiceParser();

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

  Parser<SBoolean> boolean() => [
    string("#t").token().map((t) => SBoolean(true, t)),
    string("#f").token().map((t) => SBoolean(false, t)),
  ].toChoiceParser();

  Parser<SChar> character() =>
      [
        string("#\\"),
        [string("space"), string("newline"), ref0(any)].toChoiceParser(),
      ].toSequenceParser().flatten().token().map((t) {
        if (t.value.endsWith("space")) {
          return SChar(" ", t);
        } else if (t.value.endsWith("newline")) {
          return SChar("\n", t);
        } else {
          return SChar(String.fromCharCode(t.value.runes.last), t);
        }
      });

  // In spec, is characterName
  Parser sString() => [char('"'), ref0(stringElement).star(), char('"')]
      .toSequenceParser()
      .flatten()
      .token()
      .map((t) => SString(t.value.substring(1, t.value.length - 1), t));

  Parser<String> stringElement() => [
    string('\\"').map((s) => '"'),
    string("\\\\").map((s) => "\\"),
    pattern('^"\\'),
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

  Parser number() => [
    ref1(sNum, 2),
    ref1(sNum, 8),
    ref1(sNum, 10),
    ref1(sNum, 16),
  ].toChoiceParser();

  Parser sNum(int r) => [ref1(prefix, r), ref1(complex, r)].toSequenceParser();

  Parser complex(int r) => [
    [ref1(real, r), char("a"), ref1(real, r)].toSequenceParser(),
    [
      ref1(real, r),
      [char("+"), char("-")].toChoiceParser(),
      ref(ureal, r),
      char("i", ignoreCase: true),
    ].toSequenceParser(),
    [
      ref1(real, r),
      [char("+"), char("-")].toChoiceParser(),
      char("i", ignoreCase: true),
    ].toSequenceParser(),
    [
      [char("+"), char("-")].toChoiceParser(),
      ref1(ureal, r),
    ].toSequenceParser(),
    [
      [char("+"), char("-")].toChoiceParser(),
      char("i", ignoreCase: true),
    ].toSequenceParser(),
    ref1(real, r),
  ].toSequenceParser();

  Parser real(int r) =>
      [ref0(sign).optional(), ref1(ureal, r)].toSequenceParser();

  Parser ureal(int r) => [
    ref(pointed, r),
    [ref1(uinteger, r), char("/"), ref1(uinteger, r)].toSequenceParser(),
    ref1(uinteger, r),
  ].toChoiceParser();

  Parser pointed(int r) => [
    [ref1(uinteger, r), ref1(suffix, r)].toSequenceParser(),
    [
      char("."),
      ref1(digit, r).plus(),
      char("#").star(),
      ref1(suffix, r).optional(),
    ].toSequenceParser(),
    [
      ref1(digit, r).plus(),
      char("."),
      ref1(digit, r).star(),
      char("#").star(),
      ref1(suffix, r).optional(),
    ].toSequenceParser(),
    [
      ref1(digit, r).plus(),
      char("#").plus(),
      char("."),
      char("#"),
      ref1(suffix, r).optional(),
    ].toSequenceParser(),
  ].toChoiceParser();

  Parser uinteger(int r) =>
      [ref1(digit, r), char("#").star()].toSequenceParser();

  Parser prefix(int r) => [
    [ref1(radix, r), ref0(exactness).optional()].toSequenceParser(),
    [ref0(exactness).optional(), ref1(radix, r)].toSequenceParser(),
  ].toChoiceParser();

  Parser suffix(int r) => [
    ref1(exponentMarker, r),
    ref0(sign).optional(),
    ref1(digit, r).plus(),
  ].toSequenceParser();

  Parser exponentMarker(int r) {
    if (r == 16) {
      return anyOf("ls", ignoreCase: true);
    } else {
      return anyOf("defls", ignoreCase: true);
    }
  }

  Parser sign() => anyOf("+-");

  Parser exactness() =>
      [char("#"), anyOf("ei", ignoreCase: true)].toSequenceParser();

  // TODO: clean up the cases
  Parser radix(int r) {
    if (r == 2) {
      return [char("#"), char("b", ignoreCase: true)].toSequenceParser();
    } else if (r == 8) {
      return [char("#"), char("o", ignoreCase: true)].toSequenceParser();
    } else if (r == 10) {
      return [char("#"), char("d", ignoreCase: true)].toSequenceParser();
    } else if (r == 16) {
      return [char("#"), char("x", ignoreCase: true)].toSequenceParser();
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
