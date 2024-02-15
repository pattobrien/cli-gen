import 'package:code_builder/code_builder.dart';
import 'package:recase/recase.dart';

import 'command_annotation_model.dart';
import 'command_parameter_model.dart';

class CommandMethodModel {
  const CommandMethodModel({
    required this.methodRef,
    required String? docComments,
    required this.annotations,
    required this.parameters,
    required this.returnType,
  }) : _docComments = docComments;

  final Reference methodRef;

  final String? _docComments;

  final List<CommandAnnotationModel> annotations;

  final List<CommandParameterModel> parameters;

  final TypeReference returnType;

  bool get isAsync => returnType.isAsync;

  String get userMethodName => methodRef.symbol!;

  /// The name that will be used for the `get name` getter.
  String get executableName =>
      (annotations.map((e) => e.name).firstOrNull ?? userMethodName).paramCase;

  /// The name of the Command class that will be generated for this method.
  ///
  /// e.g. `myCommand` -> `MyCommand`
  ///
  /// The following logic will apply:
  /// - if the user explicitly provided a name via an annotation, use that
  ///   otherwise use the method name; then apply the following:
  ///   - convert the method name to `PascalCase`
  ///   - append the suffix `Command`, unless the method name already ends with
  ///    `Command`
  String get generatedCommandClassName {
    final name = annotations.map((e) => e.name).firstOrNull ?? userMethodName;
    return name.endsWith('Command')
        ? name.pascalCase
        : '${name.pascalCase}Command';
  }

  /// The description of the Command.
  ///
  /// If a description is not provided via an annotation, the doc comments of the
  /// method will be used.
  String? get docComments =>
      annotations.map((e) => e.description).firstOrNull ?? _docComments;

  String? get category => annotations.map((e) => e.category).firstOrNull;
}

extension IsAsync on Reference {
  bool get isAsync => isFuture || isFutureOr;

  bool get isFuture => symbol == 'Future';

  bool get isFutureOr => symbol == 'FutureOr';
}
