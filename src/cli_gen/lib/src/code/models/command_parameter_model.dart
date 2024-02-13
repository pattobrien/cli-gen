import 'package:code_builder/code_builder.dart';

import 'annotation_model.dart';

class CommandParameterModel {
  const CommandParameterModel({
    required this.ref,
    required this.type,
    required this.isNamed,
    required this.isRequired,
    required this.optionType,
    this.docComments,
    this.defaultValueCode,
    this.computedDefaultValue,
    this.annotations = const [],
    this.availableOptions,
    required this.parser,
  });

  final OptionType optionType;
  final Reference ref;
  final Expression? parser;

  final TypeReference type;

  final bool isNamed;

  final bool isRequired;

  final String? docComments;

  // TODO: should defaultValueCode be a Code or a String?
  final String? defaultValueCode;

  final String? computedDefaultValue;

  final List<String>? availableOptions;

  final List<AnnotationModel> annotations;
}

enum OptionType {
  single,

  /// Option where user can select more than one value
  multiOption,
}
