// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'runner.dart';

// **************************************************************************
// CliRunnerGenerator
// **************************************************************************

class _$GitRunner extends CommandRunner {
  _$GitRunner()
      : super(
          'git-runner',
          'A command-line interface for version control.',
        ) {
    final upcastedType = (this as GitRunner);
    addCommand(MergeCommand(upcastedType.merge));
    addCommand(upcastedType.stash);
  }

  @override
  Future run(Iterable<String> args) async {
    try {
      return super.run(args);
    } on UsageException catch (e) {
      print(e);
      return 64;
    }
  }
}

class MergeCommand extends Command {
  MergeCommand(this.userMethod);

  final Future<void> Function({
    required String branch,
    bool? commit,
    List<int>? options,
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
      negatable: false,
    )
    ..addOption(
      'options',
      mandatory: false,
    );

  @override
  Future<void> run() {
    final results = argResults!;
    return userMethod(
      branch: results['branch'],
      commit: results['commit'] != null ? results['commit'] : null,
      options: results['options'] != null
          ? List<String>.from(results['options']).map(int.parse).toList()
          : null,
    );
  }
}
