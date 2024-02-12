import 'package:code_builder/code_builder.dart';

class AnnotationModel {
  final TypeReference type;

  final List<Object> unNamedArgs;

  final Map<String, Object> namedArgs;

  const AnnotationModel({
    required this.type,
    required this.unNamedArgs,
    required this.namedArgs,
  });

  bool get isOptionType => type.symbol == 'Option';

  bool get isFlagType => type.symbol == 'Flag';

  bool get isCommandType => type.symbol == 'CliCommand';
}
