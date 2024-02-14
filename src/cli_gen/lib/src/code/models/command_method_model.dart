import 'package:code_builder/code_builder.dart';
import 'package:recase/recase.dart';

import 'annotation_model.dart';
import 'command_parameter_model.dart';

class CommandMethodModel {
  const CommandMethodModel({
    required this.methodRef,
    required this.docComments,
    required this.annotations,
    required this.parameters,
    required this.returnType,
  });

  final Reference methodRef;
  final String? docComments;
  final List<AnnotationModel> annotations;
  final List<CommandParameterModel> parameters;
  final TypeReference returnType;

  bool get isAsync => returnType.isAsync;

  String get userMethodName => methodRef.symbol!;

  /// The name of the Command class that will be generated for this method.
  ///
  /// e.g. `myCommand` -> `MyCommand`
  ///
  /// The following logic will apply:
  /// - convert the method name to `PascalCase`
  /// - append the suffix `Command`, unless the method name already ends with
  ///   `Command`
  String get generatedCommandClassName {
    return userMethodName.endsWith('Command')
        ? userMethodName.pascalCase
        : '${userMethodName.pascalCase}Command';
  }
}

extension IsAsync on Reference {
  bool get isAsync => isFuture || isFutureOr;

  bool get isFuture => symbol == 'Future';

  bool get isFutureOr => symbol == 'FutureOr';
}
