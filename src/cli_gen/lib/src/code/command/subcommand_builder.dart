import 'package:code_builder/code_builder.dart';
import 'package:recase/recase.dart';

import '../../types/identifiers.dart';
import '../models/subcommand_model.dart';
import 'command_builder.dart';

class SubcommandBuilder {
  const SubcommandBuilder();

  Iterable<Class> buildSubcommandAndNestedCommands(
    SubcommandModel model,
  ) {
    const commandBuilder = CommandBuilder();
    final subcommandClass = buildSubcommandClass(model);

    final subcommands = model.subcommands.map((e) {
      return commandBuilder.buildCommandClass(e);
    });

    return [subcommandClass, ...subcommands];
  }

  Class buildSubcommandClass(SubcommandModel model) {
    return Class((builder) {
      builder.name = '_\$${model.name}';
      builder.extend = Identifiers.args.command;

      builder.constructors.add(Constructor((constructor) {
        // TODO: Add constructor parameters from user-defined @cliSubcommand class

        constructor.body = Block((block) {
          block.statements.addAll(
              model.subcommands.map((e) => Identifiers.args.addSubcommand.call([
                    refer('${e.methodRef.symbol!.pascalCase}Command',
                            e.methodRef.url)
                        .call([]),
                  ]).statement));
        });
      }));

      builder.methods.addAll([
        // -- Command name getter --
        Method((builder) {
          builder.name = 'name';
          builder.returns = Identifiers.dart.string;
          builder.body = literalString(model.name).code;
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
      ]);
    });
  }
}
