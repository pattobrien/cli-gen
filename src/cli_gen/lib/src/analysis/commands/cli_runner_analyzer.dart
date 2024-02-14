import 'package:analyzer/dart/ast/ast.dart';
// ignore: implementation_imports
import 'package:analyzer/src/dart/ast/utilities.dart';

import '../../code/models/command_method_model.dart';
import '../../code/models/runner_model.dart';
import '../utils/reference_ext.dart';
import '../utils/remove_doc_slashes.dart';
import 'cli_command_analyzer.dart';

class CliRunnerAnalyzer {
  const CliRunnerAnalyzer();

  /// Extracts ClassElement info required to build the CommandRunner into a [RunnerModel].
  RunnerModel fromClassElement(
    ClassDeclaration node,
  ) {
    final element = node.declaredElement!;
    const commandMethodAnalyzer = CliCommandAnalyzer();

    List<CommandMethodModel> commandMethods = [];

    for (final method in element.methods) {
      if (commandMethodAnalyzer.isAnnotatedWithCliCommand(method)) {
        final methodNode = NodeLocator(
          method.nameOffset,
          method.nameOffset + method.nameLength,
        ).searchWithin(node) as MethodDeclaration;
        commandMethods.add(
          commandMethodAnalyzer.fromMethodDeclaration(methodNode),
        );
      }
    }

    return RunnerModel(
      mountedSubcommands: [...element.accessors, ...element.methods]
          .where(commandMethodAnalyzer.isAnnotatedWithSubcommandMount)
          .map((e) => e.toRef())
          .toList(),
      commandMethods: commandMethods,
      docComments: removeDocSlashes(element.documentationComment),
      userClassName: element.name,
    );
  }
}
