import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:checks/checks.dart';
import 'package:cli_gen/src/analysis/annotations_analyzer.dart';
import 'package:code_builder/code_builder.dart';
import 'package:test/test.dart';

void main() async {
  final exampleProjectPath = 'test/example_project/lib/example_project.dart';
  final thisDir = Directory.current.path;
  final fullPath = '$thisDir/$exampleProjectPath';
  final collection = AnalysisContextCollection(includedPaths: [fullPath]);
  final context = collection.contextFor(fullPath);
  final result = await context.currentSession.getResolvedUnit(fullPath);
  if (result is! ResolvedUnitResult) {
    throw Exception('Failed to resolve unit');
  }
  final firstFunction =
      result.libraryElement.definingCompilationUnit.functions.first;
  final parameters = firstFunction.parameters;
  final singleParam = parameters.first;

  final annotationAnalyzer = AnnotationsAnalyzer();
  final annotationModel = annotationAnalyzer.fromElementAnnotation(
    singleParam.metadata.first,
  );

  group('@Options() Annotations (DartObject -> Model) -', () {
    test('Parser Expression', () {
      check(annotationModel)
          .has((p0) => p0.parser, 'parser expression')
          .equals(refer('int.parse', 'dart:core'));
    });
  });
}
