import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';

import '../code/models/subcommand_model.dart';
import 'cli_command_analyzer.dart';
import 'utils/remove_doc_slashes.dart';

class CliSubcommandAnalyzer {
  const CliSubcommandAnalyzer();

  SubcommandModel fromClassElement(
    ClassElement element,
  ) {
    const commandMethodAnalyzer = CliCommandAnalyzer();

    return SubcommandModel(
      mountedSubcommands: [...element.accessors, ...element.methods]
          .where(commandMethodAnalyzer.isAnnotatedWithSubcommandMount)
          .map((e) => refer(e.name, e.librarySource.uri.toString()))
          .toList(),
      subcommands: element.methods
          .where(commandMethodAnalyzer.isAnnotatedWithCliCommand)
          .map(commandMethodAnalyzer.fromExecutableElement)
          .toList(),
      docComments: removeDocSlashes(element.documentationComment),
      name: element.name,
    );
  }
}
