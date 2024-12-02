import 'package:analyzer/dart/ast/ast.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

import '../../utils/checks/expression_subject_exts.dart';
import '../utils/utils.dart';

void main() {
  group('`ArgResults` to User Method Call -', () {
    group('End-to-end tests', () {
      final invocationExp = generateUserMethodCallExp(
        paramName: 'myParam',
        isNamed: true,
      );

      test('Single positional parameter (e2e)', () {
        check(invocationExp)
          ..hasMethodNamed('userMethod')
          ..hasSingleArg().isA<NamedExpression>().which((p0) => p0
            ..hasLabelNamed('myParam')
            ..has((p) => p.expression, 'expression')
                .isA<IndexExpression>()
                .which((p0) => p0
                  ..hasTargetNamed('results')
                  ..hasKeyNamed('my-param')));
      });
    });

    /// Tests if the `userMethod()` call is correctly generated with
    /// NamedExpressions for named parameters, and non-NamedExpressions
    /// for positional parameters.
    group('Positional and Named arguments:', () {
      // TODO:
      // positional arg case
      test('Positional', () {
        final methodCall = generateUserMethodCallExp(
          paramName: 'myParam',
          isNamed: false,
        );

        check(methodCall)
          ..hasMethodNamed('userMethod')
          ..hasSingleArg().isA<IndexExpression>().hasKeyNamed('my-param');
      });

      test('Named', () {
        final invocationExp = generateUserMethodCallExp(
          paramName: 'myParam',
          isNamed: true,
        );

        check(invocationExp)
          ..hasMethodNamed('userMethod')
          ..hasSingleArg().isA<NamedExpression>().which(
                (p0) => p0
                  ..hasLabelNamed('myParam')
                  ..has((p) => p.expression, 'expression')
                      .isA<IndexExpression>()
                      .hasKeyNamed('my-param'),
              );
      });
    });

    group('Nullable expressions (positional):', () {
      // TODO: need to go back over these
      // all of the following cases are positional:
      // optional + nullable     + no default:  e.g. `([int? x])` -> `callSite(result['message'] != null ? int.parse(result['message']) : null);`
      // required + non-nullable + no default:  e.g. `(int x)` -> `callSite(int.parse(result['message']));`
      // optional + nullable     + default:     e.g. `([int? x = 42])` -> `callSite(result['message'] != null ? int.parse(result['message']) : null);`
      // optional + non-nullable + default:     e.g. `([int x = 42])` -> `callSite(result['message'] != null ? int.parse(result['message']) : 42);`
    });

    group('Nullable expressions (named):', () {
      // all of the following cases are named.

      // NOTE: the following intricacies:
      // - 1 and 3 can both allow passing `null`, since the parameter is nullable
      // - 2 and 4 cannot pass `null`, however:
      //   - since 4 has a default value, we can use a copy of that `defaultValueCode` for the null case
      //   - 2, on the other hand, will need to throw an error if `value` is null
      // - In 3, Since the user is saying that they want to allow a nullable value, yet are providing
      //   a default value, it ~seems~ to imply that they want to allow `null` as a value.
      //   Therefore, we make an effort to provide a `null` value in the case that `value` is `null`...
      //   ... but because of which, the default value is NEVER used, under any scenarios.
      //   Not sure if this is correct, but it seems to be the most logical approach.

      // 1. optional + nullable     + no default:  e.g. `({int? x})` -> `callSite(x: value != null ? int.parse(value) : null);`
      // 2. required + non-nullable + no default:  e.g. `({required String x})` -> `callSite(x: int.parse(value));`
      // 3. optional + nullable     + default:     e.g. `({int? x = 42})` -> `callSite(x: value != null ? int.parse(value) : null);`
      // 4. optional + non-nullable + default:     e.g. `({String x = 'foo'})`  -> `callSite(x: value != null ? int.parse(value) : 42);`
    });

    /// Tests if argument expressions passed to `userMethod()` use the expected
    /// parser expressions.
    ///
    /// For example, a parameter type of `int` expects a parser expression of
    /// `int.parse`, but a parameter type of `String` does not expect a parser
    /// expression at all.
    group('Type parsing:', () {
      /// The single argument = `result['message']` (i.e. no parsing needed)
      test('String (no parser needed)', () {
        final invocationExp = generateUserMethodCallExp(
          paramType: TestTypes.string,
          parser: null,
        );
        check(invocationExp).hasSingleArg().isA<IndexExpression>()
          ..hasTargetNamed('results')
          ..hasKeyNamed('message');
      });

      /// The single argument = `int.parse(result['message'])`
      test('int (uses `int.parse`)', () {
        final invocationExp = generateUserMethodCallExp(
          paramType: TestTypes.int_,
          parser: 'int.parse',
        );
        check(invocationExp).hasSingleArg().isA<MethodInvocation>()
          ..hasRealTargetNamed('int')
          ..hasMethodNamed('parse')
          ..hasSingleArg().isA<IndexExpression>().which((p0) => p0
            ..hasTargetNamed('results')
            ..hasKeyNamed('message'));
      });

      test('Uri (uses `Uri.parse`)', () {
        final invocationExp = generateUserMethodCallExp(
          paramType: TestTypes.uri,
          parser: 'Uri.parse',
        );

        check(invocationExp).hasSingleArg().isA<MethodInvocation>()
          ..hasRealTargetNamed('Uri')
          ..hasMethodNamed('parse')
          ..hasSingleArg().isA<IndexExpression>().which((p0) => p0
            ..hasTargetNamed('results')
            ..hasKeyNamed('message'));
      });

      // expression = List<String>.from(result['message']).map(int.parse).toList()
      test(
          'List<int> (uses `List<String>.from(result[\'foo\'].map(int.parse).toList()`)',
          () {
        final invocationExp = generateUserMethodCallExp(
          paramType: TestTypes.listOf(TestTypes.int_),
          parser: 'int.parse',
          defaultValueCode: null,
          computedDefaultValue: null,
          isRequired: true,
          isIterable: true,
        );

        check(invocationExp).hasSingleArg().isA<MethodInvocation>()
          ..hasMethodNamed('toList')
          ..has((p0) => p0.realTarget, 'real target')
              .isA<MethodInvocation>()
              .which(
                (p0) => p0
                  ..hasMethodNamed('map')
                  ..hasSingleArg().which((p0) => p0
                      .isA<PrefixedIdentifier>()
                      .has((p0) => p0.name, 'identifier')
                      .equals('int.parse'))
                  ..has((p0) => p0.realTarget, 'instance creation target')
                      .isA<InstanceCreationExpression>()
                      .which((p0) => p0
                        ..has((p0) => p0.constructorName.type, 'type name')
                            .which((p0) => p0
                              ..hasName('List')
                              ..hasSingleTypeArg()
                                  .isA<NamedType>()
                                  .hasName('String'))
                        ..hasSingleArg().isA<IndexExpression>().which((p0) => p0
                          ..hasTargetNamed('results')
                          ..hasKeyNamed('message'))),
              );
      });
    });
  });
}
