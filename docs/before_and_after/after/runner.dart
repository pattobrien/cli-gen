import 'package:cli_annotations/cli_annotations.dart';

part 'runner.g.dart';

/// A command-line interface for version control.
@cliRunner
class GitRunner extends _$GitRunner {
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
    /* ... application logic ... */
  }
}

enum MergeStrategy { ort, recursive, resolve, octopus, ours, subtree }
