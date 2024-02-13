// ignore_for_file: unused_import

import 'dart:io';

import 'package:cli_annotations/cli_annotations.dart';
import 'package:example/runner.dart';

void main(List<String> arguments) async {
  // final runner = GitRunner();

  // // -- show help menu --
  // arguments = [];
  // await runner.run(arguments);

  // // -- git merge --
  // arguments = ['merge', '--branch', 'main', '--commit'];
  // await runner.run(arguments);
  // print('Completed! Running stash...');

  // // -- git stash --
  // arguments = ['stash', 'push', '--message', 'WIP'];
  // await runner.run(arguments);

  // print('Completed!');

  arguments = ['me', '--option', 'd'];
  final exitCode = await foorunner.run(arguments);
  // print('Exit code: $exitCode');
  exit(exitCode ?? 0);
}

final foorunner = MyCommandRunner();

class MyCommandRunner extends CommandRunner<int> {
  MyCommandRunner() : super('foo', '') {
    addCommand(MyCommand());
  }

  @override
  Future<int?> run(Iterable<String> args) async {
    try {
      return await super.run(args);
    } on UsageException catch (e) {
      e.usage;
      print('${e.message}\n');
      print(e.usage);
      return 64;
    }
  }
}

class MyCommand extends Command<int> {
  @override
  String get description => '';

  @override
  String get name => 'me';

  @override
  ArgParser get argParser => ArgParser()
    ..addOption(
      'option',
      mandatory: true,
      allowed: ['a', 'b', 'c'],
      help: 'An option',
    );

  @override
  Future<int> run() async {
    print('Running my command');
    return 0;
  }
}
