import 'package:meta/meta_meta.dart';

@Target({TargetKind.method, TargetKind.function, TargetKind.classType})
class CliCommand {
  final String? name;
  final String? description;
  final String? category;

  const CliCommand({
    this.name,
    this.description,
    this.category,
  });
}

const cliCommand = CliCommand();

@Target({TargetKind.classType})
class CliRunner {
  final String? name;
  final String? description;
  final List<Type> subCommands;

  const CliRunner({
    this.name,
    this.description,
    this.subCommands = const [],
  });
}

const cliRunner = CliRunner();

@Target({TargetKind.classType})
class CliSubcommand {
  final String? name;
  final String? description;

  const CliSubcommand({
    this.name,
    this.description,
  });
}

const cliSubcommand = CliSubcommand();
