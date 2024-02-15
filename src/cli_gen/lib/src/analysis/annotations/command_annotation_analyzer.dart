import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../../code/models/command_annotation_model.dart';
import '../utils/reference_ext.dart';

/// Converts an analyzed representation of a `cliCommand`, `cliSubCommand` or
/// `cliRunner` annotation into its actual representation.
///
/// See [CommandAnnotationModel] and [annotationsForElement] for details.
class CommandAnnotationAnalyzer {
  const CommandAnnotationAnalyzer();

  bool hasCommandAnnotation(Element element) {
    return element.metadata.any(
      (annotation) {
        final annotationType = annotation.computeConstantValue()!.type!;
        final possibleNames = ['CliCommand', 'CliSubcommand', 'CliRunner'];
        return possibleNames.contains(annotationType.name);
      },
    );
  }

  bool isCommandAnnotation(ElementAnnotation elementAnnotation) {
    final annotationType = elementAnnotation.computeConstantValue()!.type!;
    final possibleNames = ['CliCommand', 'CliSubcommand', 'CliRunner'];
    return possibleNames.contains(annotationType.name);
  }

  List<CommandAnnotationModel> annotationsForElement(Element element) {
    return element.metadata.where(isCommandAnnotation).map((annotation) {
      final constant = annotation.computeConstantValue();
      if (constant == null) {
        throw InvalidGenerationSource(
          'The annotation must be a constant expression for `cli-gen` to work.',
          element: annotation.element,
        );
      }

      final reader = ConstantReader(constant);
      final objectType = reader.objectValue.type!;

      return CommandAnnotationModel(
        name: reader.peek('name')?.stringValue,
        description: reader.peek('description')?.stringValue,
        category: reader.peek('category')?.stringValue,
        type: objectType.toRef(),
        displayStackTrace: reader.peek('displayStackTrace')?.boolValue ?? false,
      );
    }).toList();
  }
}
