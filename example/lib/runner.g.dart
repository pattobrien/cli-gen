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
    Uri? uri,
    int? ff,
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
    )
    ..addFlag('commit')
    ..addOption(
      'uri',
      mandatory: false,
    )
    ..addOption(
      'ff',
      mandatory: false,
      allowed: [
        '1',
        '2',
        '3',
      ],
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
      uri: results['uri'] != null ? Uri.parse(results['uri']) : null,
      ff: results['ff'] != null ? int.parse(results['ff']) : null,
    );
  }
}
