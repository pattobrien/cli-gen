import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';

import '../code/models/annotation_model.dart';
import '../code/models/command_parameter_model.dart';
import 'options_annotation_analyzer.dart';
import 'utils/reference_ext.dart';
import 'utils/remove_doc_slashes.dart';

class CliParameterAnalyzer {
  const CliParameterAnalyzer();

  List<CommandParameterModel> fromExecutableElement(ExecutableElement element) {
    final parameters = element.parameters;
    return parameters.map(fromParameter).toList();
  }

  CommandParameterModel fromParameter(ParameterElement element) {
    final docComments = getDocComments(element);
    final cleanedUpComments = removeDocSlashes(docComments);
    final availableOptions = getImplicitAvailableOptions(element);
    final computedDefaultValue = getDefaultConstantValue(element);
    final annotations = getAnnotations(element);
    final optionType =
        isMultiOptional(element) ? OptionType.multi : OptionType.single;

    return CommandParameterModel(
      parser: getParserForParameter(element, element.type),
      ref: element.toRef(),
      type: element.type.toRef().toTypeRef(),
      isRequired: element.isRequired,
      isNamed: element.isNamed,
      optionType: optionType,
      availableOptions: availableOptions,
      computedDefaultValue: computedDefaultValue,
      docComments: cleanedUpComments,
      annotations: annotations,
    );
  }

  bool isParameterTypeAnIterable(ParameterElement element) {
    return element.type.isDartCoreIterable ||
        element.type.isDartCoreList ||
        element.type.isDartCoreSet;
  }

  List<AnnotationModel> getAnnotations(ParameterElement element) {
    const annotationAnalyzer = OptionsAnnotationAnalyzer();
    return _getAnnotationsForParameter(element)
        .where(annotationAnalyzer.isOptionsAnnotation)
        .map(annotationAnalyzer.fromElementAnnotation)
        .toList();
  }

  List<ElementAnnotation> _getAnnotationsForParameter(
    ParameterElement element,
  ) {
    switch (element) {
      case FieldFormalParameterElement(:final field):
        return [...element.metadata, ...?field?.metadata];
      case SuperFormalParameterElement(
          :ParameterElement superConstructorParameter,
        ):
        return element.metadata +
            _getAnnotationsForParameter(superConstructorParameter);
      case ParameterElement():
        return element.metadata;
    }
  }

  /// Gets a fromString parser for the given [type].
  ///
  /// The provided [element] is only used for error reporting.
  Expression? getParserForParameter(
    Element element,
    DartType type,
  ) {
    // if type is one of the following, use a built in parser:
    // - int -> int.parse
    // - double -> double.parse
    // - bool -> bool.parse
    // - String -> null
    // - Uri -> Uri.parse
    // - DateTime -> DateTime.parse
    if (type.isDartCoreInt) {
      return refer('int').property('parse');
    }
    if (type.isDartCoreDouble) {
      return refer('double').property('parse');
    }
    if (type.isDartCoreNum) {
      return refer('num').property('parse');
    }
    // ignore: deprecated_member_use
    if (type.name == 'BigInt' &&
        type.element!.librarySource!.uri.path == 'dart:core') {
      return refer('BigInt').property('parse');
    }
    if (type.isDartCoreBool) {
      // return refer('bool').property('parse');
      return null;
    }
    if (type.isDartCoreString) {
      return null;
    }

    if (type.element!.name == 'Uri' &&
        type.element!.librarySource!.uri.path == 'dart:core') {
      return refer('Uri').property('parse');
    }
    if (type.element!.name == 'DateTime' &&
        type.element!.librarySource!.uri.path == 'dart:core') {
      return refer('DateTime').property('parse');
    }

    // if the element is an enum, create a parse function inline
    // e.g. `EnumParser(MyEnum.values).parse`
    final enumType = type.element?.library?.typeProvider.enumElement!.thisType;
    if (type is InterfaceType && type.allSupertypes.contains(enumType)) {
      return refer('EnumParser').newInstance([
        refer('${type.element.name}.values'),
      ]).property('parse');
    }

    // if the element is an iterable, check if the type argument is one of the
    // above types, and use the corresponding parser + .split(',')
    final isIterable =
        type.isDartCoreIterable || type.isDartCoreList || type.isDartCoreSet;
    if (isIterable) {
      final typeArg = type as ParameterizedType;
      final argType = typeArg.typeArguments.single;
      return getParserForParameter(element, argType);
    }
    // TODO: extension type is not supported yet
    // Extension Types require the user to define a `fromString` factory
    // on the extension type (similarly to how a user-defined class would
    // be handled). This requires implementations of `cli_gen` annotations.

    // if the element is a extension type, get the extension type erasure
    // to get the underlying type, then get the corresponding parser
    // by calling `getParserForParameter` recursively.
    final isExtensionType = type.extensionTypeErasure != type;
    if (isExtensionType) {
      // final erasure = type.extensionTypeErasure;
      // return getParserForParameter(element, erasure);
      throw InvalidGenerationSource(
        'Extension types are not supported yet',
        element: element,
      );
    }

    // else, throw an error
    throw InvalidGenerationSource(
      // ignore: deprecated_member_use
      'Could not find a parser for the type: ${type.name}',
      element: element,
      todo: 'Add a parser for this type',
    );
  }

  String? getDefaultConstantValue(ParameterElement element) {
    final hasDefaultValue = element.defaultValueCode != null;
    if (!hasDefaultValue) return null;

    final constant = element.computeConstantValue();
    final reader = ConstantReader(constant);

    if (constant == null) return null;
    final thisType = reader.objectValue.type;
    if (thisType is! InterfaceType) return null; // TODO: handle this case

    final typeProvider = element.library!.typeProvider;
    final enumType = typeProvider.enumElement!.thisType;

    if (thisType.allSupertypes.contains(enumType)) {
      final value = reader.read('_name').stringValue;
      return value;
    }
    if (thisType.isDartCoreString) {
      return reader.stringValue;
    }

    if (thisType.isDartCoreInt) {
      return reader.intValue.toString();
    }
    if (thisType.isDartCoreBool) {
      return reader.boolValue.toString();
    }
    if (thisType.isDartCoreDouble) {
      return reader.doubleValue.toString();
    }
    if (thisType.isDartCoreList) {
      return reader.listValue.toString();
    }

    return null;
  }

  // String? getDefaultValueCode(ParameterElement element) {
  //   final path = element.librarySource!.uri.path;
  //   final result = element.session!.getParsedLibrary(path);
  //   if (result is! ParsedLibraryResult) return null;
  //   final parameterLocation = element.nameOffset;
  //   final visitor = ParameterNodeVisitor(element);
  //   final nodeAtOffset = result.units.single.unit.accept(visitor);

  //   return element.defaultValueCode;
  // }

  // for a parameter to be multi-optional, it must have the following properties:
  // - be a list type
  bool isMultiOptional(ParameterElement element) {
    return element.type.isDartCoreList ||
        element.type.isDartCoreSet ||
        element.type.isDartCoreIterable;
  }

  // for a parameter to have options to select from, it must:
  // - be an enum OR
  // - explicitly have a list of options in the annotations
  List<String>? getImplicitAvailableOptions(ParameterElement element) {
    return switch (element.type) {
      InterfaceType(:InterfaceElement element) => switch (element) {
          EnumElement() => () {
              final e = element;
              final values = e.fields.where((f) => f.isEnumConstant).toList();
              final names = values.map((f) => f.name).toList();
              return names;
            }(),
          _ => null,
        },
      _ => null,
    };
  }

  String? getDocComments(ParameterElement element) {
    return switch (element) {
      FieldFormalParameterElement(:final field) =>
        element.documentationComment ?? field?.documentationComment,
      SuperFormalParameterElement(
        :ParameterElement superConstructorParameter,
      ) =>
        element.documentationComment ??
            getDocComments(superConstructorParameter),
      ParameterElement() => element.documentationComment,
    };
  }
}
