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
void named({
  required String reqValue,
  String? optValue,
  String defValue = 'default',
}) {}

// note: default values arent permitted with positional parameters
@CliCommand()
void positional(
  String reqValue, [
  String? optValue,
  String defValue = 'default',
]) {}

// -- DEFAULT VALUE TESTS --

@CliCommand()
void defaultValues({
  String stringVal = 'default',
  int integerVal = 42,
  bool booleanVal = true,
}) {}

// -- DOC COMMENTS --

@CliCommand()
class DocComments {
  const DocComments({
    required this.message,
  });

  /// The message to display.
  final String message;
}
