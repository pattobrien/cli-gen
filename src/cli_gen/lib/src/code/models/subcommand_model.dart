import 'command_method_model.dart';

class SubcommandModel {
  final List<CommandMethodModel> subcommands;
  final String? docComments;
  final String name;

  const SubcommandModel({
    required this.subcommands,
    required this.docComments,
    required this.name,
  });
}
