import '../utils/identifier_part.dart';

class MacroArgIdentifiers {
  const MacroArgIdentifiers();

  Uri get _uri => Uri.parse('package:cli_annotations/cli_annotations.dart');

  IdentifierPart get cliCommand => IdentifierPart('CliCommand', _uri);

  IdentifierPart get cliSubCommand => IdentifierPart('CliSubCommand', _uri);

  IdentifierPart get cliArgs => IdentifierPart('CliArgs', _uri);
}
