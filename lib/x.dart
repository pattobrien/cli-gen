import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';

import 'value.dart';

Future<void> main() async {
  final thisPath = '${Directory.current.path}/lib/value.dart';
  final collection = AnalysisContextCollection(includedPaths: [
    thisPath,
  ]);

  final session = collection.contextFor(thisPath).currentSession;
  final unit = await session.getResolvedUnit(thisPath);
  if (unit is! ResolvedUnitResult) {
    throw Exception('Could not resolve unit');
  }
  final func = unit.unit.declaredElement!.functions[1];
  final firstParam = func.parameters.first;
  final docComments = getDocComments(firstParam);
  final value = getDefaultStringValue(firstParam);
  print('Doc comments: ');
}

String? getDocComments(ParameterElement element) {
  return element.documentationComment;
}

String? getDefaultStringValue(ParameterElement element) {
  return element.computeConstantValue()?.toStringValue();
}

void user() {
  someFunction2();
}

// notes:
// - here, private variables and parameters can be introspected and have their
//   values computed