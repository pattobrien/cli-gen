import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:cli_annotations/cli_annotations.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';

import '../analysis/cli_runner_analyzer.dart';
import '../code/command/runner_builder.dart';

/// A [Generator] that generates `CommandRunner` classes.
class CliRunnerGenerator extends GeneratorForAnnotation<CliRunner> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'The `@CliSubcommand` annotation can only be used on classes.',
        element: element,
      );
    }
    // Creates a model from the annotated ClassElement.
    const subcommandAnalyzer = CliRunnerAnalyzer();
    final model = subcommandAnalyzer.fromClassElement(element);

    // Generates code from the model.
    final library = Library((builder) {
      const subcommandBuilder = RunnerBuilder();
      builder.body.addAll(
        subcommandBuilder.buildSubcommandAndNestedCommands(model),
      );
    });

    final emitter = DartEmitter(useNullSafetySyntax: true);
    final formatter = DartFormatter();

    return formatter.format('${library.accept(emitter)}');
  }
}
