import 'package:analyzer/dart/ast/ast.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

import '../utils/analyzer_parsers.dart';
import '../utils/types.dart';

void main() {
  group('ArgParser - end-to-end test', () {
    final exp = generateArgParserOption(
      paramName: 'msg',
      type: TestTypes.string,
    );
    test('Create an ArgParser instance with one option', () async {
      check(exp)
          .isA<CascadeExpression>()
          .has((p0) => p0.cascadeSections.first, 'cascade section')
          .isA<MethodInvocation>()
        ..has((p0) => p0.methodName.name, 'method name').equals('addOption')
        ..has((p0) => p0.argumentList.arguments.map((e) => e.toSource()),
                'arguments')
            .unorderedEquals([
          "'msg'",
          "mandatory: true",
          "valueHelp: 'property'",
          "help: 'The message to display.'",
        ]);
    });
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
      final args = generateOptionArguments(docComment: 'Foo message.');

      check(args).any(
        (argument) => argument.isA<NamedExpression>()
          ..has((p0) => p0.name.label.name, 'name').equals('help')
          ..has((p0) => p0.expression.toSource(), 'value')
              .equals("'Foo message.'"),
      );
    });

    test('Without doc comments', () {
      final args = generateOptionArguments(docComment: null);

      check(args).not((p0) => p0.any(
            (p0) => p0
                .isA<NamedExpression>()
                .has((p0) => p0.name.label.name, 'name')
                .equals('help'),
          ));
    });
  });

  group('ArgParser - default values', () {
    // without a default value
    test('No default value', () {
      final arguments = generateOptionArguments(defaultValue: null);

      check(arguments).not((p0) => p0.any(
            (p0) => p0
                .isA<NamedExpression>()
                .has((p0) => p0.name.label.name, 'name')
                .equals('defaultsTo'),
          ));
    });

    // with a default value (literal, e.g. string or int)

    test('With a string default value', () {
      final arguments = generateOptionArguments(
        computedDefaultValue: "'value1'",
        defaultValue: 'MyFooEnum.value1',
      );

      check(arguments).any(
        (argument) => argument.isA<NamedExpression>()
          ..has((p0) => p0.name.label.name, 'name').equals('defaultsTo')
          ..has((p0) => p0.expression, 'value')
              .isA<SimpleStringLiteral>()
              .has((p0) => p0.value, 'string value')
              .equals('value1'),
      );
    });
    // with a default enum value
  });

  group('ArgParser - Flag specifics (vs. Options)', () {
    final expression = generateArgParserOption(type: TestTypes.bool);

    test('Use `addFlag` method when parameter type is a boolean', () {
      check(expression)
          .isA<CascadeExpression>()
          .has((p0) => p0.cascadeSections.first, 'cascade section')
          .isA<MethodInvocation>()
          .has((p0) => p0.methodName.name, 'method name')
          .equals('addFlag');
    });

    test('`defaultsTo` should be a boolean literal, not a string', () {
      final arguments = generateOptionArguments(
        type: TestTypes.bool,
        docComment: 'A boolean value.',
        defaultValue: 'true',
        computedDefaultValue: 'true',
      );
      // note: this is the only case where the defaultsTo is not a string value
      check(arguments).any(
        (argument) => argument.isA<NamedExpression>()
          ..has((p0) => p0.name.label.name, 'name').equals('defaultsTo')
          ..has((p0) => p0.expression, 'defaultsTo')
              .isA<BooleanLiteral>()
              .has((p0) => p0.value, 'value')
              .equals(true),
      );
    });
  });

  group('ArgParser - different types', () {
    // String
    // int
    // User-defined Enum
    // extension type (e.g. of a String)
  });

  group('ArgParser - multiple options', () {
    // list of integers
    // string with explicit multiple values from Option annotation
  });

  // TODO: misc other use cases
  // - generate a `abbr` value based on the first letter of the option name
  //   - if the first letter is already used, then what?
}
