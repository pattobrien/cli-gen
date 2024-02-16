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
    @Option(
      help: 'The merge strategy to use',
      defaultsTo: MergeStrategy.recursive,
    )
    MergeStrategy strategy = MergeStrategy.ort,
    @Option(
      help: 'Perform the merge and commit the result.',
      defaultsTo: foo,
    )
    int? fooWithDefault,

    /// Perform the merge and commit the result.
    bool? commit,
  }) async {
    print('Merging branch $branch');
    if (commit == true) {
      print('Committing merge');
    }
    await Future.delayed(const Duration(seconds: 1));
  }
}

enum MergeStrategy { ort, recursive, resolve, octopus, ours, subtree }
