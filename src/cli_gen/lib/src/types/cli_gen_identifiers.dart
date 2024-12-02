import 'models/identifier_part.dart';

/// Identifiers for the `cli_annotations` package.
class CliGenIdentifiers {
  const CliGenIdentifiers();

  Uri get _uri => Uri.parse('package:cli_annotations/cli_annotations.dart');

  IdentifierPart get cliCommand => IdentifierPart('CliCommand', _uri);

  IdentifierPart get cliSubCommand => IdentifierPart('CliSubcommand', _uri);

  IdentifierPart get cliArgs => IdentifierPart('CliArgs', _uri);
}
