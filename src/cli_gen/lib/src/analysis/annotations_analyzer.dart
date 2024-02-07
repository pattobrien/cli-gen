import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';

import '../code/models/annotation_model.dart';
import 'utils/reference_ext.dart';

class AnnotationsAnalyzer {
  const AnnotationsAnalyzer();

  AnnotationModel fromElementAnnotation(ElementAnnotation annotation) {
    final constantObject = annotation.computeConstantValue();
    if (constantObject == null) {
      throw ArgumentError(
        'Annotation is not a constant object: $annotation',
      );
    }
    // final constantReader = ConstantReader(constantObject);
    // final revivable = constantReader.revive();
    return AnnotationModel(
      type: annotation.toRef().toTypeRef(),
      unNamedArgs: [
        // TODO
      ],
      namedArgs: {
        // TODO:
      },
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
