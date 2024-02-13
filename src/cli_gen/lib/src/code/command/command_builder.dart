import 'package:code_builder/code_builder.dart';
import 'package:recase/recase.dart';

import '../../types/identifiers.dart';
import '../models/command_method_model.dart';

class CommandBuilder {
  const CommandBuilder();

  Class buildCommandClass(CommandMethodModel model) {
    return Class((builder) {
      builder.name = model.methodRef.symbol!.pascalCase;
      builder.extend = Identifiers.args.command;

      // builder.constructors.add(Constructor((constructor) {
      //   constructor.body = Block((block) {
      //     block.statements.addAll(
      //       model.subcommands.map(
      //         (e) => refer('addSubcommand').call(
      //           [refer(e.methodRef.symbol!.pascalCase, e.methodRef.url)],
      //         ).statement,
      //       ),
      //     );
      //   });
      // }));

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
      ]);
    });
  }
}
