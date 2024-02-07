import 'package:cli_annotations/cli_annotations.dart';

@CliCommand()
void commit(
  /// The message to display.
  String message,
) {}

@CliCommand()
void primativeTypes(
  String stringValue,
  int intValue,
  bool boolValue,
) {}

// -- USER DEFINED TYPE TESTS --

@CliCommand()
void userTypes(
  EnumType enumValue,
  Email emailValue, {
  EnumType enumValue2 = EnumType.value1,
  Email emailValue2 = const Email('foo'),
  int constVar = someConstant,
}) {}

extension type const Email(String value) {}

enum EnumType { value1, value2 }

const someConstant = 42;

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
