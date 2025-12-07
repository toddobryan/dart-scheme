import 'package:checks/checks.dart';
import 'package:dart_scheme/dart_scheme/ast.dart';
import 'package:dart_scheme/dart_scheme/parser.dart';
import 'package:petitparser/petitparser.dart';
import 'package:petitparser/reflection.dart';
import 'package:test/test.dart';

void main() {
  final g = SchemeGrammar();

  test("linter", () {
    Parser p = g.build();
    check(linter(p)).isEmpty();
  });

  test("parsing primitives", () {
    Parser<SBoolean> p = g.buildFrom(g.boolean());

    var t = p.parse("#t").value;
    check(t).isA<SBoolean>().has((x) => x.value, "value").equals(true);
    var f = p.parse("#f").value;
    check(f).isA<SBoolean>().has((x) => x.value, "value").equals(false);
  });
}
