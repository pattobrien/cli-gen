import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import '../../code/models/annotation_model.dart';
import '../../code/models/command_parameter_model.dart';
import '../annotations/options_annotation_analyzer.dart';
import '../utils/reference_ext.dart';
import '../utils/remove_doc_slashes.dart';
import 'default_value_code_builder.dart';
import 'type_parser_expression_builder.dart';

class CliParameterAnalyzer {
  const CliParameterAnalyzer();

  /// Extracts the [CommandParameterModel] from the given Executable [element].
  List<CommandParameterModel> fromExecutableElement(
    ExecutableElement element,
  ) =>
      element.parameters.map(fromParameter).toList();

  CommandParameterModel fromParameter(ParameterElement element) {
    final docComments = getDocComments(element);
    final cleanedUpComments = removeDocSlashes(docComments);
    final availableOptions = getImplicitAvailableOptions(element);
    final annotations = getAnnotations(element);
    final optionType =
        isMultiOptional(element) ? OptionType.multi : OptionType.single;

    final defaultValBuilder = DefaultValueCodeBuilder();
    final parserBuilder = TypeParserExpressionBuilder();

    return CommandParameterModel(
      name: element.toRef(),
      type: element.type.toRef().toTypeRef(),
      isRequired: element.isRequired,
      isNamed: element.isNamed,
      optionType: optionType,
      availableOptions: availableOptions,
      parser: parserBuilder.getParserForParameter(element, element.type),
      computedDefaultValue: defaultValBuilder.getDefaultConstantValue(element),
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

  /// If a parmeter type is a Collection type, it is considered multi-optional.
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
      InterfaceType(element: EnumElement(:final fields)) => () {
          final values = fields.where((f) => f.isEnumConstant).toList();
          return values.map((f) => f.name).toList();
        }(),
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
