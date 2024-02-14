import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';

import '../../code/models/command_method_model.dart';
import '../annotations/options_annotation_analyzer.dart';
import '../parameters/cli_parameter_analyzer.dart';
import '../utils/reference_ext.dart';
import '../utils/remove_doc_slashes.dart';

/// Extacts information from any executable element and creates a [CommandMethodModel].
///
/// see [CommandMethodModel] and [fromExecutableElement].
class CliCommandAnalyzer {
  const CliCommandAnalyzer();
  CliParameterAnalyzer get _parameterAnalyzer => const CliParameterAnalyzer();

  /// Checks if the given [element] is annotated with `@CliCommand`.
  bool isAnnotatedWithCliCommand(
    ExecutableElement element,
  ) {
    return element.metadata.any(
      (annotation) {
        final annotationType = annotation.computeConstantValue()!.type!;
        // ignore: deprecated_member_use
        return annotationType.name == 'CliCommand';
      },
    );
  }

  /// Checks if the given [element] is annotated with `@SubcommandMount`.
  bool isAnnotatedWithSubcommandMount(
    ExecutableElement element,
  ) {
    return element.metadata.any(
      (annotation) {
        final annotationType = annotation.computeConstantValue()!.type!;
        // ignore: deprecated_member_use
        return annotationType.name == 'SubcommandMount';
      },
    );
  }

  /// Extracts [CommandMethodModel]s from the parameters on the
  /// given ConstructorDeclaration [node].
  CommandMethodModel fromConstructorDeclaration(
    ConstructorDeclaration node,
  ) {
    final parameters = node.declaredElement!.parameters;
    final nodes = _parameterAnalyzer.fromParameterElements(parameters, node);
    return fromParameterAstNodes(nodes, node.declaredElement!);
  }

  /// Extracts [CommandMethodModel]s from the parameters on the
  /// given FunctionDeclaration [node].
  CommandMethodModel fromFunctionDeclaration(
    FunctionDeclaration node,
  ) {
    final parameters = node.declaredElement!.parameters;
    final nodes = _parameterAnalyzer.fromParameterElements(parameters, node);
    return fromParameterAstNodes(nodes, node.declaredElement!);
  }

  /// Extracts [CommandMethodModel]s from the parameters on the
  /// given MethodDeclaration [node].
  CommandMethodModel fromMethodDeclaration(
    MethodDeclaration node,
  ) {
    final parameters = node.declaredElement!.parameters;
    final nodes = _parameterAnalyzer.fromParameterElements(parameters, node);
    return fromParameterAstNodes(nodes, node.declaredElement!);
  }

  // /// Extracts the [CommandMethodModel] from the given [element].
  // ///
  // /// For the most part, this method delegates most of the work to
  // /// [CliParameterAnalyzer] and [OptionsAnnotationAnalyzer], which extract
  // /// the parameters and annotations, respectively.
  // Future<CommandMethodModel> fromExecutableElement(
  //   ExecutableElement element,
  //   Resolver resolver,
  // ) async {
  //   List<FormalParameter> nodes = [];
  //   for (final parameter in element.parameters) {
  //     final astNode = await resolver.astNodeFor(parameter, resolve: true);

  //     if (astNode is! FormalParameter) {
  //       throw InvalidGenerationSourceError(
  //         'The `@CliCommand` annotation can only be used on methods with parameters.',
  //         element: element,
  //       );
  //     }

  //     nodes.add(astNode);
  //   }

  //   return fromParameterAstNodes(nodes, element);

  //   // return CommandMethodModel(
  //   //   methodRef: element.toRef(),
  //   //   returnType: element.returnType.toRef().toTypeRef(),
  //   //   parameters: parameterAnalyzer.fromParameterAstNodes(nodes),
  //   //   docComments: removeDocSlashes(element.documentationComment),
  //   //   annotations: element.metadata
  //   //       .where(annotationAnalyzer.isOptionsAnnotation)
  //   //       .map(annotationAnalyzer.fromElementAnnotation)
  //   //       .toList(),
  //   // );
  // }

  CommandMethodModel fromParameterAstNodes(
    List<FormalParameter> nodes,
    ExecutableElement element,
  ) {
    const annotationAnalyzer = OptionsAnnotationAnalyzer();
    const parameterAnalyzer = CliParameterAnalyzer();

    return CommandMethodModel(
      methodRef: element.toRef(),
      returnType: element.returnType.toRef().toTypeRef(),
      parameters: parameterAnalyzer.fromParameterAstNodes(nodes),
      docComments: removeDocSlashes(element.documentationComment),
      annotations: element.metadata
          .where(annotationAnalyzer.isOptionsAnnotation)
          .map(annotationAnalyzer.fromElementAnnotation)
          .toList(),
    );
  }
}
