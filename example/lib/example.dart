// ignore_for_file: unused_import

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

// part 'example.g.dart';

/// A command-line interface for version control.
// @cliRunner
class GitRunner {
  /// Join two or more development histories together.
  Future<void> merge({
    /// The name of the branch to be merged into the current branch.
    required String branch,

    /// Pass merge strategy specific option through to the merge strategy.
    MergeStrategy strategy = MergeStrategy.ort,

    /// Perform the merge and commit the result.
    bool? commit,
  }) async {
    // ...
  }
}

enum MergeStrategy { ort, recursive, resolve, octopus, ours, subtree }

// final exampleParser = ArgParser()..addMultiOption(
//   '',
//   defaultsTo: 
// )

// class MergeCommand extends Command<void> {
//   MergeCommand() {
//     argParser.addOption(
//       'branch',
//       abbr: 'b',
//       mandatory: true,
//       valueHelp: 'branch',
//       help: 'The name of the branch to be merged into the current branch.',
//     );
//     argParser.addOption(
//       'strategy',
//       abbr: 's',
//       defaultsTo: 'ort',
//       allowed: [
//         'ort',
//         'recursive',
//         'resolve',
//         'octopus',
//         'ours',
//         'subtree',
//       ],
//       help: 'Pass strategy specific option through to the merge strategy.',
//     );
//     argParser.addFlag(
//       'commit',
//       abbr: 'c',
//       negatable: true,
//       help: 'Perform the merge and commit the result.',
//     );
//   }

//   @override
//   String get name => 'merge';

//   @override
//   String get description => 'Join two or more development histories together.';

//   @override
//   Future<void> run() {
//     final branch = argResults?['branch'];
//     if (branch == null) {
//       throw ArgumentError(
//         'Merge requires a branch.',
//       );
//     }
//     final strategy = argResults?['strategy'];
//     final parsedStrategy = strategy == null
//         ? MergeStrategy.ort
//         : MergeStrategy.values.firstWhere((e) => e.name == strategy);
//     final commit = argResults?['commit'];
//     if (branch is! bool?) {
//       throw ArgumentError(
//         'Commit must be a boolean.',
//       );
//     }

//     // ... application logic here ...
//   }
// }
