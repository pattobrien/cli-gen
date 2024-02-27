import 'package:analyzer/dart/element/element.dart';

import '../../code/models/command_method_model.dart';
import '../annotations/command_annotation_analyzer.dart';
import '../annotations/options_annotation_analyzer.dart';
import '../parameters/cli_parameter_analyzer.dart';
import '../utils/reference_ext.dart';
import '../utils/remove_doc_slashes.dart';

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
        final mountTypes = ['SubcommandMount', 'CliMount'];
        // ignore: deprecated_member_use
        return mountTypes.contains(annotationType.name);
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
    const annotationAnalyzer = CommandAnnotationAnalyzer();
    const parameterAnalyzer = CliParameterAnalyzer();
    final returnType = element.returnType.toTypeRef();
    return CommandMethodModel(
      methodRef: element.toRef(),
      returnType: returnType,
      parameters:
          element.parameters.map(parameterAnalyzer.fromParameter).toList(),
      docComments: removeDocSlashes(element.documentationComment),
      annotations: annotationAnalyzer.annotationsForElement(element),
    );
  }
}
