// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'runner.dart';

// **************************************************************************
// CliRunnerGenerator
// **************************************************************************

class _$GitRunner extends CommandRunner {
  _$GitRunner()
      : super(
          'git',
          'A command-line interface for version control.',
        ) {
    final upcastedType = (this as GitRunner);
    addCommand(MergeCommand(upcastedType.merge));
    addCommand(upcastedType.stash);
  }
}

class MergeCommand extends Command {
  MergeCommand(this.userMethod);

  final Function({
    required String branch,
    MergeStrategy strategy,
    bool? commit,
  }) userMethod;

  @override
  String get name => 'merge';

  @override
  String get description => 'Join two or more development histories together.';

  @override
  ArgParser get argParser => ArgParser()
    ..addOption(
      'branch',
      help: 'The name of the branch to be merged into the current branch.',
      mandatory: true,
    )
    ..addOption(
      'strategy',
      help:
          'Pass merge strategy specific option through to the merge strategy.',
      defaultsTo: 'ort',
      mandatory: false,
      allowed: [
        'ort',
        'recursive',
        'resolve',
        'octopus',
        'ours',
        'subtree',
      ],
    )
    ..addFlag(
      'commit',
      help: 'Perform the merge and commit the result.',
    );

  @override
  Future<void> run() {
    final results = argResults!;
    return userMethod(
      branch: results['branch'],
      strategy: results['strategy'] != null
          ? EnumParser(MergeStrategy.values).parse(results['strategy'])
          : MergeStrategy.ort,
      commit: results['commit'] != null ? results['commit'] : null,
    );
  }
}
