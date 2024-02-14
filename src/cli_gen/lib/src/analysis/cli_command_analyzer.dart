import 'package:analyzer/dart/element/element.dart';

import '../code/models/command_method_model.dart';
import 'cli_parameter_analyzer.dart';
import 'options_annotation_analyzer.dart';
import 'utils/reference_ext.dart';
import 'utils/remove_doc_slashes.dart';

/// Extacts information from any executable element and creates a [CommandMethodModel].
///
/// see [CommandMethodModel] and [fromExecutableElement].
class CliCommandAnalyzer {
  const CliCommandAnalyzer();

  /// Checks if the given [element] is annotated with `@CliCommand`.
  bool isAnnotatedWithCliCommand(
    ExecutableElement element,
  ) {
    return element.metadata.any(
      (annotation) {
        final annotationType = annotation.computeConstantValue()!.type!;
        // ignore: deprecated_member_use
        return annotationType.name == 'CliCommand';
      },
    );
  }

  /// Checks if the given [element] is annotated with `@SubcommandMount`.
  bool isAnnotatedWithSubcommandMount(
    ExecutableElement element,
  ) {
    return element.metadata.any(
      (annotation) {
        final annotationType = annotation.computeConstantValue()!.type!;
        // ignore: deprecated_member_use
        return annotationType.name == 'SubcommandMount';
      },
    );
  }

  /// Extracts the [CommandMethodModel] from the given [element].
  ///
  /// For the most part, this method delegates most of the work to
  /// [CliParameterAnalyzer] and [OptionsAnnotationAnalyzer], which extract
  /// the parameters and annotations, respectively.
  CommandMethodModel fromExecutableElement(
    ExecutableElement element,
  ) {
    const annotationAnalyzer = OptionsAnnotationAnalyzer();
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
