// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stash_subcommand.dart';

// **************************************************************************
// SubcommandGenerator
// **************************************************************************

class _$StashSubcommand extends Command {
  _$StashSubcommand() {
    addSubcommand(Push());
    addSubcommand(Apply());
  }

  @override
  String get name => 'StashSubcommand';

  @override
  String get description =>
      'Implements a subset of Git stash commands for managing a stack of stashed changes.\n\nUse this to save and restore changes in a working directory temporarily, allowing\nyou to switch contexts and manage your work in progress without committing to the\nGit history.';
}

class Push extends Command {
  @override
  String get name => 'push';

  @override
  String get description => 'Save your local modifications to a new stash.';
}

class Apply extends Command {
  @override
  String get name => 'apply';

  @override
  String get description =>
      'Apply the stash at the given [stashRef] to the working directory.';
}
