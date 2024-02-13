import 'package:cli_annotations/cli_annotations.dart';

part 'stash_subcommand.g.dart';

/// Implements a subset of Git stash commands for managing a stack of stashed changes.
///
/// Use this to save and restore changes in a working directory temporarily, allowing
/// you to switch contexts and manage your work in progress without committing to the
/// Git history.
@cliSubcommand
class StashSubcommand extends _$StashSubcommand {
  /// Save your local modifications to a new stash.
  @cliCommand
  void push(
    /// The message to display.
    String message, {
    /// Whether to include untracked files.
    @Option(abbr: 'u') bool includeUntracked = false,
  }) {
    throw UnimplementedError();
  }

  /// Apply the stash at the given [stashRef] to the working directory.
  @cliCommand
  void apply({
    String stashRef = '0',
  }) {
    throw UnimplementedError();
  }
}
