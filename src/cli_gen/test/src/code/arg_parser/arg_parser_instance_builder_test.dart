import 'package:analyzer/dart/ast/ast.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

import '../../utils/checks/expression_subject_exts.dart';
import '../utils/arg_parser_test_utils.dart';
import '../utils/types.dart';

// Tests the code-generation portion of the `ArgParser` instance builder
// (i.e. taking a `CommandParameterModel` as input and generating the
// Spec instances that contain the generated code).

void main() {
  group('ArgParser Code Generation -', () {
    group('end-to-end test -', () {
      final exp = generateArgParserCascaseExp(
        paramName: 'msg',
        type: TestTypes.string,
      );
      test('Create an ArgParser instance with one option', () async {
        check(exp)
            .isA<CascadeExpression>()
            .has((p0) => p0.cascadeSections.first, 'cascade section')
            .isA<MethodInvocation>()
          ..hasMethodNamed('addOption')
          ..has((p0) => p0.argumentList.arguments.map((e) => e.toSource()),
                  'arguments')
              .unorderedEquals([
            "'msg'",
            "mandatory: true",
            "help: 'The message to display.'",
          ]);
      });
    });

    group('Option names (camelCase to hyphen-case):', () {
      test('single-word parameter name', () {
        final arguments = generateOptionArguments(paramName: 'message');

        check(arguments).any((p0) => p0.isStringWithValue('message'));
      });

      test('Multi-word parameter name', () {
        final arguments = generateOptionArguments(paramName: 'authorDateOrder');

        check(arguments).any(
          (arg) => arg.isStringWithValue('author-date-order'),
        );
      });
    });

    // Tests whether a required or optional parameter is properly set to
    // `mandatory: true` or `mandatory: false`, respectively.
    group('Required vs Optional flags/options:', () {
      test('Required parameter', () {
        final arguments = generateOptionArguments(isRequired: true);

        check(arguments).any(
          (argument) => argument.isA<NamedExpression>()
            ..hasLabelNamed('mandatory')
            ..has((p0) => p0.expression.toSource(), 'value').equals('true'),
        );
      });

      test('Optional parameter', () {
        final arguments = generateOptionArguments(isRequired: false);

        check(arguments).any(
          (arg) => arg.isA<NamedExpression>()
            ..hasLabelNamed('mandatory')
            ..has((p0) => p0.expression.toSource(), 'value').equals('false'),
        );
      });
    });

    /// Tests whether the parameter's doc comment is copied to the
    /// `help` argument of the `addOption` method.
    group('Doc comments:', () {
      test('Parameter WITH doc comments generates `help` arg.', () {
        final args = generateOptionArguments(docComment: 'Foo message.');

        check(args).any(
          (argument) => argument.isA<NamedExpression>()
            ..hasLabelNamed('help')
            ..has((p0) => p0.expression.toSource(), 'value')
                .equals("'Foo message.'"),
        );
      });

      test('Parameter WITHOUT doc comment doesn\'t generate `help` arg.', () {
        final args = generateOptionArguments(docComment: null);

        check(args).not(
          (p0) => p0.any(
            (p0) => p0.isA<NamedExpression>().hasLabelNamed('help'),
          ),
        );
      });
    });

    /// Tests whether the parameter's default value is copied to the
    /// `defaultsTo` argument of the `ArgParser.addOption` method.
    ///
    /// The generated expression should always be of either type BooleanLiteral
    /// or StringLiteral.
    group('Default values:', () {
      test('Parameter WITHOUT default value has no `defaultTo` arg.', () {
        final arguments = generateOptionArguments(computedDefaultValue: null);

        check(arguments).not((p0) => p0.any(
            (p0) => p0.isA<NamedExpression>().hasLabelNamed('defaultsTo')));
      });

      test('Parameter WITH default value has a `defaultTo` arg.', () {
        final arguments = generateOptionArguments(
          computedDefaultValue: 'value1',
        );

        check(arguments).any(
          (argument) => argument.isA<NamedExpression>()
            ..hasLabelNamed('defaultsTo')
            ..has((p0) => p0.expression, 'expression')
                .isStringWithValue('value1'),
        );
      });

      // TODO with a default int value
      // TODO with a default enum value
    });

    group('ArgParser.addFlag specifics:', () {
      final expression = generateArgParserCascaseExp(type: TestTypes.bool);

      test('Use `addFlag` method when parameter type is a boolean', () {
        check(expression)
            .isA<CascadeExpression>()
            .has((p0) => p0.cascadeSections.single, 'cascade section')
            .isA<MethodInvocation>()
            .hasMethodNamed('addFlag');
      });

      /// NOTE: `bool` parameter types are the only case where the defaultsTo
      /// is not a string value
      test('`defaultsTo` should be a boolean literal, not a string', () {
        final arguments = generateOptionArguments(
          type: TestTypes.bool,
          computedDefaultValue: 'true',
          isBoolean: true,
        );
        check(arguments).any(
          (argument) => argument.isA<NamedExpression>()
            ..hasLabelNamed('defaultsTo')
            ..has((p0) => p0.expression, 'defaultsTo')
                .isA<BooleanLiteral>()
                .has((p0) => p0.value, 'value')
                .equals(true),
        );
      });
    });

    group('Different types', () {
      // String
      // int
      // User-defined Enum
      // extension type (e.g. of a String)
    });

    /// If the parameter is an iterable, the `addMultiOption` method should be
    /// used instead of `addOption` or `addFlag`.
    group('Multiple options', () {
      // list of integers
      // string with explicit multiple values from `@Option` annotation
    });

    // TODO: misc other use cases
    // - generate a `abbr` value based on the first letter of the option name
    //   - if the first letter is already used, then what?
  });
}
