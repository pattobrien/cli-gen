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
class GitRunner {
  /// Join two or more development histories together.
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

### NOTES FOR EXAMPLE ABOVE

- [x] can we add a non-String type that shows the type parsing ability?
- [x] a parameter with a default value
- [x] perhaps an enum that shows the `availableOptions` feature ?

## Features

### ArgParser generation from Parameters

- Generate an ArgParser from a Constructor or Method/Function

  - `help` comments from doc comments
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

- annotations to help guide the generator

### Command generation
