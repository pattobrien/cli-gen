import 'package:code_builder/code_builder.dart';
import 'package:recase/recase.dart';

import '../../types/identifiers.dart';
import '../models/runner_model.dart';
import 'command_builder.dart';

class RunnerBuilder {
  const RunnerBuilder();

  Iterable<Class> buildSubcommandAndNestedCommands(
    RunnerModel model,
  ) {
    const commandBuilder = CommandBuilder();
    final subcommandClass = buildSubcommandClass(model);

    final subcommands = model.subcommands.map((e) {
      return commandBuilder.buildCommandClass(e);
    });

    return [subcommandClass, ...subcommands];
  }

  Class buildSubcommandClass(RunnerModel model) {
    return Class((builder) {
      builder.name = '_\$${model.name}';
      builder.extend = Identifiers.args.commandRunner;

      builder.constructors.add(Constructor((constructor) {
        // TODO: Add constructor parameters from user-defined @cliSubcommand class

        constructor.initializers.add(
          CodeExpression(
            refer('super').call([
              literalString(model.name.paramCase),
              literalString(model.docComments ?? '')
            ]).code,
          ).code,
        );

        // -- add subcommands
        constructor.body = Block((block) {
          block.addExpression(declareFinal('upcastedType').assign(
            refer('this').asA(refer(model.name)),
          ));
          block.statements.addAll(
            model.subcommands.map(
              (e) => Identifiers.args.addCommand.call(
                [
                  refer('${e.methodRef.symbol!.pascalCase}Command').call([
                    refer('upcastedType')
                        .property(e.methodRef.symbol!.camelCase),
                  ])
                ],
              ).statement,
            ),
          );

          // -- mounted subcommands --
          block.statements.addAll(
            model.mountedSubcommands.map(
              (e) => Identifiers.args.addCommand.call(
                [
                  refer('upcastedType').property(e.symbol!),
                ],
              ).statement,
            ),
          );
        });
      }));
    });
  }
}
