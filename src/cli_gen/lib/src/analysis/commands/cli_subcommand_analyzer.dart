import 'package:analyzer/dart/ast/ast.dart';
import 'package:code_builder/code_builder.dart';

import '../../code/models/subcommand_model.dart';
import '../annotations/command_annotation_analyzer.dart';
import '../utils/reference_ext.dart';
import '../utils/remove_doc_slashes.dart';
import 'cli_command_analyzer.dart';

class CliSubcommandAnalyzer {
  const CliSubcommandAnalyzer();

  SubcommandModel fromClassElement(
    ClassDeclaration node,
  ) {
    final element = node.declaredElement!;
    const commandMethodAnalyzer = CliCommandAnalyzer();
    const commandAnnotationAnalyzer = CommandAnnotationAnalyzer();

    return SubcommandModel(
      annotations: commandAnnotationAnalyzer.annotationsForElement(element),
      mountedSubcommands: [...element.accessors, ...element.methods]
          .where(commandMethodAnalyzer.isAnnotatedWithSubcommandMount)
          .map((e) => refer(e.name, e.librarySource.uri.toString()))
          .toList(),
      commandMethods: element.methods
          .where(commandMethodAnalyzer.isAnnotatedWithCliCommand)
          .map(commandMethodAnalyzer.fromExecutableElement)
          .toList(),
      docComments: removeDocSlashes(element.documentationComment),
      userClassName: element.name,
      bound: getTypeBound(node),
    );
  }

  Reference? getTypeBound(ClassDeclaration node) {
    final superclass = node.extendsClause?.superclass;
    final bound = superclass?.typeArguments?.arguments.firstOrNull;
    return bound?.toTypeRef();
  }
}
