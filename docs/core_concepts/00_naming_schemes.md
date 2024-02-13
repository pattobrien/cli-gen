NOTES:

- by default, `cli_gen` translates Dart methods and classes to `hyphenated-lowercase` command and argument names.
- in addition to changing case, any classes or methods with a trailing `Command`, `Runner`, and/or `Subcommand` suffix will
  have that suffix removed for the command/argument name.
- to overwrite any of this behavior, you can manually enter the `name` of command/argument in the annotation, like so:

```dart
  ...
  @CliCommand(name: 'commit')
  void commitChanges() {
    // ...
  }
  ...
```
