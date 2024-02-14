import 'package:code_builder/code_builder.dart';

import 'command_method_model.dart';
import 'mixins/generated_class_names.dart';

class SubcommandModel with GeneratedClassNames {
  const SubcommandModel({
    required this.commandMethods,
    required this.mountedSubcommands,
    required this.docComments,
    required this.userClassName,
  });

  final List<CommandMethodModel> commandMethods;

  final List<Reference> mountedSubcommands;

  final String? docComments;

  @override
  final String userClassName;
}
