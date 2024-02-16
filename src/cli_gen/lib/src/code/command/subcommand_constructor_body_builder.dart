import 'package:code_builder/code_builder.dart';

import '../../types/identifiers.dart';
import '../models/runner_model.dart';
import '../models/subcommand_model.dart';

class SubcommandConstructorBodyBuilder {
  const SubcommandConstructorBodyBuilder();

  Block buildSubcommandConstructorBody(
    SubcommandModel model, {
    bool isRunner = true,
  }) {
    final addCommandRef = switch (model) {
      RunnerModel() => Identifiers.args.addCommand,
      SubcommandModel() => Identifiers.args.addSubcommand,
    };
    return Block((block) {
      // -- upcastedType declaration --
      // an upcast to the user-defined class is required, so that we can
      // access any mounted Commands and @cliCommand methods, and pass
      // them to any generated `Command` or `Subcommand` constructors.
      block.addExpression(
        declareFinal('upcastedType').assign(
          refer('this').asA(refer(model.userClassName)),
        ),
      );

      // -- add `@cliCommand` methods via `addCommand()` --
      block.statements.addAll(
        model.commandMethods.map(
          (e) => addCommandRef.call([
            refer(e.generatedCommandClassName).call([
              refer('upcastedType').property(e.userMethodName),
            ])
          ]).statement,
        ),
      );

      // -- add `@mount` subcommands via `addCommand()` --
      block.statements.addAll(
        model.mountedSubcommands.map(
          (e) => addCommandRef.call([
            refer('upcastedType').property(e.symbol!),
          ]).statement,
        ),
      );
    });
  }
}
