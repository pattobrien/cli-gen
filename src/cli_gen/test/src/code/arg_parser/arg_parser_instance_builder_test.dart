import 'package:analyzer/dart/ast/ast.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

import '../utils/analyzer_parsers.dart';
import '../utils/types.dart';

void main() {
  final expression = generateArgParserOption(
    paramName: 'message',
    type: TestTypes.string,
  );
  test('Create an ArgParser instance with one option', () async {
    check(expression)
        .isA<CascadeExpression>()
        .has((p0) => p0.cascadeSections.first, 'cascade section')
        .isA<MethodInvocation>()
      ..has((p0) => p0.methodName.name, 'method name').equals('addOption')
      ..has((p0) => p0.argumentList.arguments.map((e) => e.toSource()),
              'arguments')
          .unorderedEquals([
        "'message'",
        "mandatory: true",
        "valueHelp: 'property'",
        "help: 'The message to display.'",
      ]);
  });
  group('ArgParser - Option names', () {
    test('Simple option name', () {
      final arguments = generateOptionArguments(paramName: 'message');

      check(arguments).any((p0) {
        p0
            .isA<SimpleStringLiteral>()
            .has((p0) => p0.value, 'value')
            .equals('message');
      });
    });

    test('Multi-word option names', () {
      final arguments = generateOptionArguments(paramName: 'authorDateOrder');

      check(arguments).any((p0) {
        p0
            .isA<SimpleStringLiteral>()
            .has((p0) => p0.value, 'value')
            .equals('author-date-order');
      });
    });
  });
}
