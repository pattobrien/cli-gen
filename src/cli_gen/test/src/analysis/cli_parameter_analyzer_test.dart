import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:checks/checks.dart';
import 'package:cli_gen/src/analysis/parameters/cli_parameter_analyzer.dart';
import 'package:cli_gen/src/code/models/command_parameter_model.dart';
import 'package:code_builder/code_builder.dart';
import 'package:code_builder/src/specs/expression.dart';
import 'package:test/test.dart';

void main() async {
  final root = Directory.current;
  final testFilePath = '${root.path}/test/example_usage/args_example.dart';
  final unit = await resolveFile2(path: testFilePath);
  if (unit is! ResolvedUnitResult) {
    throw Exception('Failed to resolve unit');
  }

  final functions = unit.unit.declaredElement!.functions;

  final paramAnalyzer = CliParameterAnalyzer();

  /// Tests the extraction of relevant information from the Dart Analyzer Element
  /// models into a [CommandParameterModel].
  group('Command Parameters (Analyzer Elements -> Models) -', () {
    group('End to end parameter analyzer validation', () {
      test('e2e test', () {
        final executable = functions.first;
        final parameters = paramAnalyzer.fromExecutableElement(executable);

        check(parameters).has((p0) => p0.length, 'length').equals(1);

        final parameter = parameters.single;

        check(parameter).has((p0) => p0.name.symbol, 'name').equals('message');

        check(parameter).has((p0) => p0.type.symbol, 'type').equals('String');
        check(parameter).has((p0) => p0.isRequired, 'isRequired').equals(true);
        check(parameter).has((p0) => p0.isNamed, 'isNamed').equals(false);
        // check(parameter)
        //     .has((p0) => p0.defaultValueCode, 'defaultValueCode')
        //     .isNull();
      });
    });

    /// Tests if the model is populated with the correct type name and `dart:core`
    /// as the type URI.
    group('Types (Primatives):', () {
      final executable =
          functions.firstWhere((e) => e.name == 'primativeTypes');
      final parameters = paramAnalyzer.fromExecutableElement(executable);

      test('String Literal', () {
        final param =
            parameters.firstWhere((p) => p.name.symbol == 'stringValue');
        check(param.type)
          ..has((p0) => p0.symbol, 'type').equals('String')
          ..has((p0) => p0.url, 'type url').equals('dart:core');
      });

      test('Integer Literal', () {
        final param = parameters.firstWhere((p) => p.name.symbol == 'intValue');
        check(param.type)
          ..has((p0) => p0.symbol, 'type').equals('int')
          ..has((p0) => p0.url, 'type url').equals('dart:core');
      });

      test('Boolean Literal', () {
        final param =
            parameters.firstWhere((p) => p.name.symbol == 'boolValue');
        check(param.type)
          ..has((p0) => p0.symbol, 'type').equals('bool')
          ..has((p0) => p0.url, 'type url').equals('dart:core');
      });
    });

    group('Types (User-defined):', () {
      final executable = functions.firstWhere((e) => e.name == 'userTypes');
      final parameters = paramAnalyzer.fromExecutableElement(executable);

      test('Implicit available options from Enum constants', () {
        final param =
            parameters.firstWhere((p) => p.name.symbol == 'enumValue');
        check(param.availableOptions)
            .isNotNull()
            .unorderedEquals(['value1', 'value2']);
      });

      test('Enum default', () {
        final param =
            parameters.firstWhere((p) => p.name.symbol == 'enumValue2');
        check(param.computedDefault?.code.toString())
            .isNotNull()
            .equals("'value1'");
      });

      // test('Extension type default', () {
      //   final param = parameters.firstWhere((p) => p.ref.symbol == 'emailValue2');
      //   check(param.computedDefaultValue).isNotNull().equals('foo');
      // });

      test('Constant variable default', () {
        final param = parameters.firstWhere((p) => p.name.symbol == 'constVar');
        check(param.computedDefault?.code.toString())
            .isNotNull()
            .equals("'42'");
      });
    });

    group('Complex class types', () {
      // TODO: user-defined classes
    });

    group('Annotations', () {
      // TODO: handle configuring the parser with annotations (e.g. @Option)

      final executable =
          functions.firstWhere((e) => e.name == 'annotatedParams');
      final parameters = paramAnalyzer.fromExecutableElement(executable);

      // print('params: $parameters');
      test(
          'ParameterElement properties are overridden by annotation properties',
          () {
        final param =
            parameters.firstWhere((p) => p.name.symbol == 'numericValue');
        check(param)
          ..hasDefaultValueOf(123)
          ..has((p0) => p0.docComments, 'doc comments')
              .equals('Annotation comment.')
          ..has((p0) => p0.parser, 'parser')
              .isA<Reference>()
              .has((p0) => p0.symbol, 'symbol name')
              .equals('myCustomParser');
      });
    });

    group('Multi-select (from Iterables):', () {
      final executable = functions.firstWhere((e) => e.name == 'multiSelect');
      final parameters = paramAnalyzer.fromExecutableElement(executable);

      test('List<String> supports multiple values', () {
        final param =
            parameters.firstWhere((p) => p.name.symbol == 'multiString');
        check(param.optionType).equals(OptionType.multi);
      });

      test('Set<int> supports multiple values', () {
        final param = parameters.firstWhere((p) => p.name.symbol == 'multiInt');
        check(param.optionType).equals(OptionType.multi);
      });

      test('Iterable<String> supports multiple values', () {
        final param =
            parameters.firstWhere((p) => p.name.symbol == 'multiEnum');
        check(param.optionType).equals(OptionType.multi);
      });
    });

    group('Doc comments:', () {
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

    group('Default values:', () {
      final executable = functions.firstWhere((e) => e.name == 'defaultValues');
      final parameters = paramAnalyzer.fromExecutableElement(executable);

      test('String', () {
        final param =
            parameters.firstWhere((p) => p.name.symbol == 'stringVal');
        check(param).hasDefaultValueOf('default');
      });

      test('Boolean', () {
        final param =
            parameters.firstWhere((p) => p.name.symbol == 'booleanVal');
        check(param).hasDefaultBooleanValueOf(true);
      });

      test('Integer', () {
        final param =
            parameters.firstWhere((p) => p.name.symbol == 'integerVal');
        check(param).hasDefaultValueOf(42);
      });

      test('List<String>', () {
        final param = parameters.firstWhere((p) => p.name.symbol == 'listVal');
        check(param).hasDefaultListValueOf(['a', 'b', 'c']);
      });

      test('Set<int>', () {
        final param = parameters.firstWhere((p) => p.name.symbol == 'setVal');
        check(param).hasDefaultListValueOf(const ['1', '2', '3']);
      });
    });

    group('Named parameters:', () {
      final namedFunction = functions.firstWhere((e) => e.name == 'named');
      final namedParams = paramAnalyzer.fromExecutableElement(namedFunction);

      test('All 3 parameters are named', () {
        check(namedParams)
          ..has((p0) => p0.length, 'length').equals(3)
          ..every((p0) => p0.has((p0) => p0.isNamed, 'isNamed').equals(true));
      });

      test('Required + No Default Value', () {
        // final param = namedParams.firstWhere((p) => p.ref.symbol == 'reqValue');
        // check(param)
        //   ..has((p0) => p0.isRequired, 'isRequired').equals(true)
        //   ..has((p0) => p0.defaultValueCode, 'defaultValueCode').isNull();
      });

      test('Nullable + No Default Value', () {
        // final param = namedParams.firstWhere((p) => p.ref.symbol == 'optValue');
        // check(param)
        //   ..has((p0) => p0.isRequired, 'isRequired').equals(false)
        //   ..has((p0) => p0.defaultValueCode, 'defaultValueCode').isNull();
      });

      // NOTE: `package:args` throws an exception if an option is set with both
      // a) mandatory=true and b) has a default value. Therefore, we should
      // follow suit: if a parameter has a default value, mandatory should be false.
      test('Non-Nullable + Default Value', () {
        // final param = namedParams.firstWhere((p) => p.ref.symbol == 'defValue');
        // check(param)
        //   ..has((p0) => p0.isRequired, 'isRequired').equals(false)
        //   ..has((p0) => p0.defaultValueCode, 'defaultValueCode').isNotNull();
      });
    });
    group('Positional parameters:', () {
      final positionalFunc =
          functions.firstWhere((e) => e.name == 'positional');
      final parameters = paramAnalyzer.fromExecutableElement(positionalFunc);

      test('All 3 parameters are positional', () {
        check(parameters)
          ..has((p0) => p0.length, 'length').equals(3)
          ..every((p0) => p0.has((p0) => p0.isNamed, 'isNamed').equals(false));
      });

      test('Required + Positional', () {
        // final param = parameters.firstWhere((p) => p.ref.symbol == 'reqValue');
        // check(param)
        //   ..has((p0) => p0.isRequired, 'isRequired').equals(true)
        //   ..has((p0) => p0.defaultValueCode, 'defaultValueCode').isNull();
      });

      test('Optional + Positional', () {
        // final param = parameters.firstWhere((p) => p.ref.symbol == 'optValue');
        // check(param)
        //   ..has((p0) => p0.isRequired, 'isRequired').equals(false)
        //   ..has((p0) => p0.defaultValueCode, 'defaultValueCode').isNull();
      });

      test('Positional + Default Value', () {
        // final param = parameters.firstWhere((p) => p.ref.symbol == 'defValue');
        // check(param)
        //   ..has((p0) => p0.isRequired, 'isRequired').equals(false)
        //   ..has((p0) => p0.defaultValueCode, 'defaultValueCode').isNotNull();
      });

      // TODO: how should we handle nullable positional required parameters?
      // e.g. `value` in `void foo(String? value) {}`
    });
  });
}

extension CommandParameterModelCheckExt on Subject<CommandParameterModel> {
  void hasDefaultValueOf(Object? value) {
    has((p0) => p0.computedDefault, 'computedDefaultValue')
        .isA<LiteralExpression>()
        .has((p0) => p0.literal, 'literal value')
        .equals((literalString(value.toString()) as LiteralExpression).literal);
  }

  void hasDefaultListValueOf(List<Object> value) {
    has((p0) => p0.computedDefault, 'computedDefaultValue')
        .isA<LiteralListExpression>()
        .has((p0) => p0.values, 'values')
        .unorderedEquals(value);
  }

  void hasDefaultSetValueOf(Set<Object> value) {
    has((p0) => p0.computedDefault, 'computedDefaultValue')
        .isA<LiteralSetExpression>()
        .has((p0) => p0.values, 'elements')
        .unorderedEquals(value);
  }

  void hasDefaultBooleanValueOf(bool value) {
    has((p0) => p0.computedDefault, 'computedDefaultValue')
        .isA<LiteralExpression>()
        .has((p0) => p0.literal, 'literal value')
        .equals((literalBool(value) as LiteralExpression).literal);
  }
}
