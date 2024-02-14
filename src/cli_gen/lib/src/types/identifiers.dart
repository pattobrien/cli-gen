import 'arg_identifiers.dart';
import 'cli_gen_identifiers.dart';
import 'dart_identifiers.dart';

/// A collection of common identifiers used for code generation.
class Identifiers {
  const Identifiers._();

  static const args = ArgsIdentifiers();

  static const dart = DartCoreIdentifiers();

  static const cliGen = CliGenIdentifiers();
}
