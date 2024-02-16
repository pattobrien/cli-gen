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
    MyFooEnum enumValue, {
    MyFooEnum enumValue2 = MyFooEnum.value1,
    @Option(parser: Email.fromString) Email emailValue2 = const Email('foo'),
    int constVar = someConstant,
    @Option(parser: customParser) int customParserOption = 0,
    @Option(parser: ProductId.fromString) ProductId? productId,
  }) {}
}

enum MyFooEnum { value1, value2 }

const someConstant = 42;

int customParser(String value) => int.parse(value);

extension type const Email(String value) {
  factory Email.fromString(String value) => Email(value);
}

class ProductId {
  final String value;
  const ProductId(this.value);

  factory ProductId.fromString(String value) => ProductId(value);
}
