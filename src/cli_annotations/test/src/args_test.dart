// ignore_for_file: unused_local_variable

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

    final cliRunner = CliRunner(
      name: 'test',
      description: 'test description',
    );

    final toString = cliRunner.toString();

    final cliSubcommand = CliSubcommand(
      name: 'test',
      description: 'test description',
    );
  });
}
