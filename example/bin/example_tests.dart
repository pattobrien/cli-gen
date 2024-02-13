import 'package:example/runner.dart';

void main(List<String> arguments) async {
  final runner = GitRunner();

  // -- show help menu --
  arguments = [];
  await runner.run(arguments);

  // -- git merge --
  arguments = ['merge', '--branch', 'main', '--commit'];
  await runner.run(arguments);
  print('Completed! Running stash...');

  // -- git stash --
  arguments = ['stash', 'push', '--message', 'WIP'];
  await runner.run(arguments);

  print('Completed!');
}
