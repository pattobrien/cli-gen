import 'package:code_builder/code_builder.dart';

import '../../analysis/utils/reference_ext.dart';
import '../../types/identifiers.dart';
import '../arg_parser/arg_parser_instance_builder.dart';
import '../models/command_method_model.dart';
import 'user_method_call_builder.dart';

/// Builds the `Command` class for a user method annotated with `@cliCommand`.
///
/// [buildCommandClass] generates the implementation of the `name`, `description`,
/// and `argParser` getters, and constructs a `run` method that parses the
/// argument strings into the types required to call the user's method.
class CommandBuilder {
  const CommandBuilder();

  Class buildCommandClass(CommandMethodModel model) {
    return Class((builder) {
      builder.name = model.generatedCommandClassName;
      final nonAsyncReturnType = model.isAsync
          ? model.returnType.types.singleOrNull
          : model.returnType;
      builder.extend = Identifiers.args.command.toTypeRef(
        typeArguments: [
          if (nonAsyncReturnType != null) nonAsyncReturnType,
        ],
      );

      // -- unnamed constructor --
      builder.constructors.add(
        Constructor((builder) {
          builder.requiredParameters.add(
            Parameter((builder) {
              builder.name = 'userMethod';
              builder.toThis = true;
            }),
          );

          const argParserBuilder = ArgParserInstanceExp();
          builder.body = argParserBuilder
              .buildArgParserCascadeFromRef(model.parameters)
              .statement;
        }),
      );

      // -- create the userMethod callback field --
      // an example of a generated callback field:
      // `final void Function({required String branch, bool? commit}) userMethod;`

      builder.fields.add(Field((builder) {
        builder.name = 'userMethod';
        builder.modifier = FieldModifier.final$;

        builder.type = FunctionType((builder) {
          final requiredPositionalParams =
              model.parameters.where((e) => !e.isNamed && e.isRequired);
          builder.requiredParameters.addAll(
            requiredPositionalParams.map((e) => e.type),
          );

          final optionalPositionalParams =
              model.parameters.where((e) => !e.isNamed && !e.isRequired);
          builder.optionalParameters.addAll(
            optionalPositionalParams.map((e) => e.type),
          );

          final optionalNamedParams =
              model.parameters.where((e) => e.isNamed && !e.isRequired);
          builder.namedParameters.addAll(
            Map<String, TypeReference>.fromEntries(
              optionalNamedParams.map((e) => MapEntry(e.name.symbol!, e.type)),
            ),
          );

          final requiredNamedParams =
              model.parameters.where((e) => e.isNamed && e.isRequired).toList();
          builder.namedRequiredParameters.addAll(
            Map<String, TypeReference>.fromEntries(
              requiredNamedParams.map((e) => MapEntry(e.name.symbol!, e.type)),
            ),
          );
        });
      }));

      builder.methods.addAll([
        // -- Command name getter --
        // `String get name => 'commit';`
        Method((builder) {
          builder.name = 'name';
          builder.returns = Identifiers.dart.string;
          builder.body = literalString(model.executableName).code;
          builder.type = MethodType.getter;
          builder.annotations.add(
            Identifiers.dart.override,
          );
        }),

        // -- Command description getter --
        // `String get description => 'Commits the current changes';`
        Method((builder) {
          builder.name = 'description';
          builder.returns = Identifiers.dart.string;
          builder.body = literalString(model.docComments ?? '').code;
          builder.type = MethodType.getter;
          builder.annotations.add(Identifiers.dart.override);
        }),

        // -- Command category getter --
        // `String get category => 'Git';`
        if (model.category != null)
          Method((builder) {
            builder.name = 'category';
            builder.returns = Identifiers.dart.string;
            builder.body = literalString(model.category!).code;
            builder.type = MethodType.getter;
            builder.annotations.add(Identifiers.dart.override);
          }),

        // -- Command.run() overriden method --
        Method((builder) {
          builder.name = 'run';
          builder.returns = model.returnType;
          builder.annotations.add(Identifiers.dart.override);

          builder.body = Block((builder) {
            final userMethodCallBuilder = UserMethodCallBuilder();

            builder.statements.addAll([
              // -- declare a `results` variable --
              if (model.parameters.isNotEmpty)
                declareFinal('results')
                    .assign(refer('argResults'))
                    .nullChecked
                    .statement,

              // -- call the user method --
              userMethodCallBuilder.buildInlineCallStatement(model),
            ]);
          });
        }),
      ]);
    });
  }
}
