import 'package:code_builder/code_builder.dart';

import '../../analysis/utils/reference_ext.dart';
import '../../types/identifiers.dart';
import '../models/runner_model.dart';
import 'command_builder.dart';
import 'subcommand_constructor_body_builder.dart';

/// Builds the CommandRunner and Commands defined in a `@cliRunner` class.
///
/// See [buildRunnerClass] for more details.
class RunnerBuilder {
  const RunnerBuilder();

  /// Builds the CommandRunner class and all `@cliCommand` methods.
  ///
  /// See [buildRunnerClass] and [CommandBuilder.buildCommandClass] for more
  /// details.
  Iterable<Class> buildRunnerClassAndUserMethods(
    RunnerModel model,
  ) {
    const commandBuilder = CommandBuilder();
    final commandRunnerClass = buildRunnerClass(model);

    final generatedCommandClasses = model.commandMethods.map((e) {
      return commandBuilder.buildCommandClass(e);
    });

    return [commandRunnerClass, ...generatedCommandClasses];
  }

  /// Builds the CommandRunner class.
  ///
  /// This class is responsible for three things:
  /// - mounting `@mount` subcommands or command methods in the user subclass
  /// - supplying the executable name and description to `CommandRunner`
  /// - TODO: overriding the `run()` method to provide custom error handling
  Class buildRunnerClass(RunnerModel model) {
    return Class((builder) {
      builder.name = model.generatedClassName;
      builder.extend = Identifiers.args.commandRunner.toTypeRef(
        typeArguments: [
          model.bound ?? Identifiers.dart.dynamic,
        ],
      );
      builder.types.add(TypeReference((builder) {
        builder.bound = Identifiers.dart.dynamic;
        builder.symbol = 'T';
      }));

      builder.constructors.add(
        Constructor((builder) {
          // -- super initializer --
          // e.g. `super('executableName', 'executableDescription')`
          builder.initializers.add(
            refer('super').call([
              literalString(model.executableName),
              literalString(model.docComments ?? '')
            ]).code,
          );

          // -- the constructor body --
          // adds nested commands and `@mount` subcommands to the CommandRunner
          final bodyBuilder = SubcommandConstructorBodyBuilder();
          builder.body = bodyBuilder.buildSubcommandConstructorBody(model);
        }),
      );
    });
  }
}
