// ignore_for_file: deprecated_member_use

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart' hide FunctionType;
import 'package:source_gen/source_gen.dart';

import '../../code/models/annotation_model.dart';
import '../parameters/default_value_code_builder.dart';
import '../utils/reference_ext.dart';

/// Converts an analyzer representation of a `cli_gen` annotation into a Model representation.
class OptionsAnnotationAnalyzer {
  const OptionsAnnotationAnalyzer();

  Iterable<AnnotationModel> annotationsForElement(Element element) {
    return element.metadata
        .where(isOptionsAnnotation)
        .map(fromElementAnnotation);
  }

  bool isOptionsAnnotation(ElementAnnotation annotation) {
    final annotationElement = annotation.computeConstantValue()?.type?.element;
    if (annotationElement is! InterfaceElement) return false;

    final isMatch = annotationElement.allSupertypes.any((e) {
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

    // final parserReader = namedArgs['parser']?.objectValue.type as FunctionType?;
    // Expression? parserRef;
    // if (parserReader != null) {
    //   final parserName = parserReader.getDisplayString(withNullability: false);
    //   final x = constantReader.revive().namedArguments['parser'];

    //   final parserSource = x!.toFunctionValue();
    //   final parserExecutableName = switch (parserSource) {
    //     MethodElement(:final name, :final enclosingElement) =>
    //       '${(enclosingElement as ClassElement).name}.$name',
    //     FunctionElement(:final name) => name,
    //     ConstructorElement(:final name, :InterfaceElement enclosingElement) =>
    //       '${enclosingElement.name}.$name',
    //     _ => throw UnimplementedError(
    //         'Unsupported parser source: $parserSource',
    //       ),
    //   };
    //   parserRef = refer(
    //       parserExecutableName, parserSource!.librarySource.uri.toString());
    //   if (!parserReader.parameters.first.type.isDartCoreString) {
    //     throw ArgumentError(
    //       'Parser $parserName must take a single String argument.',
    //     );
    //   }

    //   // TODO: check that the parser return type matches the type of the
    //   // annotated parameter / field element.
    // }

    final parserRef = buildParserExpression(
      namedArgs['parser']?.objectValue.type as FunctionType?,
      constantReader,
    );

    return AnnotationModel(
      type: annotation.toRef().toTypeRef(),
      abbr: getAbbr(namedArgs['abbr']),
      help: getHelp(namedArgs['help']),
      negatable: getNegatable(namedArgs['negatable']),
      hide: getHide(namedArgs['hide']),
      aliases: getAliases(namedArgs['aliases']),
      splitCommas: getSplitCommas(namedArgs['splitCommas']),

      // -- generic type args --
      parser: parserRef,
      defaultsTo: readDefaultToArg(constantReader),
      allowed: readAllowedArg(annotation),
      allowedHelp: readAllowedHelpArg(annotation),
    );
  }

  Expression? buildParserExpression(
    FunctionType? parserReader,
    ConstantReader annotation,
  ) {
    if (parserReader == null) return null;
    final parserName = parserReader.getDisplayString(withNullability: false);
    final x = annotation.revive().namedArguments['parser'];

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
    if (!parserReader.parameters.first.type.isDartCoreString) {
      throw ArgumentError(
        'Parser $parserName must take a single String argument.',
      );
    }
    return refer(
      parserExecutableName,
      parserSource!.librarySource.uri.toString(),
    );
  }

  String? getAbbr(ConstantReader? abbrReader) {
    if (abbrReader == null) return null;
    if (abbrReader.isNull) return null;
    return abbrReader.stringValue;
  }

  String? getHelp(ConstantReader? helpReader) {
    if (helpReader == null) return null;
    if (helpReader.isNull) return null;
    return helpReader.stringValue;
  }

  /// Parse the `negatable` argument from [negatableReader] or return `null`.
  bool? getNegatable(ConstantReader? negatableReader) {
    if (negatableReader == null) return null;
    if (negatableReader.isNull) return null;
    return negatableReader.boolValue;
  }

  /// Parse the `hide` argument from [hideReader] or return `null`.
  bool? getHide(ConstantReader? hideReader) {
    if (hideReader == null) return null;
    if (hideReader.isNull) return null;
    return hideReader.boolValue;
  }

  /// Parse the `splitCommas` argument from [splitCommasReader] or return `null`.
  bool? getSplitCommas(ConstantReader? splitCommasReader) {
    if (splitCommasReader == null) return null;
    if (splitCommasReader.isNull) return null;
    return splitCommasReader.boolValue;
  }

  /// Parse the list of aliases from [aliasesReader] or return `null`.
  List<String>? getAliases(ConstantReader? aliasesReader) {
    if (aliasesReader == null) return null;
    if (aliasesReader.isNull) return null;
    return aliasesReader.listValue.map((e) {
      return ConstantReader(e).stringValue;
    }).toList();
  }

  Map<String, String>? readAllowedHelpArg(ElementAnnotation annotation) {
    final constant = annotation.computeConstantValue()!;
    final annotationReader = ConstantReader(constant);
    final allowedHelp = annotationReader.revive().namedArguments['allowedHelp'];
    if (allowedHelp == null) return null;

    final allowedHelpReader = ConstantReader(allowedHelp);
    if (allowedHelpReader.isNull) return null;

    final valueBuilder = DefaultValueCodeBuilder();

    // method to call: valueBuilder.getSingleValueForObject(object, enumType)
    final enumType = annotation.library!.typeProvider.enumElement!.thisType;
    final allowedHelpMap = allowedHelpReader.mapValue;

    final allowedHelpValues = allowedHelpMap.map((key, value) {
      final keyString = key != null
          ? valueBuilder.getSingleValueForObject(key, enumType)
          : 'null';
      final valueString = value != null
          ? valueBuilder.getSingleValueForObject(value, enumType)
          : 'null';
      return MapEntry(keyString, valueString);
    });
    return allowedHelpValues;
  }

  /// Returns the `allowed` argument from the given [annotation] as a list of strings.
  ///
  /// The `allowed` argument is a List<T>, so this method performs some type
  /// checking and manipulation to output a supported type into a string.
  ///
  /// If the type T is not supported, an [ArgumentError] will be thrown.
  List<String>? readAllowedArg(ElementAnnotation annotation) {
    final constant = annotation.computeConstantValue()!;
    final annotationReader = ConstantReader(constant);
    final allowed = annotationReader.revive().namedArguments['allowed'];
    if (allowed == null) return null;

    final allowedReader = ConstantReader(allowed);
    if (allowedReader.isNull) return null;

    final valueBuilder = DefaultValueCodeBuilder();

    // method to call: valueBuilder.getSingleValueForObject(object, enumType)
    final enumType = annotation.library!.typeProvider.enumElement!.thisType;
    final allowedList = allowedReader.listValue;
    final allowedValues = allowedList.map((e) {
      return valueBuilder.getSingleValueForObject(e, enumType);
    }).toList();
    return allowedValues;
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
