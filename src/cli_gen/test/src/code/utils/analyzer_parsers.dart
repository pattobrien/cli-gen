import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart' hide Block;
import 'package:cli_gen/src/code/arg_parser/arg_parser_instance_builder.dart';
import 'package:cli_gen/src/code/command/user_method_call_builder.dart';
import 'package:cli_gen/src/code/models/command_method_model.dart';
import 'package:cli_gen/src/code/models/command_parameter_model.dart';
import 'package:code_builder/code_builder.dart' hide Expression;
import 'package:dart_style/dart_style.dart';

import 'types.dart';

/// Generates the call expression Code for `userMethod()` with all of its
/// arguments, analyzes the result, and returns the `InvocationExpression` AST
/// node.
InvocationExpression generateUserMethodCallExp({
  String methodName = 'userMethod',
  String paramName = 'message',
  TypeReference? paramType,
  String? defaultValueCode,
  String? computedDefaultValue,
  bool isRequired = true,
  bool isNamed = false,
  String? parser,
  bool isIterable = false,
}) {
  final builder = UserMethodCallBuilder();
  final callStatement = builder.buildInlineCallStatement(
    CommandMethodModel(
      methodRef: refer(methodName),
      docComments: null,
      annotations: [],
      returnType: TestTypes.void_,
      parameters: [
        CommandParameterModel(
          parser: parser != null ? refer(parser) : null,
          name: Reference(paramName),
          type: paramType ?? TestTypes.string,
          isRequired: isRequired,
          isNamed: isNamed,
          optionType: isIterable ? OptionType.multi : OptionType.single,
          annotations: [],
          computedDefaultValue: computedDefaultValue,
          docComments: null,
          availableOptions: [],
        ),
      ],
    ),
  );

  // Create a function to hold the callStatement (required for the analyzer
  // to parse the callStatement).
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

  final unit = _parseCode(function.closure.code);
  final funcDeclaration = unit.declarations.single as FunctionDeclaration;
  final funcBody = funcDeclaration.functionExpression.body as BlockFunctionBody;
  final statement = funcBody.block.statements.single as ReturnStatement;
  return statement.expression as InvocationExpression;
}

/// Generates the call expression Code for `ArgParser()..addOption()`, analyzes
/// the result, and returns a list of unresolved Expression AST nodes that
/// represent the arguments of the `addOption` call.
List<Expression> generateOptionArguments({
  String paramName = 'message',
  TypeReference? type,
  bool isRequired = true,
  bool isNamed = false,
  String? defaultValue,
  String? computedDefaultValue,
  String? docComment = 'The message to display.',
}) {
  final cascadeExp = generateArgParserCascaseExp(
    paramName: paramName,
    type: type,
    defaultValueCode: defaultValue,
    computedDefaultValue: computedDefaultValue,
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
  String? computedDefaultValue,
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
    type: type,
    isRequired: isRequired,
    isNamed: isNamed,
    optionType: optionType,
    availableOptions: availableOptions,
  );
  final codeExpression = builder.generateArgOption(argParserExp, parameter);

  final unit = _parseCode(codeExpression.statement);
  final variable = unit.declarations.single as TopLevelVariableDeclaration;
  return variable.variables.variables.single.initializer as CascadeExpression;
}

/// Converts a [Code] object into a [CompilationUnit] object.
///
/// NOTE: The returned [CompilationUnit] is not resolved.
CompilationUnit _parseCode(Code code) {
  final emitter = DartEmitter(useNullSafetySyntax: true);
  final content = code.accept(emitter).toString();
  final formatter = DartFormatter();
  final formattedContent = formatter.format(content);
  return parseString(content: formattedContent).unit;
}
