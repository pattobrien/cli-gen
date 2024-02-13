import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/builders/subcommand_generator.dart';

SharedPartBuilder cliGenerator(BuilderOptions options) =>
    SharedPartBuilder([SubcommandGenerator()], 'cli_generator');
