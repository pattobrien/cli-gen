import 'package:analyzer/dart/element/element.dart';

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
    return CommandParameterModel(
      name: element.toRef(),
      type: element.type.toRef().toTypeRef(),
      isRequired: element.isRequired,
      isNamed: element.isNamed,
      defaultValueCode: element.defaultValueCode,
      docComments: cleanedUpComments,
      annotations: [
        // TODO: add support for annotations
      ],
    );
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
