import 'dart:io';

import 'package:args/command_runner.dart';

Future<void> main(List<String> arguments) => GitRunner().run(arguments);

/// A dart implementation of distributed version control.
class GitRunner extends CommandRunner<void> {
  GitRunner()
      : super(
          'git',
          'A dart implementation of distributed version control.',
        ) {
    addCommand(MergeCommand());
  }

  @override
  Future<void> run(Iterable<String> args) async {
    try {
      return await super.run(args);
    } on UsageException catch (e) {
      stdout.writeln(e.message);
      stdout.writeln();
      stdout.writeln(e.usage);
    }
  }
}

/// Join two or more development histories together.
class MergeCommand extends Command<void> {
  MergeCommand() {
    argParser.addOption(
      'branch',
      abbr: 'b',
      mandatory: true,
      valueHelp: 'branch',
      help: 'The name of the branch to be merged into the current branch.',
    );
    argParser.addOption(
      'strategy',
      abbr: 's',
      defaultsTo: 'ort',
      allowed: [
        'ort',
        'recursive',
        'resolve',
        'octopus',
        'ours',
        'subtree',
      ],
      help: 'Pass strategy specific option through to the merge strategy.',
    );
    argParser.addFlag(
      'commit',
      abbr: 'c',
      negatable: true,
      help: 'Perform the merge and commit the result.',
    );
  }

  @override
  String get name => 'merge';

  @override
  String get description => 'Join two or more development histories together.';

  @override
  Future<void> run() async {
    final results = argResults!;
    final branch = results['branch'] as String;

    final strategy = results['strategy'];
    final parsedStrategy = strategy == null
        ? MergeStrategy.ort
        : MergeStrategy.values.firstWhere((e) => e.name == strategy);
    final commit = results['commit'] as bool?;

    /* ... application logic ... */
  }
}

enum MergeStrategy { ort, recursive, resolve, octopus, ours, subtree }
