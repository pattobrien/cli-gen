import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';

/// {@template cli_command}
/// An annotation to define a single command.
///
/// Generates a subclass of [Command] for the annotated class to extend.
///
/// #### Example usage
///
/// ```dart
/// @cliRunner
/// class GitRunner extends _$GitRunner {
///
///   /// Join two or more development histories together.
///   @cliCommand
///   Future<void> merge({
///     required String branch,
///     MergeStrategy strategy = MergeStrategy.ort,
///     bool? commit,
///   }) async {
///     /* ... */
///   }
///
/// }
/// ```
/// {@endtemplate}
@Target({TargetKind.method, TargetKind.function, TargetKind.classType})
class CliCommand {
  final String? name;

  final String? description;

  /// The command's category.
  ///
  /// Displayed in [parent]'s [CommandRunner.usage]. Commands with categories
  /// will be grouped together, and displayed after commands without a category.
  final String? category;

  const CliCommand({
    this.name,
    this.description,
    this.category,
  });
}

/// {@macro cli_command}
const cliCommand = CliCommand();

/// {@template cli_runner}
/// An annotation to define the application's entry point.
///
/// Generates a subclass of [CommandRunner] for the annotated class to extend. A
/// command runner represents your application and is the entry point to your
/// command-line interface.
///
/// #### Example usage
///
/// ```dart
/// @cliRunner
/// class GitRunner extends _$GitRunner {
///  @cliCommand
///  Future<void> merge() async { /* ... */ }
/// }
/// ```
/// {@endtemplate}
@Target({TargetKind.classType})
class CliRunner {
  final String? name;

  final String? description;

  @experimental
  final List<Type> subCommands;

  const CliRunner({
    this.name,
    this.description,
    this.subCommands = const [],
  });
}

/// {@macro cli_runner}
const cliRunner = CliRunner();

/// {@template cli_subcommand}
/// An annotation to define a subcommand for a command-line interface runner.
///
/// Generates a subclass of [Command] for the annotated class to extend. A
/// subcommand is a command that has one or more children commands or subcommands.
///
/// #### Example usage
///
/// ```dart
/// @cliSubcommand
/// class StashSubcommand extends _$StashSubcommand {
///   @cliCommand
///   Future<void> apply() async { /* ... */ }
///
///   @cliCommand
///   Future<void> pop() async { /* ... */ }
/// }
/// ```
///
/// {@endtemplate}
@Target({TargetKind.classType})
class CliSubcommand {
  final String? name;

  final String? description;

  const CliSubcommand({
    this.name,
    this.description,
  });
}

/// {@macro cli_subcommand}
const cliSubcommand = CliSubcommand();

/// {@template subcommand_mount}
/// An annotation to attach a command or subcommand to a parent command.
///
/// This annotation should be used on a method of an annotated [CliRunner] or
/// [CliSubcommand] class. The method should return a [Command].
///
/// Example:
/// ```dart
/// @cliRunner
/// class MyRunner extends _$MyRunner {
///  @cliMount
///  Command get mySubcommand => MySubcommand();
/// }
/// ```
/// {@endtemplate}

class CliMount {
  const CliMount();
}

/// {@macro subcommand_mount}
const cliMount = CliMount();

@Deprecated('Use cliMount instead')
const mount = cliMount;

@Deprecated('Use CliMount instead')
class CliSubcommandMount extends CliMount {
  @Deprecated('Use CliMount() instead')
  const CliSubcommandMount();
}
