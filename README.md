# cli-gen

A package for building cli applications using code generation and macros.

<table>
<tr>
<th>Before</th>
<th>After</th>
</tr>
<tr>
<td valign="top">

```dart
/// A dart implementation of distributed version control.
class GitRunner extends CommandRunner<void> {
  GitRunner()
      : super(
          'git',
          'A dart implementation of distributed version control.',
        ) {
    addCommand(MergeCommand());
  }
}

/// Join two or more development histories together.
class MergeCommand extends Command<void> {
  MergeCommand() {
    argParser.addOption(
      'branch',
      abbr: 'b',
      mandatory: true,
      valueHelp: 'branch',
      help: 'The name of the branch to be merged into the current branch.',
    );
    argParser.addOption(
      'strategy',
      abbr: 's',
      defaultsTo: 'ort',
      allowed: [
        'ort',
        'recursive',
        'resolve',
        'octopus',
        'ours',
        'subtree',
      ],
      help: 'Pass strategy specific option through to the merge strategy.',
    );
    argParser.addFlag(
      'commit',
      abbr: 'c',
      negatable: true,
      help: 'Perform the merge and commit the result.',
    );
  }

  @override
  String get name => 'merge';

  @override
  String get description => 'Join two or more development histories together.';

  @override
  Future<void> run() {
    final branch = argResults?['branch'];
    if (branch == null) {
      throw ArgumentError(
        'Merge requires a branch.',
      );
    }
    final strategy = argResults?['strategy'];
    final parsedStrategy = strategy == null
        ? MergeStrategy.ort
        : MergeStrategy.values.firstWhere((e) => e.name == strategy);
    final commit = argResults?['commit'];
    if (branch is! bool?) {
      throw ArgumentError(
        'Commit must be a boolean.',
      );
    }

    // ... application logic here ...
  }
}


```

</td>
<td valign="top">

```dart
/// A command-line interface for version control.
@cliRunner
class GitRunner extends _$GitRunner {

  @mount
  Command get stash => StashSubcommand();

  /// Join two or more development histories together.
  @cliCommand
  Future<void> merge({
    /// The name of the branch to be merged into the current branch.
    required String branch,

    /// Pass merge strategy specific option through to the merge strategy.
    MergeStrategy strategy = MergeStrategy.ort,

    /// Perform the merge and commit the result.
    bool? commit,
  }) async {
    // ... application logic ...
  }
}

enum MergeStrategy { ort, recursive, resolve, octopus, ours, subtree }

```

</td>
</tr>
</table>

## Getting Started

1. Create a `CommandRunner` by annotating a class with `@cliRunner` and extending the generated superclass (uses the typical `_$` prefix).

```dart
@cliRunner
class GitRunner extends _$GitRunner {
  // ...
}
```

2. Create a `Command` by simply creating a method on the class. Any parameter type will be automatically parsed from string arguments.

```dart
@cliRunner
class GitRunner extends _$GitRunner {
  @cliCommand
  Future<void> merge({
    required String branch,
    MergeStrategy strategy = MergeStrategy.ort,
    bool? commit,
  }) async {
    // ... application logic ...
  }
}
```

3. Alternatively, you can create a `Subcommand` by annotating a class with `@cliSubcommand` and extending the generated superclass.

```dart
// Create a Subcommand
@cliSubcommand
class StashSubcommand extends _$StashSubcommand {
  @cliCommand
  Future<void> push() async {
    // ... push application logic ...
  }

  @cliCommand
  Future<void> pop() async {
    // ... pop application logic ...
  }
}

// Then mount it to the main `CommandRunner` or a parent `Subcommand`.
@cliRunner
class GitRunner extends _$GitRunner {
  @mount
  Command get stash => StashSubcommand();
}
```

That's all there is to it!

## How it Works

`cli-gen` uses `package:args` under the hood to manage argument parsing, command hierarchies, and help text generation. The annotations included with this package are roughly a 1:1 mapping to their `package:args` equivalents, for example:

- `@cliRunner` generates a `CommandRunner` class
- `@cliCommand` generates a `Command` class and overrides the `run` method with a call to your method or function
- `@cliSubcommand` generates a `Command` class and adds all nested commands as subcommands

Examples of the generated code can be found in the `example` project, within their respective `.g.dart` files.

## Features

### ArgParser generation from Parameters

- Generate an ArgParser from a Constructor or Method/Function

  - Auto Argument Parsing (convert a String/bool argument into the expected Dart type, without using annotations to tell the builder what parser to use):
    - [x] Primatives:
      - [x] String
      - [x] int
      - [x] double
      - [x] bool
      - [x] Uri
      - [x] DateTime
    - [x] Collections:
      - [x] List
      - [x] Set
      - [x] Iterable
      - [ ] Map
    - [ ] User-Defined types:
      - [x] Enums
      - [ ] Classes
      - [ ] Extension Types
  - Multi-Select arguments

    - [ ] List of primative values
    - [ ] enums for a finite list of values

  - `help` comments from doc comments

- annotations to help guide the generator

### Command generation

- [x] Generate a `Command` class using a `@cliCommand` annotation on a method or function
- [x] Generate a `Subcommand` class using a `@cliSubcommand` annotation
- [x] Generate a `CommandRunner` using a `@cliRunner` annotation
  - [x] Allow mounting nested subcommands using a `@mount` annotation
