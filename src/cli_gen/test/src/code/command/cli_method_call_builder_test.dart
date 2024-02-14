import 'package:analyzer/dart/ast/ast.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

import '../../utils/checks/expression_subject_exts.dart';
import '../utils/analyzer_parsers.dart';
import '../utils/types.dart';

void main() {
  group('`ArgResults` to User Method Call -', () {
    group('End-to-end tests', () {
      final invocationExp = generateUserMethodCallExp(
        paramName: 'myParam',
        isNamed: true,
      );

      test('Single positional parameter', () {
        check(invocationExp).isA<MethodInvocation>()
          ..has((p0) => p0.methodName.name, 'method name').equals('userMethod')
          ..has((p0) => p0.argumentList.arguments.single, 'arguments')
              .isA<NamedExpression>()
              .which(
                (p0) => p0
                  ..has((p) => p.name.label.name, 'name').equals('myParam')
                  ..has((p) => p.expression, 'expression')
                      .isA<IndexExpression>()
                      .has((p0) => p0.index, 'index')
                      .isA<SimpleStringLiteral>()
                      .has((p0) => p0.value, 'value')
                      .equals('my-param'), // the name of the parameter);
              );
      });
    });

    group('Positional and Named arguments:', () {
      // TODO:
      // positional arg case
      test('Positional', () {
        final invocationExp = generateUserMethodCallExp(
          paramName: 'myParam',
          isNamed: false,
        );

        check(invocationExp).isA<MethodInvocation>()
          ..has((p0) => p0.methodName.name, 'method name').equals('userMethod')
          ..has((p0) => p0.argumentList.arguments.single, 'arguments')
              .isA<IndexExpression>()
              .has((p0) => p0.index, 'index')
              .isA<SimpleStringLiteral>()
              .has((p0) => p0.value, 'value')
              .equals('my-param'); // the name of the parameter);
      });

      // named arg case
      test('Named', () {
        final invocationExp = generateUserMethodCallExp(
          paramName: 'myParam',
          isNamed: true,
        );

        check(invocationExp).isA<MethodInvocation>()
          ..has((p0) => p0.methodName.name, 'method name').equals('userMethod')
          ..has((p0) => p0.argumentList.arguments.single, 'arguments')
              .isA<NamedExpression>()
              .which(
                (p0) => p0
                  ..has((p) => p.name.label.name, 'name').equals('myParam')
                  ..has((p) => p.expression, 'expression')
                      .isA<IndexExpression>()
                      .has((p0) => p0.index, 'index')
                      .isA<SimpleStringLiteral>()
                      .has((p0) => p0.value, 'value')
                      .equals('my-param'), // the name of the parameter);
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

    group('Type parsing:', () {
      test('String (no parser needed)', () {
        final invocationExp = generateUserMethodCallExp(
          paramType: TestTypes.string,
          parser: null,
        );
        final singleArg = invocationExp.argumentList.arguments.single;

        check(singleArg).isA<IndexExpression>()
          ..hasTargetNamed('results')
          ..hasKeyNamed('message');
      });
      // - int.parse
      test('int (uses `int.parse`)', () {
        final invocationExp = generateUserMethodCallExp(
          paramType: TestTypes.int_,
          parser: 'int.parse',
          defaultValueCode: null,
          computedDefaultValue: null,
          isRequired: true,
        );
        final singleArg = invocationExp.argumentList.arguments.single;

        check(singleArg).isA<MethodInvocation>()
          ..hasMethodNamed('parse')
          ..hasRealTargetNamed('int')
          ..hasSingleArg().isA<IndexExpression>().which((p0) => p0
            ..hasTargetNamed('results')
            ..hasKeyNamed('message'));
      });

      test('Uri (uses `Uri.parse`)', () {
        final invocationExp = generateUserMethodCallExp(
          paramType: TestTypes.uri,
          parser: 'Uri.parse',
          defaultValueCode: null,
          computedDefaultValue: null,
          isRequired: true,
        );
        final singleArg = invocationExp.argumentList.arguments.single;

        check(singleArg).isA<MethodInvocation>()
          ..hasRealTargetNamed('Uri')
          ..hasMethodNamed('parse')
          ..hasSingleArg().isA<IndexExpression>().which((p0) => p0
            ..hasTargetNamed('results')
            ..hasKeyNamed('message'));
      });

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
        final singleArg = invocationExp.argumentList.arguments.single;

        // target = List<String>.from(result['foo']).map(int.parse)
        // method = .toList()

        check(singleArg)
            .isA<MethodInvocation>()
            .has((p0) => p0.realTarget, 'real target')
            // -- `map(int.parse)` part of the expression
            .isA<MethodInvocation>()
          ..has((p0) => p0.methodName.name, 'method name').equals('map')
          ..hasSingleArg().which((p0) => p0
              .isA<PrefixedIdentifier>()
              .has((p0) => p0.name, 'identifier')
              .equals('int.parse'))
          ..has((p0) => p0.realTarget, 'second real target')
              .isA<InstanceCreationExpression>()
              .has((p0) => p0.constructorName.type, 'type name')
              .which((p0) {
            p0.has((p0) => p0.name2.lexeme, 'type name').equals('List');
            p0.has((p0) => p0.typeArguments!.arguments.single, 'type arguments')
              ..isA<NamedType>()
              ..has((p0) => (p0 as NamedType).name2.lexeme,
                      'type argument name')
                  .equals('String');
          });
      });
    });
  });
}
