import 'package:cli_annotations/cli_annotations.dart';
import 'package:test/test.dart';

void main() {
  test('CliCommand annotation', () async {
    final cliCommand = CliCommand(
      name: 'test',
      description: 'test description',
      category: 'test category',
    );
    cliCommand.toString();
  });
}
