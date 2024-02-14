import 'package:analyzer/dart/ast/ast.dart';
// ignore: implementation_imports
import 'package:analyzer/src/dart/ast/utilities.dart';
import 'package:code_builder/code_builder.dart';

import '../../code/models/command_method_model.dart';
import '../../code/models/subcommand_model.dart';
import '../utils/remove_doc_slashes.dart';
import 'cli_command_analyzer.dart';

class CliSubcommandAnalyzer {
  const CliSubcommandAnalyzer();

  SubcommandModel fromClassElement(
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
    return SubcommandModel(
      mountedSubcommands: [...element.accessors, ...element.methods]
          .where(commandMethodAnalyzer.isAnnotatedWithSubcommandMount)
          .map((e) => refer(e.name, e.librarySource.uri.toString()))
          .toList(),
      commandMethods: commandMethods,
      docComments: removeDocSlashes(element.documentationComment),
      userClassName: element.name,
    );
  }
}
