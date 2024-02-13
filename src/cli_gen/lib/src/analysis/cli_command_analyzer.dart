import 'package:analyzer/dart/element/element.dart';

import '../code/models/command_method_model.dart';
import '../code/utils/remove_doc_slashes.dart';
import 'annotations_analyzer.dart';
import 'cli_parameter_analyzer.dart';
import 'utils/reference_ext.dart';

class CliCommandAnalyzer {
  const CliCommandAnalyzer();

  bool isAnnotatedWithCliCommand(MethodElement element) {
    return element.metadata.any(
      (annotation) {
        return annotation
                .computeConstantValue()!
                .type!
                .getDisplayString(withNullability: false) ==
            'CliCommand';
      },
    );
  }

  CommandMethodModel fromExecutableElement(
    ExecutableElement element,
  ) {
    const annotationAnalyzer = AnnotationsAnalyzer();
    const parameterAnalyzer = CliParameterAnalyzer();

    return CommandMethodModel(
      methodRef: element.toRef(),
      returnType: element.returnType.toRef().toTypeRef(),
      parameters: parameterAnalyzer.fromExecutableElement(element),
      docComments: removeDocSlashes(element.documentationComment),
      annotations: element.metadata
          .where(annotationAnalyzer.isOptionsAnnotation)
          .map(annotationAnalyzer.fromElementAnnotation)
          .toList(),
    );
  }
}
