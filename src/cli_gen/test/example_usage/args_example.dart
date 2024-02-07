import 'package:cli_annotations/cli_annotations.dart';

@CliCommand()
Future<void> commit(
  /// The message to display.
  String message,
) async =>
    throw UnimplementedError();

@CliCommand()
Future<void> primativeTypes(
  String stringValue,
  int intValue,
  bool boolValue,
) async =>
    throw UnimplementedError();

// -- USER DEFINED TYPE TESTS --

@CliCommand()
Future<void> userDefinedTypes(
  EnumType enumValue,
  Email emailValue,
) async =>
    throw UnimplementedError();

extension type Email(String value) {}

enum EnumType { value1, value2 }

// -- REQUIRED/OPTIONAL + NAMED/POSITIONAL TESTS --

@CliCommand()
Future<void> named({
  required String requiredValue,
  String? optionalValue,
  String defaultValue = 'default',
}) async =>
    throw UnimplementedError();

// note: default values arent permitted with positional parameters
@CliCommand()
Future<void> positional(
  String requiredValue, [
  String? optionalValue,
  String defaultValue = 'default',
]) async =>
    throw UnimplementedError();
