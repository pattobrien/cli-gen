import 'package:analyzer/dart/ast/ast.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

import '../utils/analyzer_parsers.dart';

void main() {
  group('ArgResults + User Method Invocation - int positional arg', () {
    // TODO: Implement test
    final invocationExp = generateArgResultHandlerExp();
    final singleArg = invocationExp.argumentList.arguments.single;
    test('End-to-end test', () {
      check(singleArg).isA<MethodInvocation>()
        ..has((p0) => p0.realTarget, 'type target')
            .isA<SimpleIdentifier>()
            .has((p0) => p0.name, 'type name')
            .equals('int')
        ..has((p0) => p0.methodName.name, 'method name').equals('parse')
        ..has((p0) => p0.argumentList.arguments.single, 'arguments')
            .isA<IndexExpression>()
            .has((p0) => p0.index, 'index')
            .isA<SimpleStringLiteral>()
            .has((p0) => p0.value, 'value')
            .equals('message'); // the name of the parameter
    });
  });
}
