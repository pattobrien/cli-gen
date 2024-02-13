import 'package:code_builder/code_builder.dart';

import 'command_method_model.dart';

class RunnerModel {
  final List<CommandMethodModel> subcommands;
  final String? docComments;
  final String name;
  final List<Reference> mountedSubcommands;

  const RunnerModel({
    required this.mountedSubcommands,
    required this.subcommands,
    required this.docComments,
    required this.name,
  });
}
