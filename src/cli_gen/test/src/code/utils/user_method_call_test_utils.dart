import 'package:analyzer/dart/ast/ast.dart' hide Block;
import 'package:cli_gen/src/code/command/user_method_call_builder.dart';
import 'package:cli_gen/src/code/models/command_method_model.dart';
import 'package:cli_gen/src/code/models/command_parameter_model.dart';
import 'package:code_builder/code_builder.dart' as code;
import 'package:code_builder/code_builder.dart' hide Expression;

import 'common.dart';
import 'types.dart';

/// Generates the call expression Code for `userMethod()` with all of its
/// arguments, analyzes the result, and returns the `InvocationExpression` AST
/// node.
MethodInvocation generateUserMethodCallExp({
  String methodName = 'userMethod',
  String paramName = 'message',
  TypeReference? paramType,
  String? defaultValueCode,
  code.Expression? computedDefaultValue,
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
          defaultValueAsCode: defaultValueCode,
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

  final unit = codeToUnresolvedUnit(function.closure.code);
  final funcDeclaration = unit.declarations.single as FunctionDeclaration;
  final funcBody = funcDeclaration.functionExpression.body as BlockFunctionBody;
  final statement = funcBody.block.statements.single as ReturnStatement;
  return statement.expression as MethodInvocation;
}
