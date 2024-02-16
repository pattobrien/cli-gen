import 'package:code_builder/code_builder.dart';

class OptionAnnotationModel {
  final TypeReference type;

  // final List<Object?> unNamedArgs;

  // final Map<String, Object?> namedArgs;
  final String? abbr;
  final String? help;
  final Expression? valueHelp;
  final bool? negatable;
  final bool? hide;

  /// The default value for the option, after computing the constant.
  ///
  /// Example expressions:
  /// ```
  /// defaultsTo: 'ort' (single option)
  /// defaultsTo: ['foo', 'bar', 'baz'] (multi option)
  /// defaultsTo: true (flag)
  /// ```
  final Expression? stringifiedDefaultValue;

  /// The source code of the default value, exactly as written by the user.
  final Expression? defaultAsSourceCode;

  final List<String>? allowed;
  final Map<String, String>? allowedHelp;
  final List<String>? aliases;
  final bool? splitCommas;
  final Expression? parser;

  const OptionAnnotationModel({
    required this.type,
    this.defaultAsSourceCode,
    this.abbr,
    this.help,
    this.valueHelp,
    this.negatable,
    this.hide,
    this.stringifiedDefaultValue,
    required this.allowed,
    this.allowedHelp,
    this.aliases,
    this.splitCommas,
    this.parser,
  });

  bool get isOptionType => type.symbol == 'Option';

  bool get isFlagType => type.symbol == 'Flag';

  bool get isCommandType => type.symbol == 'CliCommand';
}
