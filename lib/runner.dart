import 'package:args/args.dart';
import 'package:args/command_runner.dart';

void main() async {
  final runner = ExampleRunner();
  final args = ['example', '--foo', 'bar']; // explicit option supplied
  await runner.run(args);

  final args2 = ['example']; // no explicit option supplied
  await runner.run(args2);
}

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
      'foo',
      abbr: 'f',
      mandatory: false,
      defaultsTo: 'default',
    );

  @override
  run() {
    print('Example command executed.');
  }
}
