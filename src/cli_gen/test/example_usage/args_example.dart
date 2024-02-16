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
  MyFooEnum enumValue,
  // Email emailValue,
  {
  MyFooEnum enumValue2 = MyFooEnum.value1,
  // Email emailValue2 = const Email('foo'),
  int constVar = someConstant,
}) {}

// extension type const Email(String value) {
//   factory Email.parse(String value) {
//     // check if value is valid
//     final regexp = RegExp(r'^\S+@\S+\.\S+$');
//     if (!regexp.hasMatch(value)) {
//       throw ArgumentError('Invalid email address');
//     }
//     return Email(value);
//   }
// }

enum MyFooEnum { value1, value2 }

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
  List<String> listVal = const ['a', 'b', 'c'],
  Set<int> setVal = const {1, 2, 3},
}) {}

// -- DOC COMMENTS --

// ignore: invalid_annotation_target
@cliCommand
class DocComments {
  const DocComments({
    required this.message,
  });

  /// The message to display.
  final String message;
}
// -- MULTI-SELECT TESTS --

@CliCommand()
void multiSelect({
  List<String> multiString = const [],
  Set<int> multiInt = const {},
  Iterable<MyFooEnum> multiEnum = const [],
}) {}

final String x = MyFooEnum.value1.name;

@CliCommand()
void annotatedParams({
  @Option(
    abbr: 'a',
    help: 'Annotation comment.',
    defaultsTo: 123,
    parser: myCustomParser,
  )
  int numericValue = 234,
}) {}

int myCustomParser(String value) => int.parse(value);
