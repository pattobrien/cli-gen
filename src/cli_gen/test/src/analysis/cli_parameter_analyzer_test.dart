import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:checks/checks.dart';
import 'package:cli_gen/src/analysis/cli_parameter_analyzer.dart';
import 'package:test/test.dart';

import '../../example_usage/args_example.dart' as test_file;

/// This tests the [test_file.commit] function.
void main() async {
  final root = Directory.current;
  final testFilePath = '${root.path}/test/example_usage/args_example.dart';
  final unit = await resolveFile2(path: testFilePath);
  if (unit is! ResolvedUnitResult) {
    throw Exception('Failed to resolve unit');
  }

  final functions = unit.unit.declaredElement!.functions;

  final paramAnalyzer = CliParameterAnalyzer();

  test('End to end parameter analyzer validation', () async {
    final executable = functions.first;
    final parameters = paramAnalyzer.fromExecutableElement(executable);

    check(parameters).has((p0) => p0.length, 'length').equals(1);

    final parameter = parameters.single;

    check(parameter).has((p0) => p0.name.symbol, 'name').equals('message');

    check(parameter).has((p0) => p0.type.symbol, 'type').equals('String');
    check(parameter).has((p0) => p0.isRequired, 'isRequired').equals(true);
    check(parameter).has((p0) => p0.isNamed, 'isNamed').equals(false);
    check(parameter)
        .has((p0) => p0.defaultValueCode, 'defaultValueCode')
        .isNull();

    //TODO: handle docComments (waiting for response from Dart team on
    // how doc comments will be handled with macros)

    // check(parameter)
    //     .has((p0) => p0.docComments, 'docComments')
    //     .equals('The message to display.');
    // check(parameter).has((p0) => p0.annotations, 'annotations').isEmpty();
  });

  group('Command parameters - Supported primative types:', () {
    final executable = functions.firstWhere((e) => e.name == 'primativeTypes');
    // literal String

    test('String Literal', () {
      final parameters = paramAnalyzer.fromExecutableElement(executable);
      final parameter =
          parameters.firstWhere((p) => p.name.symbol == 'stringValue');
      check(parameter)
        ..has((p0) => p0.type.symbol, 'type').equals('String')
        ..has((p0) => p0.type.url, 'type url').equals('dart:core');
    });
    // literal int
    test('Integer Literal', () {
      final parameters = paramAnalyzer.fromExecutableElement(executable);
      final parameter =
          parameters.firstWhere((p) => p.name.symbol == 'intValue');
      check(parameter)
        ..has((p0) => p0.type.symbol, 'type').equals('int')
        ..has((p0) => p0.type.url, 'type url').equals('dart:core');
    });
    // literal boolean

    test('Boolean Literal', () {
      final parameters = paramAnalyzer.fromExecutableElement(executable);
      final parameter =
          parameters.firstWhere((p) => p.name.symbol == 'boolValue');
      check(parameter)
        ..has((p0) => p0.type.symbol, 'type').equals('bool')
        ..has((p0) => p0.type.url, 'type url').equals('dart:core');
    });

    // // TODO: extension type (of primative)

    // test('Extension type (of a primative)', () {
    //   final parameters = paramAnalyzer.fromExecutableElement(executable);
    //   final parameter =
    //       parameters.firstWhere((p) => p.name.symbol == 'emailValue');
    //   check(parameter)
    //     ..has((p0) => p0.type.symbol, 'type').equals('Email')
    //     ..has((p0) => p0.type.url, 'type url').equals('args_example.dart');
    // });
  });

  group('Command parameters - User-defined types', () {
    // TODO: define scope
    // SEE: @FromString annotation
    // user-defined enum
    // user-defined extension type (of a primative)
    // user-defined interface type
  });

  group('Command parameters - Annotations', () {
    // TODO: handle configuring the parser with annotations (e.g. @Option)
  });

  group('Command parameters - Doc comments', () {
    // TODO: without doc comment
    // TODO: with doc comment
  });

  group('Command parameters - Default values', () {
    final executable = functions.firstWhere((e) => e.name == 'defaultValues');
    final parameters = paramAnalyzer.fromExecutableElement(executable);

    test('String Default Value', () {
      final parameter =
          parameters.firstWhere((p) => p.name.symbol == 'defaultValue');
      check(parameter)
          .has((p0) => p0.defaultValueCode, 'defaultValueCode')
          .equals("'default'");
    });

    test('Boolean Default Value', () {
      final parameter =
          parameters.firstWhere((p) => p.name.symbol == 'defaultBool');
      check(parameter)
          .has((p0) => p0.defaultValueCode, 'defaultValueCode')
          .equals('true');
    });

    test('Integer Default Value', () {
      final parameter =
          parameters.firstWhere((p) => p.name.symbol == 'defaultInt');
      check(parameter)
          .has((p0) => p0.defaultValueCode, 'defaultValueCode')
          .equals('42');
    });

    test('Enum Default Value', () {
      // TODO: handle enum default values
    });
  });

  group('Command parameters - Required/Optional + Named/Positional', () {
    final namedFunction = functions.firstWhere((e) => e.name == 'named');
    final namedParams = paramAnalyzer.fromExecutableElement(namedFunction);

    test('Named parameters', () {
      check(namedParams)
        ..has((p0) => p0.length, 'length').equals(3)
        ..every((p0) => p0.has((p0) => p0.isNamed, 'isNamed').equals(true));
    });

    test('Required + Named + No Default Value', () {
      final requiredParam = namedParams.firstWhere(
        (p) => p.name.symbol == 'requiredValue',
      );
      check(requiredParam)
        ..has((p0) => p0.isRequired, 'isRequired').equals(true)
        ..has((p0) => p0.defaultValueCode, 'defaultValueCode').isNull();
    });

    test('Optional + Named', () {
      final optionalParam = namedParams.firstWhere(
        (p) => p.name.symbol == 'optionalValue',
      );
      check(optionalParam)
        ..has((p0) => p0.isRequired, 'isRequired').equals(false)
        ..has((p0) => p0.defaultValueCode, 'defaultValueCode').isNull();
    });

    // NOTE: `package:args` throws an exception if an option is set with both
    // a) mandatory=true and b) has a default value. Therefore, we should
    // follow suit: if a parameter has a default value, mandatory should be false.
    test('Named + Default Value', () {
      final parameter = namedParams.firstWhere(
        (p) => p.name.symbol == 'defaultValue',
      );
      check(parameter)
        ..has((p0) => p0.isRequired, 'isRequired').equals(false)
        ..has((p0) => p0.defaultValueCode, 'defaultValueCode').isNotNull();
    });

    final positionalFunction =
        functions.firstWhere((e) => e.name == 'positional');
    final positionalParams =
        paramAnalyzer.fromExecutableElement(positionalFunction);

    test('Positional paramters', () {
      check(positionalParams)
        ..has((p0) => p0.length, 'length').equals(3)
        ..every((p0) {
          p0.has((p0) => p0.isNamed, 'isNamed').equals(false);
        });
    });

    test('Required + Positional', () {
      final parameter = positionalParams.firstWhere(
        (p) => p.name.symbol == 'requiredValue',
      );
      check(parameter)
        ..has((p0) => p0.isRequired, 'isRequired').equals(true)
        ..has((p0) => p0.defaultValueCode, 'defaultValueCode').isNull();
    });

    test('Optional + Positional', () {
      final parameter = positionalParams.firstWhere(
        (p) => p.name.symbol == 'optionalValue',
      );
      check(parameter)
        ..has((p0) => p0.isRequired, 'isRequired').equals(false)
        ..has((p0) => p0.defaultValueCode, 'defaultValueCode').isNull();
    });

    test('Positional + Default Value', () {
      final parameter = positionalParams.firstWhere(
        (p) => p.name.symbol == 'defaultValue',
      );
      check(parameter)
        ..has((p0) => p0.isRequired, 'isRequired').equals(false)
        ..has((p0) => p0.defaultValueCode, 'defaultValueCode').isNotNull();
    });

    // TODO: how should we handle nullable positional required parameters?
    // e.g. `value` in `void foo(String? value) {}`
  });
}
