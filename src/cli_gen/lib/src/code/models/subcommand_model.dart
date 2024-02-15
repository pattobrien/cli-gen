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
    required this.bound,
  }) : _docComments = docComments;

  final List<CommandMethodModel> commandMethods;

  /// The Command generic type bound.
  ///
  /// For example, if the user's Subcommand class extends the generated
  /// class with type `foo`, then  bound will be that type.
  ///
  /// #### Example
  /// ```dart
  /// @cliSubcommand
  /// class StashSubcommand extends _$StashSubcommand<void> {
  ///  // ...
  /// }
  /// ```
  ///
  /// In the above case, `bound` will be `void`.
  final Reference? bound;

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

  String? get category => annotations.map((e) => e.category).firstOrNull;

  @override
  final String userClassName;
}
