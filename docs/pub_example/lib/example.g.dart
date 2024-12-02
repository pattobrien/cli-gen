// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// SubcommandGenerator
// **************************************************************************

class _$StashSubcommand<T extends dynamic> extends Command<dynamic> {
  _$StashSubcommand() {
    final upcastedType = (this as StashSubcommand);
    addSubcommand(MyCustomCommand(upcastedType.myCustomCommand));
    addSubcommand(ApplyCommand(upcastedType.apply));
  }

  @override
  String get name => 'stash';

  @override
  String get description => 'Commands for managing a stack of stashed changes.';
}

class MyCustomCommand extends Command<void> {
  MyCustomCommand(this.userMethod) {
    argParser
      ..addOption(
        'name',
        mandatory: true,
      )
      ..addOption(
        'age',
        mandatory: false,
      )
      ..addOption(
        'default-path',
        defaultsTo: '~/',
        mandatory: false,
      )
      ..addOption(
        'some-documented-parameter',
        mandatory: false,
      )
      ..addOption(
        'custom-parameter',
        help: 'A custom help message for the parameter',
        defaultsTo: '42',
        mandatory: false,
      );
  }

  final Future<void> Function({
    required String name,
    int age,
    String defaultPath,
    String someDocumentedParameter,
    int customParameter,
  }) userMethod;

  @override
  String get name => 'my-custom-command';

  @override
  String get description => 'Save your local modifications to a new stash.';

  @override
  Future<void> run() {
    final results = argResults!;
    return userMethod(
      name: results['name'],
      age: int.parse(results['age']),
      defaultPath: (results['default-path'] as String?) ?? '~/',
      someDocumentedParameter: results['some-documented-parameter'],
      customParameter: results['custom-parameter'] != null
          ? int.parse(results['custom-parameter'])
          : 42,
    );
  }
}

class ApplyCommand extends Command<void> {
  ApplyCommand(this.userMethod) {
    argParser.addOption(
      'stash-ref',
      defaultsTo: '0',
      mandatory: false,
    );
  }

  final Future<void> Function({String stashRef}) userMethod;

  @override
  String get name => 'apply';

  @override
  String get description =>
      'Apply the stash at the given [stashRef] to the working directory.';

  @override
  Future<void> run() {
    final results = argResults!;
    return userMethod(stashRef: (results['stash-ref'] as String?) ?? '0');
  }
}

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
class _$GitRunner<T extends dynamic> extends CommandRunner<dynamic> {
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
  Future<dynamic> runCommand(ArgResults topLevelResults) async {
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
  }

  final Future<void> Function({
    required String branch,
    MergeStrategy strategy,
    bool commit,
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
          : MergeStrategy.ort,
      commit: results['commit'],
    );
  }
}
