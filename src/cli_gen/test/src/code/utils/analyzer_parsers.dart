import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:cli_gen/src/code/arg_parser/arg_parser_instance_builder.dart';
import 'package:cli_gen/src/code/models/command_parameter_model.dart';
import 'package:code_builder/code_builder.dart' hide Expression;

import 'types.dart';

ParseStringResult parseCode(Code code) {
  return parseString(
    content: code.accept(DartEmitter()).toString(),
  );
}

CascadeExpression generateArgParserOption({
  String paramName = 'message',
  String? docComments = 'The message to display.',
  TypeReference? type,
  String? defaultValue,
  bool isRequired = true,
  bool isNamed = false,
  OptionType optionType = OptionType.single,
  List<String>? availableOptions,
}) {
  type ??= TestTypes.string;
  final builder = ArgParserInstanceExp();

  final argParserExp = CodeExpression(Code('final x = ArgParser()'));

  final parameter = CommandParameterModel(
    ref: Reference(paramName),
    docComments: docComments,
    defaultValueCode: defaultValue,
    type: type,
    isRequired: isRequired,
    isNamed: isNamed,
    optionType: optionType,
    availableOptions: availableOptions,
  );
  final codeExpression = builder.generateArgOption(argParserExp, parameter);

  final analyzedResult = parseCode(codeExpression.statement);
  final variable =
      analyzedResult.unit.declarations.single as TopLevelVariableDeclaration;
  return variable.variables.variables.single.initializer as CascadeExpression;
}

List<Expression> getOptionArguments(CascadeExpression expression) {
  final singleCascadeExp = expression.cascadeSections.single;
  singleCascadeExp as MethodInvocation;
  return singleCascadeExp.argumentList.arguments;
}

List<Expression> generateOptionArguments({
  String paramName = 'message',
  TypeReference? type,
  bool isRequired = true,
  bool isNamed = false,
  String? defaultValue,
  String? docComment = 'The message to display.',
}) {
  final cascadeExp = generateArgParserOption(
    paramName: paramName,
    type: type,
    defaultValue: defaultValue,
    isRequired: isRequired,
    docComments: docComment,
    isNamed: isNamed,
  );

  return getOptionArguments(cascadeExp);
}
