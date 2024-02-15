import 'package:analyzer/dart/ast/ast.dart';
import 'package:code_builder/code_builder.dart';

import '../../code/models/runner_model.dart';
import '../annotations/command_annotation_analyzer.dart';
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
    const commandAnnotationAnalyzer = CommandAnnotationAnalyzer();

    return RunnerModel(
      annotations: commandAnnotationAnalyzer.annotationsForElement(element),
      mountedSubcommands: [...element.accessors, ...element.methods]
          .where(commandMethodAnalyzer.isAnnotatedWithSubcommandMount)
          .map((e) => e.toRef())
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
