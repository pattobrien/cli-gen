import 'package:code_builder/code_builder.dart';

import 'annotation_model.dart';
import 'command_parameter_model.dart';

class CommandMethodModel {
  const CommandMethodModel({
    required this.methodRef,
    required this.docComments,
    required this.annotations,
    required this.parameters,
    required this.returnType,
  });

  final Reference methodRef;
  final String? docComments;
  final List<AnnotationModel> annotations;
  final List<CommandParameterModel> parameters;
  final TypeReference returnType;

  bool get isAsync => returnType.isAsync;
}

extension IsAsync on Reference {
  bool get isAsync => isFuture || isFutureOr;

  bool get isFuture => symbol == 'Future';

  bool get isFutureOr => symbol == 'FutureOr';
}
