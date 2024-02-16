library goldens.commands.runner;

import 'package:cli_annotations/cli_annotations.dart';

part 'command.g.dart';

@cliSubcommand
class FooBarSubcommand extends _$FooBarSubcommand<int> {
  @cliCommand
  int foo() => 42;

  @cliCommand
  int bar() => 42;
}
