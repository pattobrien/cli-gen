import 'package:cli_annotations/cli_annotations.dart';

part 'named_positional.g.dart';

@cliRunner
class NamedPositional extends _$NamedPositional {
  @CliCommand()
  void positional(
    String reqValue, [
    String? optValue,
    String defValue = 'default',
  ]) {}

  @cliCommand
  void named({
    required String reqValue,
    String? optValue,
    String defValue = 'default',
  }) {}
}
