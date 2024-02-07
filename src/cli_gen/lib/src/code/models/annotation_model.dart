import 'package:code_builder/code_builder.dart';

class AnnotationModel {
  final TypeReference type;

  final List<Code> unNamedArgs;

  final Map<String, Code> namedArgs;

  const AnnotationModel({
    required this.type,
    required this.unNamedArgs,
    required this.namedArgs,
  });
}
