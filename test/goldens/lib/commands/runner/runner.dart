library goldens.commands.runner;

import 'package:cli_annotations/cli_annotations.dart';

part 'runner.g.dart';

@cliRunner
class FooBarRunner extends _$FooBarRunner {
  @cliMount
  Command get bar => BarCommand();

  @cliCommand
  void foo() {}
}

@cliSubcommand
class BarCommand extends _$BarCommand {}
