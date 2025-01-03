import 'package:cli_annotations/cli_annotations.dart';

import 'stash.dart';

part 'runner.g.dart';

/// A command-line interface for version control.
@cliRunner
class GitRunner extends _$GitRunner<void> {
  @cliMount
  Command get stash => StashSubcommand();

  static const foo = 42;

  /// Join two or more development histories together.
  @cliCommand
  Future<void> merge({
    /// The name of the branch to be merged into the current branch.
    required String branch,

    /// Pass merge strategy specific option through to the merge strategy.
    MergeStrategy strategy = MergeStrategy.ort,

    /// Perform the merge and commit the result.
    bool? commit,
  }) async {
    print('Merging branch $branch');
    if (commit == true) {
      print('Committing merge');
    }
    await Future.delayed(const Duration(seconds: 1));
  }

  @cliCommand
  Future<void> push(
    String remote,
    String? branch, {
    bool force = false,
  }) async {
    //
  }
}

enum MergeStrategy { ort, recursive, resolve, octopus, ours, subtree }
