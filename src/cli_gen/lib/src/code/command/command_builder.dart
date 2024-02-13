import 'package:code_builder/code_builder.dart';
import 'package:recase/recase.dart';

import '../../types/identifiers.dart';
import '../arg_parser/arg_parser_instance_builder.dart';
import '../models/command_method_model.dart';
import 'cli_method_call_builder.dart';

class CommandBuilder {
  const CommandBuilder();

  Class buildCommandClass(CommandMethodModel model) {
    return Class((builder) {
      builder.name = '${model.methodRef.symbol!.pascalCase}Command';
      builder.extend = Identifiers.args.command;

      builder.constructors.add(Constructor((constructor) {
        constructor.requiredParameters.add(
          Parameter((builder) {
            builder.name = 'userMethod';
            builder.toThis = true;
          }),
        );
      }));

      builder.fields.add(Field((builder) {
        builder.name = 'userMethod';
        builder.modifier = FieldModifier.final$;
        builder.type = FunctionType((builder) {
          builder.returnType = model.returnType;
          final requiredNamedParams =
              model.parameters.where((e) => e.isNamed && e.isRequired).toList();
          final optionalNamedParams = model.parameters
              .where((e) => e.isNamed && !e.isRequired)
              .toList();
          final requiredPositionalParams = model.parameters
              .where((e) => !e.isNamed && e.isRequired)
              .toList();
          final optionalPositionalParams = model.parameters
              .where((e) => !e.isNamed && !e.isRequired)
              .toList();

          builder.requiredParameters.addAll(
            requiredPositionalParams.map(
              (e) => TypeReference((builder) {
                builder.symbol = e.type.symbol;
                builder.isNullable = e.type.isNullable;
              }),
            ),
          );

          builder.optionalParameters.addAll(
            optionalPositionalParams.map(
              (e) => TypeReference((builder) {
                builder.symbol = e.type.symbol;
                builder.isNullable = e.type.isNullable;
              }),
            ),
          );

          builder.namedParameters.addAll(
            Map.fromEntries(
              optionalNamedParams.map(
                (e) => MapEntry(
                  e.ref.symbol!,
                  TypeReference((builder) {
                    builder.symbol = e.type.symbol;
                    builder.isNullable = e.type.isNullable;
                  }),
                ),
              ),
            ),
          );

          builder.namedRequiredParameters.addAll(
            Map.fromEntries(
              requiredNamedParams.map(
                (e) => MapEntry(e.ref.symbol!, TypeReference((builder) {
                  builder.symbol = e.type.symbol;
                  builder.isNullable = e.type.isNullable;
                  builder.url = e.type.url;
                })),
              ),
            ),
          );
        });
      }));

      builder.methods.addAll([
        // -- Command name getter --
        Method((builder) {
          builder.name = 'name';
          builder.returns = Identifiers.dart.string;
          builder.body = literalString(model.methodRef.symbol!.paramCase).code;
          builder.type = MethodType.getter;
          builder.annotations.add(
            Identifiers.dart.override,
          );
        }),

        // -- Command description getter --
        Method((builder) {
          builder.name = 'description';
          builder.returns = Identifiers.dart.string;
          builder.body = literalString(model.docComments ?? '').code;
          builder.type = MethodType.getter;
          builder.annotations.add(
            Identifiers.dart.override,
          );
        }),

        // -- Command ArgParser getter --
        Method((builder) {
          builder.name = 'argParser';
          builder.returns = Identifiers.args.argParser;
          const argParserBuilder = ArgParserInstanceExp();
          builder.body =
              argParserBuilder.buildArgParserInstance(model.parameters).code;
          builder.type = MethodType.getter;
          builder.annotations.add(
            Identifiers.dart.override,
          );
        }),

        // -- Command run method --
        Method((builder) {
          builder.name = 'run';
          builder.returns = model.returnType;
          builder.annotations.add(
            Identifiers.dart.override,
          );
          const cliRunBuilder = CliMethodCallBuilder();
          builder.body = Block((builder) {
            builder.statements.addAll([
              // -- declare a `results` variable --
              declareFinal(
                'results',
              ).assign(refer('argResults')).nullChecked.statement,

              // -- call the user method --
              cliRunBuilder.buildInlineCallStatement(model),
            ]);
          });
        }),
      ]);
    });
  }
}
