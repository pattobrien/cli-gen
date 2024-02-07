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

  final executable = unit.unit.declaredElement!.functions.single;

  final paramAnalyzer = CliParameterAnalyzer();

  test('End to end parameter analyzer validation', () async {
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

    // TODO: handle docComments (waiting for response from Dart team on
    // how doc comments will be handled with macros)
    // check(parameter)
    //     .has((p0) => p0.docComments, 'docComments')
    //     .equals('The message to display.');
    // check(parameter).has((p0) => p0.annotations, 'annotations').isEmpty();
  });
}
