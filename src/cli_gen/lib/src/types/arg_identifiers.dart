import 'models/identifier_part.dart';

/// Identifiers for the `args` package.
class ArgsIdentifiers {
  const ArgsIdentifiers();

  static final _runnerUri = Uri.parse('package:args/command_runner.dart');
  static final _resultsUri = Uri.parse('package:args/src/arg_results.dart');

  IdentifierPart get commandRunner =>
      IdentifierPart('CommandRunner', _runnerUri);

  IdentifierPart get command => IdentifierPart('Command', _runnerUri);

  IdentifierPart get addCommand => IdentifierPart('addCommand', _runnerUri);

  IdentifierPart get addSubcommand =>
      IdentifierPart('addSubcommand', _runnerUri);

  IdentifierPart get argParser => IdentifierPart('ArgParser', _runnerUri);

  IdentifierPart get argResults => IdentifierPart('ArgResults', _resultsUri);

  IdentifierPart get argParserAddOption =>
      IdentifierPart('addOption', _runnerUri);

  IdentifierPart get argParserAddFlag => IdentifierPart('addFlag', _runnerUri);
}
