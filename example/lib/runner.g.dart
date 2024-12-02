// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'runner.dart';

// **************************************************************************
// CliRunnerGenerator
// **************************************************************************

/// A command-line interface for version control.
///
/// A class for invoking [Command]s based on raw command-line arguments.
///
/// The type argument `T` represents the type returned by [Command.run] and
/// [CommandRunner.run]; it can be ommitted if you're not using the return
/// values.
class _$GitRunner<T extends dynamic> extends CommandRunner<void> {
  _$GitRunner()
      : super(
          'git',
          'A command-line interface for version control.',
        ) {
    final upcastedType = (this as GitRunner);
    addCommand(MergeCommand(upcastedType.merge));
    addCommand(PushCommand(upcastedType.push));
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
  MergeCommand(this.userMethod) {
    argParser
      ..addOption(
        'branch',
        mandatory: true,
      )
      ..addOption(
        'strategy',
        help: 'The merge strategy to use',
        defaultsTo: 'recursive',
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
      ..addOption(
        'foo-with-default',
        help: 'Perform the merge and commit the result.',
        defaultsTo: '42',
        mandatory: false,
      )
      ..addFlag('commit');
  }

  final Future<void> Function({
    required String branch,
    MergeStrategy strategy,
    int? fooWithDefault,
    bool? commit,
  }) userMethod;

  @override
  String get name => 'merge';

  @override
  String get description => 'Join two or more development histories together.';

  @override
  Future<void> run() {
    final results = argResults!;
    return userMethod(
      branch: results['branch'],
      strategy: results['strategy'] != null
          ? EnumParser(MergeStrategy.values).parse(results['strategy'])
          : MergeStrategy.recursive,
      fooWithDefault: results['foo-with-default'] != null
          ? int.parse(results['foo-with-default'])
          : null,
      commit: (results['commit'] as bool?) ?? null,
    );
  }
}

class PushCommand extends Command<void> {
  PushCommand(this.userMethod) {
    argParser
      ..addOption(
        'remote',
        mandatory: true,
      )
      ..addOption(
        'branch',
        mandatory: true,
      )
      ..addFlag(
        'force',
        defaultsTo: false,
      );
  }

  final Future<void> Function(
    String,
    String?, {
    bool force,
  }) userMethod;

  @override
  String get name => 'push';

  @override
  String get description => '';

  @override
  Future<void> run() {
    final results = argResults!;
    var [
      String remote,
      String? branch,
    ] = results.rest;
    return userMethod(
      remote,
      branch != null ? branch : null,
      force: (results['force'] as bool?) ?? false,
    );
  }
}
