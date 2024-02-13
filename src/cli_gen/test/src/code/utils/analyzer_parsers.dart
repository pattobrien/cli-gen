import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart' hide Block;
import 'package:cli_gen/src/code/arg_parser/arg_parser_instance_builder.dart';
import 'package:cli_gen/src/code/command/cli_method_call_builder.dart';
import 'package:cli_gen/src/code/models/command_method_model.dart';
import 'package:cli_gen/src/code/models/command_parameter_model.dart';
import 'package:code_builder/code_builder.dart' hide Expression;
import 'package:dart_style/dart_style.dart';

import 'types.dart';

ParseStringResult parseCode(Code code) {
  final emitter = DartEmitter(useNullSafetySyntax: true);
  final content = code.accept(emitter).toString();
  final formatter = DartFormatter();
  final formattedContent = formatter.format(content);
  return parseString(content: formattedContent);
}

InvocationExpression generateArgResultHandlerExp({
  String methodName = 'myCliMethod',
  String paramName = 'message',
  TypeReference? paramType,
  String? defaultValueCode,
  String? computedDefaultValue,
  bool isRequired = true,
  bool isNamed = false,
  String? parser,
}) {
  final builder = CliMethodCallBuilder();
  final callStatement = builder.buildInlineCallStatement(
    CommandMethodModel(
      methodRef: refer(methodName),
      docComments: null,
      annotations: [],
      returnType: TestTypes.void_,
      parameters: [
        CommandParameterModel(
          parser: parser != null ? refer(parser) : null,
          ref: Reference(paramName),
          type: paramType ?? TestTypes.string,
          isRequired: isRequired,
          isNamed: isNamed,
          defaultValueCode: defaultValueCode,
          optionType: OptionType.single,
          annotations: [],
          computedDefaultValue: computedDefaultValue,
          docComments: null,
          availableOptions: [],
        ),
      ],
    ),
  );

// now lets build a fake function to hold the callStatement
  final function = Method(
    (b) => b
      ..name = 'testHandler'
      ..returns = TestTypes.void_
      ..requiredParameters.add(Parameter((b) => b
        ..name = 'results'
        ..type = TypeReference((builder) {
          builder.symbol = 'ArgResults';
          builder.url = 'package:args/command_runner.dart';
        })))
      ..body = Block.of([callStatement]),
  );
  // final library = Library((builder) {
  //   builder.body.add(function);
  // });

  final analyzedResult = parseCode(function.closure.code);

  final functionDecl =
      analyzedResult.unit.declarations.single as FunctionDeclaration;
  final functionBody =
      functionDecl.functionExpression.body as BlockFunctionBody;
  final statement = functionBody.block.statements.single as ReturnStatement;
  return statement.expression as InvocationExpression;
}

/// Used for testing the code gen for the `ArgParser()..addOption()` cascade
/// expressions.
CascadeExpression generateArgParserOption({
  String paramName = 'message',
  String? docComments = 'The message to display.',
  TypeReference? type,
  String? defaultValueCode,
  bool isRequired = true,
  bool isNamed = false,
  OptionType optionType = OptionType.single,
  List<String>? availableOptions,
  String? computedDefaultValue,
  String? parser,
}) {
  type ??= TestTypes.string;
  final builder = ArgParserInstanceExp();

  final argParserExp = CodeExpression(Code('final x = ArgParser()'));

  final parameter = CommandParameterModel(
    parser: Reference(parser),
    ref: Reference(paramName),
    docComments: docComments,
    defaultValueCode: defaultValueCode,
    computedDefaultValue: computedDefaultValue,
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

/// A test utility to generate the call expression for `ArgParser()..addOption()`
/// as a list of AST expressions.
List<Expression> generateOptionArguments({
  String paramName = 'message',
  TypeReference? type,
  bool isRequired = true,
  bool isNamed = false,
  String? defaultValue,
  String? computedDefaultValue,
  String? docComment = 'The message to display.',
}) {
  final cascadeExp = generateArgParserOption(
    paramName: paramName,
    type: type,
    defaultValueCode: defaultValue,
    computedDefaultValue: computedDefaultValue,
    isRequired: isRequired,
    docComments: docComment,
    isNamed: isNamed,
  );

  return getOptionArguments(cascadeExp);
}
