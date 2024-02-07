import 'package:analyzer/dart/element/element.dart';

import '../code/models/command_parameter_model.dart';
import 'utils/reference_ext.dart';

class CliParameterAnalyzer {
  const CliParameterAnalyzer();

  List<CommandParameterModel> fromExecutableElement(ExecutableElement element) {
    final parameters = element.parameters;
    return parameters.map(fromParameter).toList();
  }

  CommandParameterModel fromParameter(ParameterElement element) {
    return CommandParameterModel(
      name: element.toRef(),
      type: element.type.toRef().toTypeRef(),
      isRequired: element.isRequired,
      isNamed: element.isNamed,
      defaultValueCode: element.defaultValueCode,
      docComments: element.documentationComment,
      annotations: [
        // TODO: add support for annotations
      ],
    );
  }
}
