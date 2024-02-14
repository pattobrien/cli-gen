import 'package:example/runner.dart';

// void main(List<String> arguments) async {
//   final runner = GitRunner();
//   await runner.run(arguments);
// }

Future<void> main(List<String> arguments) => GitRunner().run(arguments);
