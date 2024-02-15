// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'runner.dart';

// **************************************************************************
// CliRunnerGenerator
// **************************************************************************

class _$GitRunner<T extends dynamic> extends CommandRunner<void> {
  _$GitRunner()
      : super(
          'git',
          'A command-line interface for version control.',
        ) {
    final upcastedType = (this as GitRunner);
    addCommand(MergeCommand(upcastedType.merge));
    addCommand(upcastedType.stash);
  }

  @override
  Future<void> runCommand(ArgResults topLevelResults) async {
    try {
      return await super.runCommand(topLevelResults);
    } on UsageException catch (e) {
      stdout.writeln('${e.message}\n');
      stdout.writeln(e.usage);
    }
  }
}

class MergeCommand extends Command<void> {
  MergeCommand(this.userMethod);

  final Function({
    required String branch,
    MergeStrategy strategy,
    bool commit,
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
    ..addOption(
      'strategy',
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
    ..addFlag('commit');

  @override
  Future<void> run() {
    final results = argResults!;
    return userMethod(
      branch: results['branch'],
      strategy: results['strategy'] != null
          ? EnumParser(MergeStrategy.values).parse(results['strategy'])
          : MergeStrategy.ort,
      commit: results['commit'],
    );
  }
}
