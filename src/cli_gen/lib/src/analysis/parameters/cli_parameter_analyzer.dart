import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import '../../code/models/command_parameter_model.dart';
import '../../code/models/option_annotation_model.dart';
import '../annotations/options_annotation_analyzer.dart';
import '../utils/reference_ext.dart';
import '../utils/remove_doc_slashes.dart';
import 'default_value_code_builder.dart';
import 'type_parser_expression_builder.dart';

class CliParameterAnalyzer {
  const CliParameterAnalyzer();

  /// Extracts [CommandParameterModel]s from the parameters on the
  /// given Executable [element].
  ///
  /// Note: This method supports Constructors, Methods, and Functions.
  List<CommandParameterModel> fromExecutableElement(
    ExecutableElement element,
  ) =>
      element.parameters.map(fromParameter).toList();

  /// Extracts [CommandParameterModel] information from a single parameter.
  CommandParameterModel fromParameter(ParameterElement element) {
    final docComments = getDocComments(element);
    final cleanedUpComments = removeDocSlashes(docComments);
    final availableOptions = getImplicitAvailableOptions(element);
    final annotations = getAnnotations(element);
    final optionType = isImplicitlyMultiOptional(element)
        ? OptionType.multi
        : OptionType.single;

    final defaultValBuilder = DefaultValueCodeBuilder();
    final parserBuilder = TypeParserExpressionBuilder();
    final type = element.type.toTypeRef();
    return CommandParameterModel(
      name: element.toRef(),
      type: type,
      isRequired: element.isRequired,
      isNamed: element.isNamed,
      optionType: optionType,
      allowedOptions: availableOptions,
      defaultValueAsCode: defaultValBuilder.getDefaultValueAsCode(element),
      parser: parserBuilder.getParserForParameter(element, element.type),
      computedDefaultValue: defaultValBuilder.getDefaultConstantValue(element),
      docComments: cleanedUpComments,
      annotations: annotations,
    );
  }

  /// Whether the type of the [element] can be inferred as accepting multiple options.
  ///
  /// If a parmeter type is a Collection type, it is considered multi-optional.
  bool isImplicitlyMultiOptional(ParameterElement element) {
    return isCollectionType(element);
  }

  bool isCollectionType(ParameterElement element) {
    return element.type.isDartCoreIterable ||
        element.type.isDartCoreList ||
        element.type.isDartCoreSet;
  }

  /// Returns a list of annotations for the given [element].
  List<OptionAnnotationModel> getAnnotations(ParameterElement element) {
    const annotationAnalyzer = OptionsAnnotationAnalyzer();
    return _getAnnotationsForParameter(element)
        .where(annotationAnalyzer.isOptionsAnnotation)
        .map(annotationAnalyzer.fromElementAnnotation)
        .toList();
  }

  /// Recursively calls itself to get all annotations for the parameter and the
  /// field/parameter it references (if [element] is a field or super parameter).
  List<ElementAnnotation> _getAnnotationsForParameter(
    ParameterElement element,
  ) {
    return switch (element) {
      FieldFormalParameterElement(:FieldElement? field) =>
        element.metadata + (field?.metadata ?? []),
      SuperFormalParameterElement(
        :ParameterElement superConstructorParameter,
      ) =>
        element.metadata +
            _getAnnotationsForParameter(superConstructorParameter),
      ParameterElement() => element.metadata,
    };
  }

  /// Returns a list of options to select from, if the [element] is an Enum type.
  ///
  /// Enums are the only Dart types that implicitly have a finite set of options.
  /// Potential other types would be: a range of numbers, or a list of strings. But
  /// these would be more difficult to infer from the type alone, and therefore
  /// they would always need to be explicitly defined by the user.
  List<String>? getImplicitAvailableOptions(ParameterElement element) {
    return switch (element.type) {
      InterfaceType(element: EnumElement(:final fields)) => () {
          final values = fields.where((f) => f.isEnumConstant).toList();
          return values.map((f) => f.name).toList();
        }(),
      _ => null,
    };
  }

  /// Returns a doc comment depending on the type of parameter.
  ///
  /// The type is relevant because, for example, field-referencing parameters
  /// will check the field for a doc comment in case the parameter itself doesn't
  /// have one.
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
