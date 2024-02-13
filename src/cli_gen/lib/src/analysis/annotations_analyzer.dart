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
      final parserExecutableName = switch (parserSource) {
        MethodElement(:final name, :final enclosingElement) =>
          '${(enclosingElement as ClassElement).name}.$name',
        FunctionElement(:final name) => name,
        ConstructorElement(:final name, :InterfaceElement enclosingElement) =>
          '${enclosingElement.name}.$name',
        _ => throw UnimplementedError(
            'Unsupported parser source: $parserSource',
          ),
      };
      parserRef = refer(
          parserExecutableName, parserSource!.librarySource.uri.toString());
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
      defaultsTo: readDefaultToArg(constantReader),
    );
  }

  Expression? readDefaultToArg(ConstantReader annotation) {
    final defaultsTo = annotation.revive().namedArguments['defaultsTo'];
    if (defaultsTo == null) return null;

    switch (annotation.objectValue.type) {
      case InterfaceType(:final name) when name == 'Option':
        final literalValue = ConstantReader(defaultsTo).literalValue;
        if (literalValue is String) return literal(literalValue);
        if (literalValue is! String) {
          final value = literalValue.toString();
          final expValue = literalString(value.toString());
          return expValue;
        }
        throw ArgumentError(
          'Unsupported defaultsTo type: ${literalValue.runtimeType}',
        );

      case InterfaceType(:final name) when name == 'MultiOption':
        return literalList(
          defaultsTo.toListValue()!.map((e) => literal("'${e.toString()}'")),
        );
      case InterfaceType(:final name) when name == 'Flag':
        return literalBool(defaultsTo.toBoolValue()!);
      default:
        throw ArgumentError(
          'Unsupported annotation type: ${annotation.objectValue.type}',
        );
    }
  }
}

extension ElementAnnotationExt on ElementAnnotation {
  Reference toRef() {
    return switch (element) {
      ConstructorElement(:final enclosingElement) => refer(
          enclosingElement.name,
          enclosingElement.librarySource.uri.toString(),
        ),
      PropertyAccessorElement(:final name, :final librarySource) => refer(
          name,
          librarySource.uri.toString(),
        ),
      VariableElement(:final librarySource, :final name) => refer(
          name,
          librarySource!.uri.toString(),
        ),
      _ => throw UnimplementedError(
          'Unsupported element: $element',
        ),
    };
  }
}
