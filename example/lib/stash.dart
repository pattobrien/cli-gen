import 'package:cli_annotations/cli_annotations.dart';

part 'stash.g.dart';

/// Commands for managing a stack of stashed changes.
///
/// Use this to save and restore changes in a working directory temporarily, allowing
/// you to switch contexts and manage your work in progress without committing to the
/// Git history.
@cliSubcommand
class StashSubcommand extends _$StashSubcommand {
  /// Save your local modifications to a new stash.
  @cliCommand
  Future<void> push({
    String message = 'WIP',
  }) async {
    print('Stashing changes with message: $message');
    await Future.delayed(const Duration(seconds: 1));
  }

  /// Apply the stash at the given [stashRef] to the working directory.
  @cliCommand
  Future<void> apply({
    String stashRef = '0',
  }) async {
    print('Applying stash $stashRef');
    await Future.delayed(const Duration(seconds: 1));
  }
}
