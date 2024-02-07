import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import '../code/models/command_parameter_model.dart';
import '../code/utils/remove_doc_slashes.dart';
import 'utils/reference_ext.dart';

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
    return CommandParameterModel(
      ref: element.toRef(),
      type: element.type.toRef().toTypeRef(),
      isRequired: element.isRequired,
      isNamed: element.isNamed,
      optionType:
          isMultiOptional(element) ? OptionType.multiOption : OptionType.single,
      availableOptions: availableOptions,
      defaultValueCode: element.defaultValueCode,
      docComments: cleanedUpComments,
      annotations: [
        // TODO: add support for annotations
      ],
    );
  }

  // for a parameter to be multi-optional, it must have the following properties:
  // - be a list type
  bool isMultiOptional(ParameterElement element) {
    return element.type.isDartCoreList;
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
