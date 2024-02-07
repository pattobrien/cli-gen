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

  group('End to end parameter analyzer validation', () {
    test('e2e test', () {
      final executable = functions.first;
      final parameters = paramAnalyzer.fromExecutableElement(executable);

      check(parameters).has((p0) => p0.length, 'length').equals(1);

      final parameter = parameters.single;

      check(parameter).has((p0) => p0.ref.symbol, 'name').equals('message');

      check(parameter).has((p0) => p0.type.symbol, 'type').equals('String');
      check(parameter).has((p0) => p0.isRequired, 'isRequired').equals(true);
      check(parameter).has((p0) => p0.isNamed, 'isNamed').equals(false);
      check(parameter)
          .has((p0) => p0.defaultValueCode, 'defaultValueCode')
          .isNull();
    });
  });

  group('Command parameters - Supported primative types:', () {
    final executable = functions.firstWhere((e) => e.name == 'primativeTypes');
    final parameters = paramAnalyzer.fromExecutableElement(executable);

    test('String Literal', () {
      final param = parameters.firstWhere((p) => p.ref.symbol == 'stringValue');
      check(param.type)
        ..has((p0) => p0.symbol, 'type').equals('String')
        ..has((p0) => p0.url, 'type url').equals('dart:core');
    });
    // literal int
    test('Integer Literal', () {
      final param = parameters.firstWhere((p) => p.ref.symbol == 'intValue');
      check(param.type)
        ..has((p0) => p0.symbol, 'type').equals('int')
        ..has((p0) => p0.url, 'type url').equals('dart:core');
    });
    // literal boolean

    test('Boolean Literal', () {
      final param = parameters.firstWhere((p) => p.ref.symbol == 'boolValue');
      check(param.type)
        ..has((p0) => p0.symbol, 'type').equals('bool')
        ..has((p0) => p0.url, 'type url').equals('dart:core');
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
    final executable = functions.firstWhere((e) => e.name == 'userTypes');
    final parameters = paramAnalyzer.fromExecutableElement(executable);
    // TODO: define scope
    // SEE: @FromString annotation

    test('Implicit available options from Enum constants', () {
      final param = parameters.firstWhere((p) => p.ref.symbol == 'enumValue');
      check(param.availableOptions)
          .isNotNull()
          .unorderedEquals(['value1', 'value2']);
    });

    // user-defined extension type (of a primative)
    // user-defined interface type
  });

  group('Command parameters - Annotations', () {
    // TODO: handle configuring the parser with annotations (e.g. @Option)
  });

  group('Command parameters - Multi-select', () {
    // TODO
  });

  group('Command parameters - Doc comments:', () {
    /// NOTE: doc comments currently don't work with parameters at all. However,
    /// on class/constructor-based commands (see [DocComments] class in args_example),
    /// doc comments are pulled from the field element that the parameter
    /// represents. i.e. doc comments only work with Constructor fields.

    // TODO: without doc comment
    // TODO: with doc comment + functions/methods
    // TODO: doc comment using annotations

    test('Constructors', () {
      final classes = unit.unit.declaredElement!.classes;
      final classElement = classes.firstWhere((e) => e.name == 'DocComments');
      final constructor = classElement.constructors.first;
      final parameters = paramAnalyzer.fromExecutableElement(constructor);

      check(parameters.single.docComments).equals('The message to display.');
    });
  });

  group('Command parameters - Default values:', () {
    final executable = functions.firstWhere((e) => e.name == 'defaultValues');
    final parameters = paramAnalyzer.fromExecutableElement(executable);

    test('String', () {
      final param = parameters.firstWhere((p) => p.ref.symbol == 'stringVal');
      check(param.defaultValueCode).equals("'default'");
    });

    test('Boolean', () {
      final param = parameters.firstWhere((p) => p.ref.symbol == 'booleanVal');
      check(param.defaultValueCode).equals('true');
    });

    test('Integer', () {
      final param = parameters.firstWhere((p) => p.ref.symbol == 'integerVal');
      check(param.defaultValueCode).equals('42');
    });

    test('Enum', () {
      // TODO: handle enum default values
    });
  });

  group('Command parameters - Named parameters:', () {
    final namedFunction = functions.firstWhere((e) => e.name == 'named');
    final namedParams = paramAnalyzer.fromExecutableElement(namedFunction);

    test('All 3 parameters are named', () {
      check(namedParams)
        ..has((p0) => p0.length, 'length').equals(3)
        ..every((p0) => p0.has((p0) => p0.isNamed, 'isNamed').equals(true));
    });

    test('Required + No Default Value', () {
      final param = namedParams.firstWhere((p) => p.ref.symbol == 'reqValue');
      check(param)
        ..has((p0) => p0.isRequired, 'isRequired').equals(true)
        ..has((p0) => p0.defaultValueCode, 'defaultValueCode').isNull();
    });

    test('Nullable + No Default Value', () {
      final param = namedParams.firstWhere((p) => p.ref.symbol == 'optValue');
      check(param)
        ..has((p0) => p0.isRequired, 'isRequired').equals(false)
        ..has((p0) => p0.defaultValueCode, 'defaultValueCode').isNull();
    });

    // NOTE: `package:args` throws an exception if an option is set with both
    // a) mandatory=true and b) has a default value. Therefore, we should
    // follow suit: if a parameter has a default value, mandatory should be false.
    test('Non-Nullable + Default Value', () {
      final param = namedParams.firstWhere((p) => p.ref.symbol == 'defValue');
      check(param)
        ..has((p0) => p0.isRequired, 'isRequired').equals(false)
        ..has((p0) => p0.defaultValueCode, 'defaultValueCode').isNotNull();
    });
  });
  group('Command parameters - Positional parameters:', () {
    final positionalFunc = functions.firstWhere((e) => e.name == 'positional');
    final parameters = paramAnalyzer.fromExecutableElement(positionalFunc);

    test('All 3 parameters are positional', () {
      check(parameters)
        ..has((p0) => p0.length, 'length').equals(3)
        ..every((p0) => p0.has((p0) => p0.isNamed, 'isNamed').equals(false));
    });

    test('Required + Positional', () {
      final param = parameters.firstWhere((p) => p.ref.symbol == 'reqValue');
      check(param)
        ..has((p0) => p0.isRequired, 'isRequired').equals(true)
        ..has((p0) => p0.defaultValueCode, 'defaultValueCode').isNull();
    });

    test('Optional + Positional', () {
      final param = parameters.firstWhere((p) => p.ref.symbol == 'optValue');
      check(param)
        ..has((p0) => p0.isRequired, 'isRequired').equals(false)
        ..has((p0) => p0.defaultValueCode, 'defaultValueCode').isNull();
    });

    test('Positional + Default Value', () {
      final param = parameters.firstWhere((p) => p.ref.symbol == 'defValue');
      check(param)
        ..has((p0) => p0.isRequired, 'isRequired').equals(false)
        ..has((p0) => p0.defaultValueCode, 'defaultValueCode').isNotNull();
    });

    // TODO: how should we handle nullable positional required parameters?
    // e.g. `value` in `void foo(String? value) {}`
  });
}
