import 'package:cli_annotations/cli_annotations.dart';

part 'types.g.dart';

@cliRunner
class Types extends _$Types {
  @cliCommand
  void primativeTypes(
    String stringValue,
    int intValue,
    bool boolValue,
  ) {}

  @cliCommand
  void userTypes(
    MyFooEnum enumValue,
    // Email emailValue,
    {
    MyFooEnum enumValue2 = MyFooEnum.value1,
    // Email emailValue2 = const Email('foo'),
    int constVar = someConstant,
    @Option(parser: customParser) int customParserOption = 0,
  }) {}
}

enum MyFooEnum { value1, value2 }

const someConstant = 42;

int customParser(String value) => int.parse(value);

// ---
