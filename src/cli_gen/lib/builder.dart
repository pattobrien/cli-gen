import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/builders/runner_generator.dart';
import 'src/builders/subcommand_generator.dart';

SharedPartBuilder cliGenerator(BuilderOptions options) => SharedPartBuilder(
      [SubcommandGenerator(), CliRunnerGenerator()],
      'cli_generator',
    );
