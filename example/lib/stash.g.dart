// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stash.dart';

// **************************************************************************
// SubcommandGenerator
// **************************************************************************

class _$StashSubcommand<T extends dynamic> extends Command<dynamic> {
  _$StashSubcommand() {
    final upcastedType = (this as StashSubcommand);
    addSubcommand(PushCommand(upcastedType.push));
    addSubcommand(ApplyCommand(upcastedType.apply));
  }

  @override
  String get name => 'stash';

  @override
  String get description => 'Commands for managing a stack of stashed changes.';
}

class PushCommand extends Command<void> {
  PushCommand(this.userMethod);

  final Function({
    required String name,
    int age,
    String defaultPath,
    String someDocumentedParameter,
    int customParameter,
  }) userMethod;

  @override
  String get name => 'push';

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
      age: int.parse(results['age']),
      defaultPath:
          results['default-path'] != null ? results['default-path'] : '~/',
      someDocumentedParameter: results['some-documented-parameter'],
      customParameter: results['custom-parameter'] != null
          ? int.parse(results['custom-parameter'])
          : 42,
    );
  }
}

class ApplyCommand extends Command<void> {
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
