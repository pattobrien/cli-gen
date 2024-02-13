import 'package:analyzer/dart/element/element.dart';

import '../code/models/subcommand_model.dart';
import '../code/utils/remove_doc_slashes.dart';
import 'cli_command_analyzer.dart';

class CliSubcommandAnalyzer {
  const CliSubcommandAnalyzer();

  SubcommandModel fromClassElement(
    ClassElement element,
  ) {
    const commandMethodAnalyzer = CliCommandAnalyzer();

    return SubcommandModel(
      subcommands: element.methods
          .where(commandMethodAnalyzer.isAnnotatedWithCliCommand)
          .map(commandMethodAnalyzer.fromExecutableElement)
          .toList(),
      docComments: removeDocSlashes(element.documentationComment),
      name: element.name,
    );
  }
}
