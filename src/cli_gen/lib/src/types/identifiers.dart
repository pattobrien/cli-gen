import 'arg_identifiers.dart';
import 'dart_identifiers.dart';
import 'keyword_identifiers.dart';
import 'macro_identifiers.dart';

class Identifiers {
  const Identifiers._();

  static const args = ArgsIdentifiers();

  static const keywords = KeywordIdentifiers();

  static const dart = DartCoreIdentifiers();

  static const macro = MacroArgIdentifiers();
}
