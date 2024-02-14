import 'package:code_builder/code_builder.dart';
import 'package:recase/recase.dart';

import 'annotation_model.dart';

class CommandParameterModel {
  const CommandParameterModel({
    required this.name,
    required this.type,
    required this.isNamed,
    required this.isRequired,
    required this.optionType,
    String? docComments,
    Expression? computedDefaultValue,
    required String? defaultValueAsCode,
    this.annotations = const [],
    this.availableOptions,
    required Expression? parser,
  })  : _parser = parser,
        _computedDefaultValue = computedDefaultValue,
        _docComments = docComments,
        _defaultValueAsCode = defaultValueAsCode;

  final Expression? _parser;
  final Expression? _computedDefaultValue;
  final String? _defaultValueAsCode;
  final String? _docComments;

  final OptionType optionType;

  final Reference name;

  Expression? get defaultValueAsCode {
    final annotationValue = annotations.map((e) => e.defaultsTo).firstOrNull;
    return annotationValue ??
        (_defaultValueAsCode != null
            ? CodeExpression(Code(_defaultValueAsCode!))
            : null);
  }

  Expression? get parser {
    return annotations.map((e) => e.parser).firstOrNull ?? _parser;
  }

  Expression? get computedDefault {
    return annotations.map((e) => e.defaultsTo).firstOrNull ??
        _computedDefaultValue;
  }

  String? get docComments {
    return annotations.map((e) => e.help).firstOrNull ?? _docComments;
  }

  /// The name of the argument as it will appear in the generated CLI.
  ///
  /// Transforms the name from camelCase to param-case.
  ///
  /// e.g. `authorDateOrder` to `author-date-order`.
  String get cliArgumentName => name.symbol!.paramCase;

  /// The Dart type of the parameter, defined by the user.
  final TypeReference type;

  final bool isNamed;

  final bool isRequired;

  final List<String>? availableOptions;

  final List<AnnotationModel> annotations;

  String? get abbr => annotations.map((e) => e.abbr).firstOrNull;

  Expression? get valueHelp => annotations.map((e) => e.valueHelp).firstOrNull;

  bool? get negatable => annotations.map((e) => e.negatable).firstOrNull;

  bool? get hide => annotations.map((e) => e.hide).firstOrNull;

  List<String>? get allowed => annotations.map((e) => e.allowed).firstOrNull;

  List<String>? get aliases => annotations.map((e) => e.aliases).firstOrNull;

  Map<String, String>? get allowedHelp {
    return annotations.map((e) => e.allowedHelp).firstOrNull;
  }
}

enum OptionType {
  single,

  /// Option where user can select more than one value
  multi,
}
