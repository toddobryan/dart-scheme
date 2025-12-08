import 'package:dart_scheme/dart_scheme/numbers.dart';
import 'package:petitparser/petitparser.dart';

enum Exactness { exact, inexact }

class Pair {
  dynamic cons;
  dynamic cdr;

  Pair(this.cons, this.cdr);
}

abstract class SAst<R> {
  final R value;
  Token<String> token;

  SAst(this.value, this.token);
}

class SBoolean extends SAst<bool> {
  SBoolean(super.value, super.token);
}

class SPair extends SAst<Pair> {
  SPair(super.value, super.token);
}

class SSymbol extends SAst<Symbol> {
  SSymbol(super.value, super.token);
}

class SNumber extends SAst<SNumeric> {
  SNumber(super.value, super.token);
}

// TODO: check that String is only one character
class SChar extends SAst<String> {
  SChar(super.value, super.token)
    : assert(
        value.runes.length == 1,
        "chars are represented by strings exactly one character long",
      );
}

class SString extends SAst<String> {
  SString(super.value, super.token);
}

class SVector extends SAst<List<dynamic>> {
  SVector(super.value, super.token);
}
