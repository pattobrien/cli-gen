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
    bool? commit,
    Set<int> message,
    bool squash,
  }) userMethod;

  @override
  String get name => 'merge';

  @override
  String get description => 'Join two or more development histories together.';

  @override
  ArgParser get argParser => ArgParser()
    ..addOption(
      'branch',
      mandatory: true,
    )
    ..addFlag(
      'commit',
      negatable: true,
    )
    ..addMultiOption(
      'message',
      defaultsTo: [
        '1',
        '2',
      ],
    )
    ..addFlag(
      'squash',
      defaultsTo: true,
      negatable: true,
    );

  @override
  Future<void> run() {
    final results = argResults!;
    return userMethod(
      branch: results['branch'],
      commit: results['commit'] != null ? results['commit'] : null,
      message: results['message'] != null
          ? List<String>.from(results['message']).map(int.parse).toSet()
          : const {1, 2},
      squash: results['squash'] != null ? results['squash'] : true,
    );
  }
}
