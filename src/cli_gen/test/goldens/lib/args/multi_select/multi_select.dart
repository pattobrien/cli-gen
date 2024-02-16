import 'package:cli_annotations/cli_annotations.dart';

part 'multi_select.g.dart';

@cliRunner
class MultiSelect extends _$MultiSelect {
  @cliCommand
  void defaultValues({
    List<String> multiString = const [],
    Set<int> multiInt = const {},
    Iterable<MyFooEnum> multiEnum = const [],
  }) {}
}

enum MyFooEnum { value1, value2 }
