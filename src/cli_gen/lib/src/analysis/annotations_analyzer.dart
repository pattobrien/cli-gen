import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart' hide FunctionType;
import 'package:source_gen/source_gen.dart';

import '../code/models/annotation_model.dart';
import 'utils/reference_ext.dart';

/// Converts an analyzer representation of a `cli_gen` annotation into a Model representation.
class AnnotationsAnalyzer {
  const AnnotationsAnalyzer();

  bool isOptionsAnnotation(ElementAnnotation annotation) {
    final annotationElement = annotation.computeConstantValue()?.type?.element;
    if (annotationElement is! InterfaceElement) return false;

    final isMatch = annotationElement.allSupertypes.any((e) {
      // ignore: deprecated_member_use
      final isNamedOption = e.name == 'BaseOption';
      final isCliAnnotationUri = e.element.library.source.uri.toString() ==
          'package:cli_annotations/src/args.dart';
      return isNamedOption && isCliAnnotationUri;
    });
    return isMatch;
  }

  AnnotationModel fromElementAnnotation(ElementAnnotation annotation) {
    final constantObject = annotation.computeConstantValue();
    if (constantObject == null) {
      throw ArgumentError(
        'Annotation is not a constant object: $annotation',
      );
    }
    final constantReader = ConstantReader(constantObject);
    final namedArgs = constantReader.revive().namedArguments.map(
          (key, value) => MapEntry(
            key,
            ConstantReader(value),
          ),
        );

    final parserReader = namedArgs['parser']?.objectValue.type as FunctionType?;
    Expression? parserRef;
    if (parserReader != null) {
      final parserName = parserReader.getDisplayString(withNullability: false);
      final x = constantReader.revive().namedArguments['parser'];

      final parserSource = x!.toFunctionValue();
      final classElement = parserSource!.enclosingElement as ClassElement;
      parserRef = refer('${classElement.name}.${parserSource.name}',
          parserSource.librarySource.uri.toString());
      if (!parserReader.parameters.first.type.isDartCoreString) {
        throw ArgumentError(
          'Parser $parserName must take a single String argument.',
        );
      }

      // TODO: check that the parser return type matches the type of the
      // annotated parameter / field element.
    }

    return AnnotationModel(
      type: annotation.toRef().toTypeRef(),
      abbr: namedArgs['abbr']?.literalValue as String?,
      help: namedArgs['help']?.literalValue as String?,
      negatable: namedArgs['negatable']?.literalValue as bool?,
      hide: namedArgs['hide']?.literalValue as bool?,
      aliases: namedArgs['aliases']?.literalValue as List<String>?,
      splitCommas: namedArgs['splitCommas']?.literalValue as bool?,

      // -- generic type args --
      parser: parserRef,
      // valueHelp: TODO
      // defaultsTo: TODO
    );
  }
}

extension ElementAnnotationExt on ElementAnnotation {
  Reference toRef() {
    return switch (element) {
      ConstructorElement(:final enclosingElement) => refer(
          enclosingElement.name,
          enclosingElement.librarySource.uri.toString(),
        ),
      _ => throw UnimplementedError(
          'Unsupported element: $element',
        ),
    };
  }
}
