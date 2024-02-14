import 'package:code_builder/code_builder.dart';

import 'annotation_model.dart';

class CommandParameterModel {
  const CommandParameterModel({
    required this.ref,
    required this.type,
    required this.isNamed,
    required this.isRequired,
    required this.optionType,
    String? docComments,
    String? computedDefaultValue,
    this.annotations = const [],
    this.availableOptions,
    required Expression? parser,
    // required this.isIterable,
  })  : _parser = parser,
        _computedDefaultValue = computedDefaultValue,
        _docComments = docComments;

  final Expression? _parser;
  final String? _computedDefaultValue;

  final OptionType optionType;

  final Reference ref;

  Expression? get parser {
    return annotations.map((e) => e.parser).firstOrNull ?? _parser;
  }

  Expression? get computedDefaultValue {
    return annotations.map((e) => e.defaultsTo).firstOrNull ??
        (_computedDefaultValue != null
            ? type.symbol == 'bool'
                ? literalBool(bool.parse(_computedDefaultValue!))
                : literalString(_computedDefaultValue!)
            : null);
  }

  String? get docComments {
    return annotations.map((e) => e.help).firstOrNull ?? _docComments;
  }

  final TypeReference type;
  // final bool isIterable;

  final bool isNamed;

  final bool isRequired;

  final String? _docComments;

  // // TODO: should defaultValueCode be a Code or a String?
  // final String? defaultValueCode;

  // final String? computedDefaultValue;

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
