import 'package:code_builder/code_builder.dart';

import 'command_method_model.dart';

class SubcommandModel {
  final List<CommandMethodModel> subcommands;
  final List<Reference> mountedSubcommands;
  final String? docComments;
  final String name;

  const SubcommandModel({
    required this.subcommands,
    required this.mountedSubcommands,
    required this.docComments,
    required this.name,
  });
}
