import 'package:code_builder/code_builder.dart';

/// Representation of a `cliCommand`, `cliSubCommand` or `cliRunner` annotation.
class CommandAnnotationModel {
  final String? name;
  final String? description;
  final String? category;
  final Reference type;
  final bool displayStackTrace;

  const CommandAnnotationModel({
    required this.name,
    required this.description,
    required this.category,
    required this.type,
    required this.displayStackTrace,
  });
}
