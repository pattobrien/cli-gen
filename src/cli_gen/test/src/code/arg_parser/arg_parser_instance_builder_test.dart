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

      check(arguments).any(
        (argument) => argument
            .isA<SimpleStringLiteral>()
            .has((p0) => p0.value, 'value')
            .equals('author-date-order'),
      );
    });
  });

  group('ArgParser - Required/Optional:', () {
    test('Mandatory = true', () {
      final arguments = generateOptionArguments(isRequired: true);

      check(arguments).any(
        (argument) => argument.isA<NamedExpression>()
          ..has((p0) => p0.name.label.name, 'name').equals('mandatory')
          ..has((p0) => p0.expression.toSource(), 'value').equals('true'),
      );
    });

    test('Mandatory = false', () {
      final arguments = generateOptionArguments(isRequired: false);

      check(arguments).any(
        (argument) => argument.isA<NamedExpression>()
          ..has((p0) => p0.name.label.name, 'name').equals('mandatory')
          ..has((p0) => p0.expression.toSource(), 'value').equals('false'),
      );
    });
  });

  group('ArgParser - doc comments', () {
    // with doc comments
    test('With doc comments', () {
      final arguments = generateOptionArguments(
        docComment: 'The message to display.',
      );

      check(arguments).any(
        (argument) => argument.isA<NamedExpression>()
          ..has((p0) => p0.name.label.name, 'name').equals('help')
          ..has((p0) => p0.expression.toSource(), 'value')
              .equals("'The message to display.'"),
      );
    });

    test('Without doc comments', () {
      final arguments = generateOptionArguments(
        docComment: null,
      );

      check(arguments).not((p0) {
        p0.any((p0) {
          p0
              .isA<NamedExpression>()
              .has((p0) => p0.name.label.name, 'name')
              .equals('help');
        });
      });
    });
  });

  group('ArgParser - default values', () {
    // without a default value
    // with a default value (literal, e.g. string or int)
    // with a default enum value
  });

  group('ArgParser - Flag vs. Option', () {
    // use flag if the type is a boolean
    test('Use flag when parameter type is a boolean', () {
      final expression = generateArgParserOption(type: TestTypes.bool);

      check(expression)
          .isA<CascadeExpression>()
          .has((p0) => p0.cascadeSections.first, 'cascade section')
          .isA<MethodInvocation>()
          .has((p0) => p0.methodName.name, 'method name')
          .equals('addFlag');
    });
    // use option if the type is not a boolean
  });

  group('ArgParser - different types', () {
    // String
    // int
    // User-defined Enum
    // extension type (e.g. of a String)
  });

  group('ArgParser - multiple options', () {
    // enum with multiple values
    // string with explicit multiple values from Option annotation
  });
}
