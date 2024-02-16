// ignore_for_file: unused_import

import 'dart:io';

import 'package:cli_annotations/cli_annotations.dart';
import 'package:example/runner.dart';

void main() async {
  var arguments = <String>[];
  final runner = GitRunner();
  print('----------------------------------------');
  print('Displaying help menu...\n');
  arguments = ['--help'];
  await runner.run(arguments);

  print('\n----------------------------------------');
  print('Executing merge...\n');
  arguments = ['merge', '--branch', 'main', '--commit'];
  await runner.run(arguments);

  print('\n----------------------------------------');
  print('Executing stash apply help...\n');
  arguments = ['stash', 'apply', '--help'];
  await runner.run(arguments);

  print('\n----------------------------------------');
  print('Executing a wrong command...\n');
  arguments = ['wrong-command'];
  await runner.run(arguments);

  print('\n----------------------------------------');
  print('Completed!');
  print('----------------------------------------');
}
