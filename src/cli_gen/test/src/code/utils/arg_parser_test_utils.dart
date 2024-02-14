import 'package:analyzer/dart/ast/ast.dart' hide Block;
import 'package:cli_gen/src/code/arg_parser/arg_parser_instance_builder.dart';
import 'package:cli_gen/src/code/models/command_parameter_model.dart';
import 'package:code_builder/code_builder.dart' as code;
import 'package:code_builder/code_builder.dart' hide Expression;

import 'common.dart';
import 'types.dart';

/// Generates the call expression Code for `ArgParser()..addOption()`, analyzes
/// the result, and returns a list of unresolved Expression AST nodes that
/// represent the arguments of the `addOption` call.
List<Expression> generateOptionArguments({
  String paramName = 'message',
  TypeReference? type,
  bool isRequired = true,
  bool isNamed = false,
  String? computedDefaultValue,
  bool isBoolean = false,
  String? docComment = 'The message to display.',
}) {
  final cascadeExp = generateArgParserCascaseExp(
    paramName: paramName,
    type: type,
    computedDefaultValue: computedDefaultValue != null
        ? isBoolean
            ? literalBool(bool.parse(computedDefaultValue))
            : literalString(computedDefaultValue)
        : null,
    isRequired: isRequired,
    docComments: docComment,
    isNamed: isNamed,
  );

  final singleCascadeExp = cascadeExp.cascadeSections.single;
  singleCascadeExp as MethodInvocation;
  return singleCascadeExp.argumentList.arguments;
}

/// Used for testing the code gen for the `ArgParser()..addOption()` cascade
/// expressions.
CascadeExpression generateArgParserCascaseExp({
  String paramName = 'message',
  String? docComments = 'The message to display.',
  TypeReference? type,
  String? defaultValueCode,
  bool isRequired = true,
  bool isNamed = false,
  OptionType optionType = OptionType.single,
  List<String>? availableOptions,
  code.Expression? computedDefaultValue,
  String? parser,
  bool isIterable = false,
}) {
  type ??= TestTypes.string;
  final builder = ArgParserInstanceExp();

  final argParserExp = CodeExpression(Code('final x = ArgParser()'));

  final parameter = CommandParameterModel(
    parser: Reference(parser),
    name: Reference(paramName),
    docComments: docComments,
    computedDefaultValue: computedDefaultValue,
    defaultValueAsCode: defaultValueCode,
    type: type,
    isRequired: isRequired,
    isNamed: isNamed,
    optionType: optionType,
    availableOptions: availableOptions,
  );
  final codeExpression = builder.generateArgOption(argParserExp, parameter);

  final unit = codeToUnresolvedUnit(codeExpression.statement);
  final variable = unit.declarations.single as TopLevelVariableDeclaration;
  return variable.variables.variables.single.initializer as CascadeExpression;
}
