import 'package:cli_annotations/cli_annotations.dart';

void myFunction(
  @Option(
    abbr: 'a',
    help: 'The message to display.',
    defaultsTo: 123,
    parser: int.parse,
  )
  int numericValue,
) {}
