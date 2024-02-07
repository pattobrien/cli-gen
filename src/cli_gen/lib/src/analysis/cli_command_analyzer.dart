import 'package:analyzer/dart/element/element.dart';

import '../code/models/command_method_model.dart';
import 'annotations_analyzer.dart';
import 'cli_parameter_analyzer.dart';
import 'utils/reference_ext.dart';

class CliCommandAnalyzer {
  const CliCommandAnalyzer();

  CommandMethodModel fromExecutableElement(
    ExecutableElement element,
  ) {
    final annotationAnalyzer = const AnnotationsAnalyzer();
    final parameterAnalyzer = const CliParameterAnalyzer();

    return CommandMethodModel(
      methodRef: element.toRef(),
      returnType: element.returnType.toRef().toTypeRef(),
      parameters: parameterAnalyzer.fromExecutableElement(element),
      docComments: element.documentationComment,
      annotations: element.metadata
          .map(annotationAnalyzer.fromElementAnnotation)
          .toList(),
    );
  }
}
