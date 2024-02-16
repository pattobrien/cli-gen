/// This file tests two generations:
/// 1. `ArgParser.addOption.defaultsTo` is a stringified default value (or
///    a boolean, if the option is a flag).
/// 2. The default value is copied to the userMethod invocation as the true
///    value (i.e. not stringified).
library goldens.args.default_values;

import 'package:cli_annotations/cli_annotations.dart';

part 'default_values.g.dart';

@cliRunner
class DefaultValues extends _$DefaultValues {
  @cliCommand
  void defaultValues({
    String strVal = 'default',
    int intVal = 42,
    bool boolVal = true,
    MyFooEnum enumVal = MyFooEnum.value1,
    @Option(defaultsTo: 123) int? intAnnot,
  }) {}

  @cliCommand
  void defaultIterableValues({
    List<String> listVal = const ['a', 'b', 'c'],
    Set<int> setVal = const {1, 2, 3},
    Set<MyFooEnum> multiEnumVal = const {MyFooEnum.value1, MyFooEnum.value2},
  }) {}

  @cliCommand
  void annotatedParams({
    @Option(defaultsTo: 123) int? numericValue,
    // TODO: broken test
    // @MultiOption(defaultsTo: ['a', 'b', 'c'])
    // List<String> multiString = const [],
    @Flag(defaultsTo: true) bool flagVal = false,
  }) {}
}

enum MyFooEnum { value1, value2 }

const someConstant = 42;
