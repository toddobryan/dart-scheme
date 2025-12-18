import 'package:checks/checks.dart';
import 'package:checks/context.dart';
import 'package:dart_scheme/dart_scheme/ast.dart';
import 'package:dart_scheme/dart_scheme/error_messages.dart' as e;
import 'package:dart_scheme/dart_scheme/numbers.dart';
import 'package:dart_scheme/dart_scheme/parser.dart';
import 'package:petitparser/petitparser.dart';
import 'package:petitparser/reflection.dart';
import 'package:test/test.dart';

void main() {
  final g = SchemeGrammar();
  
  SuccessTestCase<T> stc<T>(String input, SExprType type, T value, int start, int stop) =>
    SuccessTestCase(input, type, value, start, stop);
  FailureTestCase ftc(String input, String message, int index) =>
    FailureTestCase(input, message, index);

  test("linter", () {
    Parser p = g.build();
    check(linter(p)).isEmpty();
  });

  group("parsing primitives", () {
    test("booleans", () {
      Parser<SExpr<bool>> p = g.buildFrom(g.boolean());
      
      List<SuccessTestCase<bool>> good = [
        stc("#t", SExprType.boolean, true, 0, 2),
        stc("#true", SExprType.boolean, true, 0, 5),
        stc("#f", SExprType.boolean, false, 0, 2),
        stc("#false", SExprType.boolean, false, 0, 6),
      ];
      
      for (SuccessTestCase<bool> tc in good) {
        tc.parses(p);
      }
      
      List<FailureTestCase> bad = [
        ftc("", e.boolean, 0),
        ftc("true", e.boolean, 0),
        ftc("#T", e.boolean, 0),
      ];

      for (FailureTestCase tc in bad) {
        tc.failsToParse(p);
      }
    });

    test("characters", () {
      Parser<SExpr<String>> p = g.buildFrom(g.character());

      List<(String, String)> examples = [
        (r"#\space", " "),
        (r"#\alarm", "\u0007"),
        (r"#\backspace", "\u0008"),
        (r"#\delete", "\u007f"),
        (r"#\escape", "\u001b"),
        (r"#\newline", "\u000a"),
        (r"#\null", "\u0000"),
        (r"#\return", "\u000d"),
        (r"#\space", "\u0020"),
        (r"#\tab", "\u0009"),
        (r"#\A", "A"),
        ("#\\\u0421", "\u0421"),
        ("#\\\ud83d\uDE80", "\u{1f680}"),
        ("#\\\u{1f680}", "\ud83d\uDE80"),
        (r"#\ ", " "),
        ("#\\\n", "\n"),
      ];

      List<SuccessTestCase<String>> good = examples.map((ia) =>
        stc(ia.$1, SExprType.char, ia.$2, 0, ia.$1.length)
      ).toList();

      for (SuccessTestCase<String> tc in good) {
        tc.parses(p);
      }
    });

    test("strings", () {
      Parser<SExpr<String>> p = g.buildFrom(g.sString());

      List<(String, String)> examples = [
        ('""', ""),
        ('"\\"\\n\\\\"', '"\n\\'),
        (r'"abc\' + "\n" + r'123"', "abc123"),
        ('"abc123"', "abc123"),
        ('"⁭╳⌦⒲∛≥⥂⧹⅂⊇⇐⦨⑟⎫⭰⯊⾕⳰✪↢❯♁⮶⪎"', "⁭╳⌦⒲∛≥⥂⧹⅂⊇⇐⦨⑟⎫⭰⯊⾕⳰✪↢❯♁⮶⪎"),
        ('"🍗🍋🍦🍥🍅🌭🍤🍫🍎🍱"', "🍗🍋🍦🍥🍅🌭🍤🍫🍎🍱"),
      ];

      List<SuccessTestCase<String>> good = examples.map((ia) =>
        stc(ia.$1, SExprType.string, ia.$2, 0, ia.$1.length)
      ).toList();

      for (SuccessTestCase<String> tc in good) {
        tc.parses(p);
      }
    });

    test("numbers", () {
      Parser<SExpr<SNumber>> p = g.buildFrom(g.number());

      List<(String, SExprType, SNumber)> examples = [
        ("0", SExprType.number, SExactInteger(10, BigInt.zero)),
        ("#e0.0", SExprType.number, SExactInteger(10, BigInt.zero)),
        ("123", SExprType.number, SExactInteger(10, BigInt.from(123))),
        ("-21", SExprType.number, SExactInteger(10, BigInt.from(-21))),
      ];

      List<SuccessTestCase<SNumber>> good = examples.map((stn) =>
        stc(stn.$1, stn.$2, stn.$3, 0, stn.$1.length)
      ).toList();

      for (SuccessTestCase<SNumber> tc in good) {
        tc.parses(p);
      }


    });
  });
}

extension ResultChecks<T> on Subject<Result<T>> {
  Subject<String> get buffer => has((c) => c.buffer, "buffer");
  Subject<int> get position => has((c) => c.position, "position");
  Subject<String> get positionString =>
      has((c) => c.toPositionString(), "positionString");

  Subject<Failure> isFailure() => context.nest(() => ["is Failure"], (
    Result actual,
  ) {
    if (actual is Failure) {
      return Extracted.value(actual);
    } else {
      return Extracted.rejection(which: ["expected Failure, found: $actual"]);
    }
  });

  Subject<String> get failureMessage =>
      isFailure().has((f) => f.message, "message");

  Subject<Success<T>> isSuccess() =>
      context.nest(() => ["is Success"], (actual) {
        if (actual is Success) {
          return Extracted.value(actual as Success<T>);
        } else {
          return Extracted.rejection(
            which: ['expected Success<$T>, found: $actual'],
          );
        }
      });

  Subject<T> get successValue => isSuccess().has((s) => s.value, "value");
}

extension SExprChecks<T> on Subject<SExpr<T>> {
  Subject<T> get value => has((a) => a.value, "value");
  Subject<SExprType> get type => has((a) => a.type, "type");
  Subject<Token<String>> get token => has((a) => a.token, "token");
}

extension TokenChecks<T> on Subject<Token<T>> {
  Subject<T> get value => has((t) => t.value, "value");
  Subject<int> get start => has((t) => t.start, "start");
  Subject<int> get stop => has((t) => t.stop, "stop");
}

class SuccessTestCase<T> {
  final String input;
  final SExprType type;
  final T value;
  final int start;
  final int stop;

  SuccessTestCase(this.input, this.type, this.value, this.start, this.stop);

  void parses(Parser<SExpr<T>> p) {
    Result<SExpr<T>> result = p.parse(input);
    check(result).successValue
      ..value.equals(value)
      ..type.equals(type);
    check(result).successValue.token
      ..value.equals(input)
      ..start.equals(start)
      ..stop.equals(stop);
  }
}

class FailureTestCase {
  final String input;
  final String message;
  final int index;

  FailureTestCase(this.input, this.message, this.index);

  void failsToParse(Parser<dynamic> p) {
    Result<dynamic> result = p.parse(input);
    check(result).isA<Failure>()
      ..failureMessage.equals(message)
      ..position.equals(index);
  }
}