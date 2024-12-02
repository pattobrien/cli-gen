library goldens.commands.runner;

import 'package:cli_annotations/cli_annotations.dart';

part 'subcommand.g.dart';

@cliSubcommand
class FooBarSubcommand extends _$FooBarSubcommand<int> {
  @cliMount
  BarCommand get bar => BarCommand();

  @cliCommand
  int foo() => 42;
}

@cliSubcommand
class BarCommand extends _$BarCommand<int> {}
