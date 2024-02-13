import 'package:code_builder/code_builder.dart';

import 'annotation_model.dart';

class CommandParameterModel {
  const CommandParameterModel({
    required this.ref,
    required this.type,
    required this.isNamed,
    required this.isRequired,
    required this.optionType,
    this.docComments,
    // this.defaultValueCode,
    String? computedDefaultValue,
    this.annotations = const [],
    this.availableOptions,
    required Expression? parser,
    required this.isIterable,
  })  : _parser = parser,
        _computedDefaultValue = computedDefaultValue;

  final Expression? _parser;
  final String? _computedDefaultValue;

  final OptionType optionType;

  final Reference ref;

  Expression? get parser =>
      annotations.map((e) => e.parser).firstOrNull ?? _parser;

  Expression? get computedDefaultValue {
    return annotations.map((e) => e.defaultsTo).firstOrNull ??
        (_computedDefaultValue != null
            // ? CodeExpression(Code("'$_computedDefaultValue'"))
            ? type.symbol == 'bool'
                ? literalBool(bool.parse(_computedDefaultValue))
                : literalString(_computedDefaultValue)
            : null);
  }

  final TypeReference type;
  final bool isIterable;

  final bool isNamed;

  final bool isRequired;

  final String? docComments;

  // // TODO: should defaultValueCode be a Code or a String?
  // final String? defaultValueCode;

  // final String? computedDefaultValue;

  final List<String>? availableOptions;

  final List<AnnotationModel> annotations;
}

enum OptionType {
  single,

  /// Option where user can select more than one value
  multiOption,
}
