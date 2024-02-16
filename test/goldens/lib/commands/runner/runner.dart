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

/// Some runner description from doc comment.
@CliRunner(
  name: 'some-runner',
  description: 'Some runner description from annotation.',
  displayStackTrace: true,
)
class Runner extends _$Runner {
  @cliMount
  BarCommand get fooBar => BarCommand();
}
