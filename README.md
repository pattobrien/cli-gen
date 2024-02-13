# cli-gen

A package for building cli applications using code generation and macros.

## Table of Contents

- [Introduction](#introduction)
- [Getting Started](#getting-started)
- [Features](#features)
- [License](#license)

<table>
<tr>
<th>Before</th>
<th>After</th>
</tr>
<tr>
<td valign="top">

```dart

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
    required String branch,
    MergeStrategy strategy = MergeStrategy.ort,
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

1. Add `cli_annotations` to your `pubspec` dependencies and `cli_gen` and `build_runner` as dev dependencies.

   Optionally, you can define an executable name and activate it using [pub global activate](https://dart.dev/tools/pub/cmd/pub-global#activating-a-package-on-your-local-machine).

```yaml
dependencies:
  cli_annotations: ^0.0.1

dev_dependencies:
  build_runner: ^2.1.0
  cli_gen: ^0.0.1

# define an executable name (optional)
executables:
  dart_cli:
    path: main # file name of `main()` in bin/ directory
```

2. Create a `CommandRunner` by annotating a class with `@cliRunner` and extending the generated superclass (uses the typical `_$` prefix).

```dart
@cliRunner
class GitRunner extends _$GitRunner {
  // ...
}
```

3. Create a `Command` by simply creating a method on the class. Any parameter type will be automatically parsed from string arguments.

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

4. Alternatively, you can create a `Subcommand` by annotating a class with `@cliSubcommand` and extending the generated superclass.

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

5. Create a `main` function that runs the `CommandRunner`.

```dart
void main(List<String> arguments) async {
  final runner = GitRunner();
  await runner.run(arguments);
}
```

You're ready to go! Run your application via the command line and see the generated help text and argument parsing in action.

```bash
# activate the executable (if defined in `pubspec.yaml`)
$ dart pub global activate . --source=path

# run the application
$ dart_git merge --help
```

You should see the following output:

```plaintext
$ dart_git merge --help
Join two or more development histories together.

Usage: git-runner merge [arguments]
--branch (mandatory)
--commit
--options

Run "git-runner help" to see global options.

```

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

## License

`cli-gen` is released under the MIT License. See [LICENSE](LICENSE) for details.
