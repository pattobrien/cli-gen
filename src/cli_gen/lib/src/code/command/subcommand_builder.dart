import 'package:code_builder/code_builder.dart';

import '../../types/identifiers.dart';
import '../models/subcommand_model.dart';
import 'command_builder.dart';
import 'subcommand_constructor_body_builder.dart';

class SubcommandBuilder {
  const SubcommandBuilder();

  /// Builds the Subcommand class and all user-defined `@cliCommand` methods.
  ///
  /// See [buildSubcommandClass] and [CommandBuilder.buildCommandClass] for more
  /// details.
  Iterable<Class> buildSubcommandAndNestedCommands(
    SubcommandModel model,
  ) {
    const commandBuilder = CommandBuilder();
    final subcommandClass = buildSubcommandClass(model);

    final subcommands = model.commandMethods.map((e) {
      return commandBuilder.buildCommandClass(e);
    });

    return [subcommandClass, ...subcommands];
  }

  /// Builds the Subcommand class.
  ///
  /// This class is responsible for generating the name and description getters,
  /// and the constructor body that adds nested commands and `@mount` subcommands
  /// (though most of that work is delegated to [SubcommandConstructorBodyBuilder]).
  Class buildSubcommandClass(SubcommandModel model) {
    return Class((builder) {
      builder.name = model.generatedClassName;
      builder.extend = Identifiers.args.command;
      // builder.extend = Identifiers.args.command.toTypeRef(
      //   typeArguments: [refer('T')],
      // );
      // builder.types.add(refer('T'));

      // -- class constructor --
      builder.constructors.add(
        Constructor((constructor) {
          constructor.body = Block((block) {
            final constructorBodyBuilder = SubcommandConstructorBodyBuilder();
            block.statements.add(
              constructorBodyBuilder.buildSubcommandConstructorBody(model),
            );
          });
        }),
      );

      builder.methods.addAll([
        // -- `String get name =>` implementation --
        Method((builder) {
          builder.name = 'name';
          builder.returns = Identifiers.dart.string;
          builder.body = literalString(model.executableName).code;
          builder.type = MethodType.getter;
          builder.annotations.add(Identifiers.dart.override);
        }),

        // -- `String get description =>` implementation --
        Method((builder) {
          builder.name = 'description';
          builder.returns = Identifiers.dart.string;
          builder.body = literalString(model.docComments ?? '').code;
          builder.type = MethodType.getter;
          builder.annotations.add(Identifiers.dart.override);
        }),
      ]);
    });
  }
}
