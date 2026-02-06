
import "package:checks/checks.dart";
import "package:checks/context.dart";
import "package:dart_scheme/dart_scheme/ast.dart";
import "package:petitparser/core.dart";

extension ResultSExprChecks<T> on Subject<Result<SExpr<T>>> {
  Subject<SExpr<T>> succeeds(
      String input,
      SExprType exprType,
      T value,
      int start,
      int stop,
      ) {
    final Subject<SExpr<T>> subj = isSuccess()
        ..value.equals(value)
        ..type.equals(exprType)
        ..input.equals(input)
        ..start.equals(start)
        ..stop.equals(stop);
    return subj;
  }

  Subject<Failure> fails(String message, int position) {
    final Subject<Failure> subj = isFailure();
    subj.failureMessage.equals(message);
    subj.position.equals(position);
    return subj;
  }

  Subject<String> get buffer => has((c) => c.buffer, "buffer");
  Subject<int> get position => has((c) => c.position, "position");
  Subject<String> get positionString =>
      has((c) => c.toPositionString(), "positionString");

  Subject<Failure> isFailure() => context.nest(() => ["is Failure"], (
      Result<Object> actual,
      ) {
    if (actual is Failure) {
      return Extracted.value(actual);
    } else {
      return Extracted.rejection(which: ["expected Failure, found: $actual"]);
    }
  });

  Subject<String> get failureMessage =>
      isFailure().has((f) => f.message, "message");

  Subject<SExpr<T>> isSuccess() => context.nest(() => ["is Success"], (actual) {
    if (actual is Success) {
      return Extracted.value(actual.value);
    } else {
      return Extracted.rejection(
        which: ["expected Success<$T>, found: $actual"],
      );
    }
  });
}

extension SExprChecks<T> on Subject<SExpr<T>> {
  Subject<T> get value => has((a) => a.value!, "value");
  Subject<SExprType> get type => has((a) => a.type!, "type");
  Subject<String> get input => has((t) => t.input!, "input");
  Subject<int> get start => has((t) => t.start!, "start");
  Subject<int> get stop => has((t) => t.stop!, "stop");
}

extension ResultChecks<T> on Subject<Result<T>> {
  Subject<Success<T>> get isSuccess {
    final Subject<Success<T>> subj = isA<Success<T>>();
    return subj;
  }

  Subject<Failure> get isFailure {
    final Subject<Failure> subj = isA<Failure>();
    return subj;
  }

  Subject<int> get position => has((r) => r.position, "position");

  Subject<Success<T>> succeeds(T value, int position) {
    final Subject<Success<T>> subj = isSuccess;
    subj.value.equals(value);
    subj.position.equals(position);
    return subj;
  }

  Subject<Failure> fails(String message, int position) {
    final Subject<Failure> subj = isFailure;
    subj.message.equals(message);
    subj.position.equals(position);
    return subj;
  }
}

extension SuccessChecks<T> on Subject<Success<T>> {
  Subject<T> get value => has((s) => s.value, "value");
}

extension FailureChecks on Subject<Failure> {
  Subject<String> get message => has((f) => f.message, "message");
}