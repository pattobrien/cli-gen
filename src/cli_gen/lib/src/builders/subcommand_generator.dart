import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:cli_annotations/cli_annotations.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';

import '../analysis/cli_subcommand_analyzer.dart';
import '../code/command/subcommand_builder.dart';

class SubcommandGenerator extends GeneratorForAnnotation<CliSubcommand> {
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

    const subcommandAnalyzer = CliSubcommandAnalyzer();
    final model = subcommandAnalyzer.fromClassElement(element);

    final library = Library((builder) {
      const subcommandBuilder = SubcommandBuilder();
      builder.body.addAll(
        subcommandBuilder.buildSubcommandAndNestedCommands(model),
      );
    });

    final emitter = DartEmitter(useNullSafetySyntax: true);
    final formatter = DartFormatter();

    return formatter.format('${library.accept(emitter)}');
  }
}
