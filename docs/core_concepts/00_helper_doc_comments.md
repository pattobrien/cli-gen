NOTES:

- todo: explain use case when users don't know what commands/args to use, they use `--help` to get a list of available commands/args.
- `cli_gen` copies doc comments made on the Dart classes, and uses them to output help text to the user.
  - TODO: only output the first line (until the line break).
- NOTE: the Dart language recommends against doc comments on parameters; therefore, `cli_gen` does not support such an extraction on individual parameters
  - you could either use a `@Option()` annotation to add the `help` text (NOTE: show example below) OR
  - you could create a `@CliArgs()` class and document the fields instead of the parameters.
