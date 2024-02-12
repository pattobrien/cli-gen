import 'package:analyzer/dart/ast/ast.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

import '../utils/analyzer_parsers.dart';
import '../utils/types.dart';

void main() {
  group('ArgResults + User Method Invocation - int positional arg', () {
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

  group('ArgResults + User Method - Positional and Named', () {
    // TODO:
    // positional arg case
    // named arg case
  });

  group('User Method Invocation - Positional arguments', () {
    // TODO: need to go back over these
    // all of the following cases are positional:
    // optional + nullable     + no default:  e.g. `([int? x])` -> `callSite(result['message'] != null ? int.parse(result['message']) : null);`
    // required + non-nullable + no default:  e.g. `(int x)` -> `callSite(int.parse(result['message']));`
    // optional + nullable     + default:     e.g. `([int? x = 42])` -> `callSite(result['message'] != null ? int.parse(result['message']) : null);`
    // optional + non-nullable + default:     e.g. `([int x = 42])` -> `callSite(result['message'] != null ? int.parse(result['message']) : 42);`
  });

  void func([int x = 42]) {}

  void yCaller(Map<String, dynamic> result) {
    func(result['message'] != null ? int.parse(result['message']) : 42);
  }

  group('User Method Invocation - Named arguments', () {
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

  group('User Method Invocation - Built in type parsing', () {
    // - String (i.e. no parsing needed)
    test('String (no parser needed)', () {
      final invocationExp = generateArgResultHandlerExp(
        paramType: TestTypes.string,
        parser: null,
      );
      final singleArg = invocationExp.argumentList.arguments.single;

      check(singleArg).isA<IndexExpression>()
        ..hasIdentifierNamed('results')
        ..hasKeyNamed('message');
    });
    // - int.parse
    test('int (uses int.parse)', () {
      final invocationExp = generateArgResultHandlerExp(
        paramType: TestTypes.int_,
        parser: 'int.parse',
        defaultValueCode: null,
        computedDefaultValue: null,
        isRequired: true,
      );
      final singleArg = invocationExp.argumentList.arguments.single;

      check(singleArg).isA<MethodInvocation>()
        ..hasMethodNamed('parse')
        ..hasTargetNamed('int')
        ..hasIndexExpArgument().which((p0) => p0
          ..hasIdentifierNamed('results')
          ..hasKeyNamed('message'));
    });
    // - Uri.parse
    test('Uri (uses Uri.parse)', () {
      final invocationExp = generateArgResultHandlerExp(
        paramType: TestTypes.uri,
        parser: 'Uri.parse',
        defaultValueCode: null,
        computedDefaultValue: null,
        isRequired: true,
      );
      final singleArg = invocationExp.argumentList.arguments.single;

      check(singleArg).isA<MethodInvocation>()
        ..hasMethodNamed('parse')
        ..hasTargetNamed('Uri')
        ..hasIndexExpArgument().which((p0) => p0
          ..hasIdentifierNamed('results')
          ..hasKeyNamed('message'));
    });
    // - List<int>
    // test('List<int> (uses `map(int.parse)`)', () {
    //   // final results = Map<String, dynamic>.from({'message': '42'});
    //   // final parsed = (results['message'] as List<String>).map(int.parse).toList();
    //   final invocationExp = generateArgResultHandlerExp(
    //     paramType: TestTypes.listOf(TestTypes.int_),
    //     parser: 'List<int>.from',
    //     defaultValueCode: null,
    //     computedDefaultValue: null,
    //     isRequired: true,
    //   );
    //   final singleArg = invocationExp.argumentList.arguments.single;

    //   check(singleArg).isA<MethodInvocation>()
    //     ..hasMethodNamed('from')
    //     ..hasTargetNamed('List<int>')
    //     ..hasIndexExpArgument().which((p0) => p0
    //       ..hasIdentifierNamed('results')
    //       ..hasKeyNamed('message'));
    // });
  });

  group('User Method Invocation - Custom type parsing', () {
    // - user-defined enum
    // - user-defined extension type
    // - user-defined class
    // - user-defined function passed to annotation
  });
}

void callSite({int x = 42}) {}

void callingMain2(dynamic value) {
  callSite(x: value != null ? int.parse(value) : 42);
}

extension on Subject<MethodInvocation> {
  Subject<IndexExpression> hasIndexExpArgument() {
    return has((p0) => p0.argumentList.arguments.single, 'single argument')
        .isA<IndexExpression>();
  }

  void hasMethodNamed(String name) {
    has((p0) => p0.methodName.name, 'method name').equals(name);
  }

  void hasTargetNamed(String name) {
    has((p0) => p0.realTarget, 'type target')
        .isA<SimpleIdentifier>()
        .has((p0) => p0.name, 'type name')
        .equals(name);
  }
}

extension on Subject<IndexExpression> {
  void hasIdentifierNamed(String name) {
    has((p0) => p0.target, 'name')
        .isA<SimpleIdentifier>()
        .has((p0) => p0.name, 'name')
        .equals(name);
  }

  void hasKeyNamed(String name) {
    has((p0) => p0.index, 'index expression')
        .isA<SimpleStringLiteral>()
        .has((p0) => p0.value, 'key value')
        .equals(name);
  }
}
