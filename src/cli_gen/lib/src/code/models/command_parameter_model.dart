import 'package:code_builder/code_builder.dart';

import 'annotation_model.dart';

class CommandParameterModel {
  const CommandParameterModel({
    required this.name,
    required this.type,
    required this.isNamed,
    required this.isRequired,
    this.docComments,
    this.defaultValueCode,
    this.annotations = const [],
  });

  final Reference name;

  final TypeReference type;

  final bool isNamed;

  final bool isRequired;

  final String? docComments;

  // TODO: should defaultValueCode be a Code or a String?
  final String? defaultValueCode;

  final List<AnnotationModel> annotations;
}
