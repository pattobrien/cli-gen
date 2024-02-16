import 'package:cli_annotations/cli_annotations.dart';

part 'multi_select.g.dart';

@cliRunner
class MultiSelect extends _$MultiSelect {
  @cliCommand
  void multiValues({
    required List<String> multiString,
    Set<int>? multiInt = const {1, 5, 7},
    Iterable<MyFooEnum>? multiEnum,
  }) {}

  @cliCommand
  void singleValues({
    int multiInt = 1,
  }) {}
}

enum MyFooEnum { value1, value2 }
