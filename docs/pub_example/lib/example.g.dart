// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// SubcommandGenerator
// **************************************************************************

class _$StashSubcommand extends Command {
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

class MyCustomCommand extends Command {
  MyCustomCommand(this.userMethod);

  final Function({
    required String name,
    int? age,
    String defaultPath,
    String? someDocumentedParameter,
    int? customParameter,
  }) userMethod;

  @override
  String get name => 'my-custom-command';

  @override
  String get description => 'Save your local modifications to a new stash.';

  @override
  ArgParser get argParser => ArgParser()
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

  @override
  Future<void> run() {
    final results = argResults!;
    return userMethod(
      name: results['name'],
      age: results['age'] != null ? int.parse(results['age']) : null,
      defaultPath:
          results['default-path'] != null ? results['default-path'] : '~/',
      someDocumentedParameter: results['some-documented-parameter'] != null
          ? results['some-documented-parameter']
          : null,
      customParameter: results['custom-parameter'] != null
          ? int.parse(results['custom-parameter'])
          : null,
    );
  }
}

class ApplyCommand extends Command {
  ApplyCommand(this.userMethod);

  final Function({String stashRef}) userMethod;

  @override
  String get name => 'apply';

  @override
  String get description =>
      'Apply the stash at the given [stashRef] to the working directory.';

  @override
  ArgParser get argParser => ArgParser()
    ..addOption(
      'stash-ref',
      defaultsTo: '0',
      mandatory: false,
    );

  @override
  Future<void> run() {
    final results = argResults!;
    return userMethod(
        stashRef: results['stash-ref'] != null ? results['stash-ref'] : '0');
  }
}

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
      commit: results['commit'] != null ? results['commit'] : null,
    );
  }
}
