import 'package:cli_annotations/cli_annotations.dart';

part 'example.g.dart';

// 1. Create an entrypoint that calls `YourRunner().run(arguments)`.
Future<void> main(List<String> args) => GitRunner().run(args);

// 2. Create a class that extends the generated `_$` class and annotate it with
//`@cliRunner`.

/// A command-line interface for version control.
@cliRunner
class GitRunner extends _$GitRunner {
  @cliMount
  Command get stash => StashSubcommand();

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
}

enum MergeStrategy { ort, recursive, resolve, octopus, ours, subtree }

// 3. You can also create subcommands by annotating a method with `@cliSubcommand`.

/// Commands for managing a stack of stashed changes.
///
/// Use this to save and restore changes in a working directory temporarily, allowing
/// you to switch contexts and manage your work in progress without committing to the
/// Git history.
@cliSubcommand
class StashSubcommand extends _$StashSubcommand {
  /// Save your local modifications to a new stash.
  @cliCommand
  Future<void> myCustomCommand({
    // Required parameters will be shown to the user as `mandatory`
    required String name,

    // Optional and/or nullable parameters are not `mandatory`
    int? age,

    // Default values are also shown in the help text
    String defaultPath = '~/',

    /// Use doc comments (i.e. 3 slashes) to display a description of the parameter
    String? someDocumentedParameter,

    // You can override any generated values using `@Option`
    @Option(
      help: 'A custom help message for the parameter',
      defaultsTo: 42,
    )
    int? customParameter,
  }) async {
    // print('Stashing changes with message: $message');
    // await Future.delayed(const Duration(seconds: 1));
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
