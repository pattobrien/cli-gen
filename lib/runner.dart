import 'package:args/args.dart';
import 'package:args/command_runner.dart';

class ExampleRunner extends CommandRunner {
  ExampleRunner() : super('example', 'Example command runner.') {
    addCommand(ExampleCommand());
  }
}

class ExampleCommand extends Command {
  @override
  String get description => 'Example command description.';

  @override
  String get name => 'example';

  @override
  ArgParser get argParser => ArgParser()
    ..addOption(
      'message',
      abbr: 'm',
      defaultsTo: 'true',
    );

  @override
  run() {
    print('Example command executed.');
  }
}
