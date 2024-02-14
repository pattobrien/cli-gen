import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';

import '../code/models/runner_model.dart';
import 'cli_command_analyzer.dart';
import 'utils/remove_doc_slashes.dart';

class CliRunnerAnalyzer {
  const CliRunnerAnalyzer();

  /// Extracts ClassElement info required to build the CommandRunner into a [RunnerModel].
  RunnerModel fromClassElement(
    ClassElement element,
  ) {
    const commandMethodAnalyzer = CliCommandAnalyzer();

    return RunnerModel(
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
    );
  }
}
