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
  PushCommand(this.userMethod) {
    argParser
      ..addFlag(
        'include-untracked',
        help: 'Include untracked files in the stash.',
        defaultsTo: false,
      )
      ..addOption(
        'message',
        mandatory: false,
      );
  }

  final Function({
    bool includeUntracked,
    String message,
  }) userMethod;

  @override
  String get name => 'push';

  @override
  String get description => 'Save your local modifications to a new stash.';

  @override
  Future<void> run() {
    final results = argResults!;
    return userMethod(
      includeUntracked: results['include-untracked'] != null
          ? results['include-untracked']
          : false,
      message: results['message'],
    );
  }
}

class ApplyCommand extends Command<void> {
  ApplyCommand(this.userMethod) {
    argParser.addOption(
      'stash-ref',
      help: 'The stash to apply',
      defaultsTo: '0',
      mandatory: false,
    );
  }

  final Function({String stashRef}) userMethod;

  @override
  String get name => 'apply';

  @override
  String get description =>
      'Apply the stash at the given [stashRef] to the working directory.';

  @override
  Future<void> run() {
    final results = argResults!;
    return userMethod(
        stashRef: results['stash-ref'] != null ? results['stash-ref'] : '0');
  }
}
