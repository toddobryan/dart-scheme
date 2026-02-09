import "package:dart_scheme/dart_scheme/error_messages.dart" as err;
import "package:dart_scheme/dart_scheme/parsing/ast.dart";
import "package:dart_scheme/dart_scheme/parsing/unparsed_numbers.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:petitparser/petitparser.dart";

import "numbers.dart";

/// map that ignores its argument
extension MapToParser<T1> on Parser<T1> {
  Parser<T2> mapTo<T2>(T2 t2) => map((T1 t1) => t2);
}

/// Grammar for R7RS Scheme
class SchemeGrammar extends GrammarDefinition {
  /* SETTINGS
     allow non-base-10 values with points and exponents
     whether values with radix points are exact or inexact by default
     true/false, #t/#f, #true/#false
     allow improper cons
     use null? or empty?
     use '() or empty
     keep numbers in radix or not
     display bytevector as #u8(...) or (bytevector ...)
  */

  /*  Parser<T1> ps1<T1>(Parser<T1> p1) =>
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
*/

  /// start production for the Scheme grammar, dummy value for now
  @override
  Parser<String> start() => string("scheme"); // TODO
  /*
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
*/
  // 7.1.3 Expressions
/*
  Parser<Expr<dynamic>> expression() => [
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

  Parser<Expr<dynamic>> literal() => [ref0(quotation), selfEvaluating()].toChoiceParser();

  Parser<Expr<dynamic>> selfEvaluating() => [
    boolean(),
    number(),
    character(),
    sString(),
    byteVector(),
  ].toChoiceParser();

  Parser<Expr<dynamic>> quotation() => [
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
*/
  // 7.1.2 External Representations

  Parser<Datum<dynamic>> datum() => [
    ref0(simpleDatum),
    ref0(compoundDatum),
    seq3(
      label(),
      char("="),
      ref0(datum),
    ).map3((ln, _, d) => VLabelDef(ln, d))
        .token()
    .map(SLabelDef.fromToken)
    ,
    seq2(
      label(),
      char("#"),
    ).map2((ln, _) => ln)
        .token().map(SLabelRef.fromToken),
  ].toChoiceParser().cast<Datum<dynamic>>();

  Parser<SimpleDatum<dynamic>> simpleDatum() => [
    boolean(),
    number(),
    character(),
    sString(),
    symbol(),
    byteVector() as Parser<SByteVector>,
  ].toChoiceParser().cast<SimpleDatum<dynamic>>();

  Parser<SSymbol> symbol() => identifier().map(SSymbol.fromToken);

  Parser<CompoundDatum<dynamic>> compoundDatum() =>
      [ref0(list), ref0(vector), ref0(abbreviation)].toChoiceParser().cast();

  Parser<CompoundDatum<dynamic>> list() => [
    seq3(
      lParen(),
      ref0(datum).trim().star(),
      rParen(),
    ).map3((_, ds, _) => VList<dynamic, Null>(IList(ds), null))
        .token()
        .map(SList.fromToken),
    seq5(
          lParen(),
          ref0(datum).trim().plus(),
          dot().trim(),
          ref0(datum).trim(),
          rParen(),
        )
    .map5((_, ds, _, last, _) => VList(IList(ds), last))
        .token()
        .map(SList.fromToken),
  ].toChoiceParser().cast<CompoundDatum<dynamic>>();

  Parser<SAbbreviation<dynamic>> abbreviation() => seq2(
    abbrevPrefix(),
    ref0(datum),
  ).map2(VAbbrev.new)
      .token().map(SAbbreviation.fromToken);

  Parser<AbbrevType> abbrevPrefix() =>
      [quote(), backtick(), commaAt(), comma()].toChoiceParser();

  Parser<SVector<dynamic>> vector() => seq3(
    hashParen(),
    ref0(datum).trim().star(),
    rParen(),
  ).map3((_, ds, _) => IList(ds))
  .token().map(SVector.fromToken);

  Parser<int> label() =>
      seq2(char("#"), uinteger(Radix.dec)).map((x) => int.parse(x.$2.digits));

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

  /// Whitespace allowed inside a line
  Parser<String> intralineWhitespace() => pattern(" \t");

  Parser<String> sWhitespace() =>
      [intralineWhitespace(), lineEnding()].toChoiceParser();

  /// A legal line-ending character or characters
  Parser<String> lineEnding() =>
      // ignore: always_specify_types
      [char("\n"), string("\r\n"), char("\r")].toChoiceParser();

  Parser<String> lParen() => char("(");
  Parser<String> rParen() => char(")");
  Parser<String> hashParen() => string("#(");
  Parser<String> hashU8Paren() => string("#u8(");
  Parser<AbbrevType> backtick() => char("`").mapTo(.backtick);
  Parser<AbbrevType> comma() => char(",").mapTo(.comma);
  Parser<AbbrevType> commaAt() => string(",@").mapTo(.commaAt);

  /// Parses a period
  Parser<String> dot() => char(".");

  Parser<String> verticalLine() => char("|");

  /// Parses a single double-quote
  Parser<String> doubleQuote() => char('"');

  Parser<String> semicolon() => char(";");

  /*
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
*/
  Parser<void> eof() => endOfInput();

  Parser<Token<String>> identifier() => [
    seq2(initial(), subsequent().star()).flatten(),
    seq3(
      verticalLine(),
      ref0(symbolElement).star().map((cs) => cs.join()),
      verticalLine(),
    ).map3((_, s, _) => s),
    peculiarIdentifier(),
  ].toChoiceParser().token();

  Parser<String> initial() => [letter(), specialInitial()].toChoiceParser();
  Parser<String> specialInitial() => anyOf("!\$%*&/:<=>?@^_~");
  Parser<String> subsequent() =>
      [initial(), digit10(), specialSubsequent()].toChoiceParser();

  /// Parses a single digit legal for a base-10 number
  Parser<String> digit10() => Radix.dec.digitParser;

  /// Parses a single digit legal for a base-16 number
  Parser<String> hexDigit() => Radix.hex.digitParser;

  Parser<String> explicitSign() => anyOf("+-");
  Parser<String> specialSubsequent() =>
      [explicitSign(), anyOf(".@")].toChoiceParser();

  /// Parses an inline hex escape characte
  /// of the form \xH+; where H is a hex digit
  Parser<String> inlineHexEscape() => seq3(
    string("\\x"),
    hexScalarValue(),
    char(";"),
  ).map3((_, String h, _) => String.fromCharCode(int.parse(h, radix: 16)));

  /// Parses one or more hex digits
  Parser<String> hexScalarValue() => hexDigit().plusString();

  /// Parses backslash escapes
  Parser<String> mnemonicEscape() => <Parser<String>>[
    string(r"\a").mapTo("\u0007"),
    string(r"\b").mapTo("\u0008"),
    string(r"\n").mapTo("\u000a"),
    string(r"\r").mapTo("\u000d"),
    string(r"\t").mapTo("\u0009"),
  ].toChoiceParser();

  Parser<String> peculiarIdentifier() => seq2(
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
  ).flatten();
  Parser<String> dotSubsequent() => [signSubsequent(), dot()].toChoiceParser();
  Parser<String> signSubsequent() =>
      [initial(), explicitSign(), char("@")].toChoiceParser();
  Parser<String> symbolElement() => [
    inlineHexEscape(),
    mnemonicEscape(),
    string("\\|"),
    noneOf("|\\"),
  ].toChoiceParser();

  /// Parses #t, #true, #f, and #false
  Parser<SBoolean> boolean() => [
        [string("#true"), string("#t")]
            .toChoiceParser()
            .map((_) => true)
            .token()
            .map(SBoolean.fromToken),
        [string("#false"), string("#f")]
            .toChoiceParser()
            .map((_) => false)
            .token()
            .map(SBoolean.fromToken),
      ].toChoiceParser(
        failureJoiner: (f1, _) => Failure(f1.buffer, f1.position, err.boolean),
      );

  /// Parses a legal Scheme character literal
  Parser<SCharacter> character() => [
    seq2(
      string("#\\"),
      characterName(),
    ).map2((_, char) => char).token().map(SCharacter.fromToken),
    seq3(string("#\\x"), hexScalarValue(), char(";"))
        .map3((_, h, _) => String.fromCharCode(int.parse(h, radix: 16)))
        .token()
        .map(SCharacter.fromToken),
    seq2(
      string("#\\"),
      any(unicode: true),
    ).map2((_, c) => c).token().map(SCharacter.fromToken),
  ].toChoiceParser();

  /// Parses the names of named characters
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

  /// Parses a legal Scheme string
  Parser<SString> sString() => seq3(
    doubleQuote(),
    stringElement().star().map((ss) => ss.join("")),
    doubleQuote(),
  ).map3((_, s, _) => s).token().map(SString.fromToken);

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

  Parser<SByteVector> byteVector() =>
      seq3(hashU8Paren(), sByte().trim().star(), rParen())
      .map3((_, nums, _) => IList(nums))
      .token()
      .map(SByteVector.fromToken);


  // This parses any number.
  // That it is a byte is checked in SByteVector.fromToken
  // Otherwise, we'd get a ")" expected if we have something like #u8(256)
  // since 25 would parse correctly
  Parser<SNumber> sByte() => number();

  Parser<SNumber> number() => [
    sNum(Radix.bin),
    sNum(Radix.oct),
    sNum(Radix.dec),
    sNum(Radix.hex),
  ].toChoiceParser().token().map(SNumber.fromToken);

  Parser<SNumberValue> sNum(Radix r) =>
      seq2(prefix(r), complex(r)).map2(PrefixedNumString.new).map(SNumberValue.make);

  /// Parses a legal complex number into a NumString
  Parser<ComplexString> complex(Radix r) => <Parser<ComplexString>>[
    // TODO: add back polar complex numbers
    /*seq3(
      real(r),
      char("@"),
      real(r),
    ).map3((rad, _, theta) => polar(rad, theta)).labeled("rad@theta"),*/
    seq4(real(r), char("+"), ureal(r), char("i", ignoreCase: true))
        .map4((rl, _, im, i) => comp("${rl.input}+${im.input}$i", rl, im))
        .labeled("r+ri"),
    seq4(real(r), char("-"), ureal(r), char("i", ignoreCase: true))
        .map4(
          (rl, _, im, i) =>
              comp("${rl.input}-${im.input}$i", rl, im.negate() as RealString),
        )
        .labeled("r-ri"),
    seq3(real(r), infnan(), char("i", ignoreCase: true))
        .map3((rl, inf, i) => comp("${rl.input}${inf.input}$i", rl, inf))
        .labeled("r&inf-or-nan-i"),
    seq3(
      real(r),
      char("+"),
      char("i", ignoreCase: true),
    ).map3((rl, _, i) => comp("${rl.input}+$i", rl, one(r, ""))).labeled("r+i"),
    seq3(real(r), char("-"), char("i", ignoreCase: true))
        .map3((rl, _, i) => comp("${rl.input}-$i", rl, negOne(r, "")))
        .labeled("r-i"),
    seq3(char("+"), ureal(r), char("i", ignoreCase: true))
        .map3((_, im, i) => comp("+${im.input}$i", zero(r, ""), im))
        .labeled("+ri"),
    seq3(char("-"), ureal(r), char("i", ignoreCase: true))
        .map3((_, im, i) => comp("-${im.input}$i", zero(r, ""), im))
        .labeled("-ri"),
    seq2(infnan(), char("i", ignoreCase: true))
        .map2((wn, i) => comp("${wn.input}$i", zero(r, ""), wn))
        .labeled("infnani"),
    real(r),
    string(
      "+i",
      ignoreCase: true,
    ).map((i) => comp(i, zero(r, ""), one(r, ""))).labeled("+i"),
    string(
      "-i",
      ignoreCase: true,
    ).map((i) => comp(i, zero(r, ""), negOne(r, ""))).labeled("-i"),
  ].toChoiceParser().labeled("complex");

  /// Parses a legal real number into a NumString
  Parser<RealString> real(Radix r) => [
    seq2(
      sign(),
      ureal(r),
    ).map2((s, u) => s == "-" ? u.negate() as RealString : u),
    infnan(),
  ].toChoiceParser().labeled("real");

  /// Parses a legal unsigned real number into a NumString
  Parser<RealString> ureal(Radix r) =>
      [decimal(r), ufrac(r), uinteger(r)].toChoiceParser().labeled("ureal");

  Parser<FracString> ufrac(Radix r) => seq3(
    uinteger(r),
    char("/"),
    uinteger(r),
  ).map3((n, _, d) => FracString(r, n.input, d.input));

  /// Parses a legal number with a radix point and optional exponent
  /// Currently only handles base 10
  Parser<WithRadixPoint> decimal(Radix r) {
    if (r != Radix.dec) {
      return failure(message: "decimal only defined for radix 10");
    } else {
      return [
        seq4(
          digit10().plusString(),
          dot(),
          digit10().starString().map((String ds) => ds == "" ? null : ds),
          suffix().optional(),
        ).map4(
          (bef, _, aft, expt) => WithRadixPoint(bef, aft, expt ?? Suffix("")),
        ),
        seq3(
          dot(),
          digit10().plusString(),
          suffix().optional(),
        ).map3((_, aft, expt) => WithRadixPoint("", aft, expt ?? Suffix(""))),
        seq2(
          uinteger(Radix.dec).flatten(),
          suffix(),
        ).map2((bi, expt) => WithRadixPoint(bi, null, expt)),
      ].toChoiceParser().labeled("decimal");
    }
  }

  /// Parses an unsigned integer into a NumString
  Parser<IntString> uinteger(Radix r) =>
      digit(r).plusString().map((s) => IntString(s, r, s)).labeled("uinteger");

  Parser<Prefix> prefix(Radix r) {
    if (r != Radix.dec) {
      return [
        seq2(
          radix(r),
          exactness(),
        ).map2((rd, e) => Prefix("${rd.$1}${e.$1}", rd.$2, e.$2)),
        seq2(
          exactness(),
          radix(r),
        ).map2((e, rd) => Prefix("${e.$1}${rd.$1}", rd.$2, e.$2)),
        radix(r).map((rd) => Prefix("${rd.$1}", rd.$2, Exactness.exact)),
      ].toChoiceParser();
    } else {
      return [
        seq2(
          radix(r),
          exactness(),
        ).map2((rd, e) => Prefix("${rd.$1}${e.$1}", rd.$2, e.$2)),
        seq2(
          exactness(),
          radix(r),
        ).map2((e, rd) => Prefix("${e.$1}${rd.$1}", rd.$2, e.$2)),
        radix(r).map((rd) => Prefix("${rd.$1}", rd.$2, Exactness.exact)),
        exactness().map((e) => Prefix("${e.$1}", Radix.dec, e.$2)),
        epsilonWith(Prefix("", Radix.dec, Exactness.exact)),
      ].toChoiceParser();
    }
  }

  /// Parses the four infinite and not-a-number strings
  Parser<WeirdNum> infnan() => [
    string(
      "+inf.0",
      ignoreCase: true,
    ).map((String s) => WeirdNum(s, double.infinity)),
    string(
      "-inf.0",
      ignoreCase: true,
    ).map((String s) => WeirdNum(s, double.negativeInfinity)),
    string(
      "+nan.0",
      ignoreCase: true,
    ).map((String s) => WeirdNum(s, double.nan)),
    string(
      "-nan.0",
      ignoreCase: true,
    ).map((String s) => WeirdNum(s, double.nan)),
  ].toChoiceParser().labeled("infnan");

  /// Parses an exponent (e.g., E20 or E-5) into a int
  Parser<Suffix> suffix() => seq3(
    exponentMarker(),
    sign(), // returns 1 or -1
    digit10().plusString(),
  ).map3((e, s, ds) => Suffix("$e$s$ds"));

  /// The legal markers for exponents
  Parser<String> exponentMarker() => char("e", ignoreCase: true);

  /// Parses "+", "", or "-" to return 1, 1, or -1, respectively
  Parser<String> sign() => pattern("+-").optional().flatten();

  Parser<(String, Exactness)> exactness() =>
      seq2(char("#"), pattern("ie", ignoreCase: true)).flatten().map(
        (s) => s.toLowerCase().endsWith("i")
            ? (s, Exactness.inexact)
            : (s, Exactness.exact),
      );

  Parser<(String, Radix)> radix(Radix r) => r.prefixParser;

  /// Parses a single digit in the given base
  Parser<String> digit(Radix r) => r.digitParser;

  /*
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
*/
  Parser<AbbrevType> quote() => char("'").mapTo(.quote);
  /*  Parser<String> lambda() => string("lambda");
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
*/
}

/// Legal scheme radixes: 2, 8, 10, 16 (plus one for inf and nan)
enum Radix {
  /// binary
  bin(2, "01", "#b"),

  /// octal
  oct(8, "01234567", "#o"),

  /// decimal
  dec(10, "012346789", "#d"),

  /// hexadecimal
  hex(16, "0123456789abcdefABCDEF", "#x");

  /// the numeric value of the radix
  final int value;

  /// a string containing the legal digits for the radix
  final String legalDigits;

  final String prefix;

  /// constructor
  const Radix(this.value, this.legalDigits, this.prefix);

  /// parser for a digit in this Radix
  Parser<String> get digitParser => switch (this) {
    bin => pattern("01"),
    oct => pattern("0-7"),
    dec => pattern("0-9"),
    hex => pattern("0-9a-f", ignoreCase: true),
  };

  Parser<(String, Radix)> get prefixParser =>
      string(prefix, ignoreCase: true).map((s) => (s, this));
}

/// Converts a Token<T> into a Token<String> where the String is
/// the substring read to create the token
extension TokenOps<T> on Token<T> {
  Token<String> get toStringToken =>
      Token(buffer.substring(start, stop), buffer, start, stop);
}

extension MapTokenValue<T, U> on Parser<Token<T>> {
  Parser<Token<U>> mapTokenValue<U>(U Function(T) f) =>
      map((t) => Token(f(t.value), t.buffer, t.start, t.stop));
}

final BigInt maxByte = BigInt.from(255);

extension IsByte on BigInt {
  bool isByte() => this >= BigInt.zero && this <= maxByte;
}
