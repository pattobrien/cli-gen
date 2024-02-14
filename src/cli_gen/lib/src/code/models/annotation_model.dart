import 'package:code_builder/code_builder.dart';

class AnnotationModel {
  final TypeReference type;

  // final List<Object?> unNamedArgs;

  // final Map<String, Object?> namedArgs;
  final String? abbr;
  final String? help;
  final Expression? valueHelp;
  final bool? negatable;
  final bool? hide;

  /// The default value for the option.
  ///
  /// Example expressions:
  /// ```
  /// defaultsTo: 'ort' (single option)
  /// defaultsTo: ['foo', 'bar', 'baz'] (multi option)
  /// defaultsTo: true (flag)
  /// ```
  final Expression? defaultsTo;

  final List<String>? allowed;
  final Map<String, String>? allowedHelp;
  final List<String>? aliases;
  final bool? splitCommas;
  final Expression? parser;

  const AnnotationModel({
    required this.type,
    this.abbr,
    this.help,
    this.valueHelp,
    this.negatable,
    this.hide,
    this.defaultsTo,
    this.allowed,
    this.allowedHelp,
    this.aliases,
    this.splitCommas,
    this.parser,
  });

  bool get isOptionType => type.symbol == 'Option';

  bool get isFlagType => type.symbol == 'Flag';

  bool get isCommandType => type.symbol == 'CliCommand';
}
