# cli-gen

A package for building cli applications using code-gen.

<table>
<tr>
<th>Before</th>
<th>After</th>
</tr>
<tr>
<td valign="top">

```dart
/// A command-line interface for version control.
class GitRunner extends CommandRunner<void> {
  GitRunner()
      : super(
          'git',
          'A command-line interface for version control.',
        ) {
    addCommand(CommitCommand());
  }
}

/// Record changes to the repository.
class CommitCommand extends Command<void> {
  CommitCommand() {
    argParser.addOption(
      'message',
      help: 'Use the given message as the commit message.',
      abbr: 'm',
      mandatory: true,
    );
  }

  @override
  String get name => 'commit';

  @override
  String get description => 'Record changes to the repository.';

  @override
  Future<void> run() {
    final message = argResults?['message'];
    if (message == null) {
      throw ArgumentError(
        'Commit requires a message.',
      );
    }
    await Process.run('git', ['clone', '-m', message]);
  }
}
```

</td>
<td valign="top">

```dart
/// A command-line interface for version control.
@cliRunner
class GitRunner {
  /// Record changes to the repository.
  @cliCommand
  Future<void> commit(
    /// Use the given [message] as the commit message.
    String message,
  ) async {
    await Process.run('git', ['clone', '-m', message]);
  }
}
```

</td>
</tr>
</table>

### NOTES FOR EXAMPLE ABOVE

- can we add a non-String type that shows the type parsing ability?
- a parameter with a default value
- perhaps an enum that shows the `availableOptions` feature ?

## Features

### ArgParser generation from Parameters

- generate from a list of parameters from a Constructor or Method/Function
- supported types:
  - primatives: [list all params here]
  - enums for a finite list of values
  - extension types and custom types (annotations required for custom types?)
    - or feed a parser into the @Option() annotation?
- annotations to help guide the generator

###
