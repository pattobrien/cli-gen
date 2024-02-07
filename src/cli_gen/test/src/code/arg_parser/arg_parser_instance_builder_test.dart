import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:checks/checks.dart';
import 'package:cli_gen/src/code/arg_parser/arg_parser_instance_builder.dart';
import 'package:cli_gen/src/code/models/command_parameter_model.dart';
import 'package:code_builder/code_builder.dart'
    show CodeExpression, Code, Reference, TypeReference, DartEmitter;
import 'package:test/test.dart';

void main() {
  test('arg parser instance builder ...', () async {
    final builder = ArgParserInstanceExp();

    final argParserExp = CodeExpression(Code('final x = ArgParser()'));
    final parameter = CommandParameterModel(
      name: Reference('message'),
      docComments: 'The message to display.',
      type: Reference('String', 'dart:core').type as TypeReference,
      isRequired: true,
      isNamed: false,
    );
    final codeExpression = builder.generateArgOption(argParserExp, parameter);

    final analyzedResult = parseString(
      content: codeExpression.statement.accept(DartEmitter()).toString(),
    );
    final variable =
        analyzedResult.unit.declarations.single as TopLevelVariableDeclaration;

    final expression = variable.variables.variables.single.initializer;

    check(expression)
        .isA<CascadeExpression>()
        .has((p0) => p0.cascadeSections.first, 'cascade section')
        .isA<MethodInvocation>()
      ..has((p0) => p0.methodName.name, 'method name').equals('addOption')
      ..has((p0) => p0.argumentList.arguments.map((e) => e.toSource()),
              'arguments')
          .unorderedEquals([
        "'message'",
        "mandatory: true",
        "valueHelp: 'property'",
        "help: 'The message to display.'",
      ]);
  });
}
