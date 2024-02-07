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

class CliSubCommand {
  final String? name;
  final String? description;

  const CliSubCommand({
    this.name,
    this.description,
  });
}
