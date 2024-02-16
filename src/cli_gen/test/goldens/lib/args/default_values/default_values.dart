import 'package:cli_annotations/cli_annotations.dart';

part 'default_values.g.dart';

@cliRunner
class DefaultValues extends _$DefaultValues {
  @cliCommand
  void defaultValues({
    String stringVal = 'default',
    int integerVal = 42,
    bool booleanVal = true,
    List<String> listVal = const ['a', 'b', 'c'],
    Set<int> setVal = const {1, 2, 3},
    MyFooEnum enumVal = MyFooEnum.value1,
    Set<MyFooEnum> multiEnumVal = const {MyFooEnum.value1, MyFooEnum.value2},
  }) {}
}

enum MyFooEnum { value1, value2 }

const someConstant = 42;
