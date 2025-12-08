import 'package:checks/checks.dart';
import 'package:checks/context.dart';
import 'package:dart_scheme/dart_scheme/ast.dart';
import 'package:dart_scheme/dart_scheme/error_messages.dart' as e;
import 'package:dart_scheme/dart_scheme/parser.dart';
import 'package:petitparser/debug.dart';
import 'package:petitparser/petitparser.dart';
import 'package:petitparser/reflection.dart';
import 'package:test/test.dart';

void main() {
  final g = SchemeGrammar();

  test("linter", () {
    Parser p = g.build();
    check(linter(p)).isEmpty();
  });

  group("parsing primitives", () {
    test("booleans", () {
      Parser<SBoolean> p = g.buildFrom(g.boolean());

      Result<SBoolean> t = p.parse("#t");
      check(t).successValue.value.equals(true);
      Result<SBoolean> f = p.parse("#f");
      check(f).successValue.value.equals(false);

      Result<SBoolean> empty = p.parse("");
      check(empty)
        ..failureMessage.equals(e.boolean)
        ..position.equals(0);
      Result<SBoolean> trueX = p.parse("true");
      check(trueX)
        ..failureMessage.equals(e.boolean)
        ..position.equals(0);
      Result<SBoolean> hash = p.parse("#T");
      check(hash)
        ..failureMessage.equals(e.boolean)
        ..position.equals(0);
    });

    test("characters", () {
      Parser<SChar> p = g.buildFrom(g.character());

      Result<SChar> space = p.parse("#\\space");
      check(space).successValue.value.equals(" ");
      Result<SChar> newline = p.parse("#\\newline");
      check(newline).successValue.value.equals("\n");
      Result<SChar> backslash = p.parse("#\\\\");
      check(backslash).successValue.value.equals("\\");
      Result<SChar> simpleChar = p.parse("#\\A");
      check(simpleChar).successValue.value.equals("A");
      Result<SChar> unicode = p.parse("#\\\u0421");
      check(unicode).successValue.value.equals("\u0421");
      Result<SChar> surrogatePair = p.parse("#\\\ud83d\ude80");
      check(surrogatePair).successValue.value.equals("\u{1f680}");
      Result<SChar> surrogatePair2 = p.parse("#\\\u{1f680}");
      check(surrogatePair2).successValue.value.equals("\ud83d\ude80");
      Result<SChar> space2 = p.parse("#\\ ");
      check(space2).successValue.value.equals(" ");
    });

    test("strings", () {
      // NOTE: \n and \t (and all the others) are not in the spec
      Parser<SString> p = g.buildFrom(g.sString());
      Result<SString> empty = p.parse('""');
      check(empty).successValue.value.equals("");
      Result<SString> escapes = p.parse('"\\"\n\\\\"');
      check(escapes).successValue.value.equals('"\n\\');
      Result<SString> normal = p.parse('"abc123"');
      check(normal).successValue.value.equals("abc123");
      Result<SString> unicode = p.parse('"⁭╳⌦⒲∛≥⥂⧹⅂⊇⇐⦨⑟⎫⭰⯊⾕⳰✪↢❯♁⮶⪎"');
      check(unicode).successValue.value.equals("⁭╳⌦⒲∛≥⥂⧹⅂⊇⇐⦨⑟⎫⭰⯊⾕⳰✪↢❯♁⮶⪎");
      Result<SString> surrPairs = p.parse('"🍗🍋🍦🍥🍅🌭🍤🍫🍎🍱"');
      check(surrPairs).successValue.value.equals("🍗🍋🍦🍥🍅🌭🍤🍫🍎🍱");
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

extension SAstChecks<T> on Subject<SAst<T>> {
  Subject<T> get value => has((a) => a.value, "value");
  Subject<Token<String>> get token => has((a) => a.token, "token");
}
