import 'package:code_builder/code_builder.dart';

import 'command_annotation_model.dart';
import 'command_method_model.dart';
import 'mixins/generated_class_names.dart';

class SubcommandModel with GeneratedClassNames {
  const SubcommandModel({
    required this.commandMethods,
    required this.mountedSubcommands,
    required String? docComments,
    required this.userClassName,
    required this.annotations,
  }) : _docComments = docComments;

  final List<CommandMethodModel> commandMethods;

  @override
  final List<CommandAnnotationModel> annotations;

  final List<Reference> mountedSubcommands;

  final String? _docComments;

  /// The description of [this].
  ///
  /// If a description is not provided via an annotation, the doc comments of the
  /// method will be used.
  String? get docComments =>
      annotations.map((e) => e.description).firstOrNull ?? _docComments;

  @override
  final String userClassName;
}
