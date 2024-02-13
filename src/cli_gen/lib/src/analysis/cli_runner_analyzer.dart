import 'package:analyzer/dart/element/element.dart';

import '../code/models/runner_model.dart';
import '../code/utils/remove_doc_slashes.dart';
import 'cli_command_analyzer.dart';

class CliRunnerAnalyzer {
  const CliRunnerAnalyzer();

  RunnerModel fromClassElement(
    ClassElement element,
  ) {
    const commandMethodAnalyzer = CliCommandAnalyzer();

    return RunnerModel(
      subcommands: element.methods
          .where(commandMethodAnalyzer.isAnnotatedWithCliCommand)
          .map(commandMethodAnalyzer.fromExecutableElement)
          .toList(),
      docComments: removeDocSlashes(element.documentationComment),
      name: element.name,
    );
  }
}
