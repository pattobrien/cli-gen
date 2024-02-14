// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stash.dart';

// **************************************************************************
// SubcommandGenerator
// **************************************************************************

class _$StashSubcommand extends Command {
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

class PushCommand extends Command {
  PushCommand(this.userMethod);

  final Function(
    String, {
    bool includeUntracked,
  }) userMethod;

  @override
  String get name => 'push';

  @override
  String get description => 'Save your local modifications to a new stash.';

  @override
  ArgParser get argParser => ArgParser()
    ..addOption(
      'message',
      mandatory: true,
    )
    ..addFlag(
      'include-untracked',
      defaultsTo: false,
    );

  @override
  Future<void> run() {
    final results = argResults!;
    return userMethod(
      results['message'],
      includeUntracked: results['include-untracked'] != null
          ? results['include-untracked']
          : false,
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
