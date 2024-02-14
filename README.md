# cli-gen

[![Build Pipeline](https://github.com/pattobrien/cli-gen/actions/workflows/packages.yml/badge.svg)](https://github.com/pattobrien/cli-gen/actions/workflows/packages.yml)
[![CodeCoverage](https://codecov.io/gh/pattobrien/cli-gen/branch/main/graph/badge.svg)](https://codecov.io/gh/pattobrien/cli-gen)
[![pub package](https://img.shields.io/pub/v/cli_annotations.svg)](https://pub.dartlang.org/packages/cli_annotations)

<blockquote>
  🚧 This package is in early preview and is subject to API changes.
</blockquote>

Build CLI applications from plain Dart classes and functions.

## Motivation

The ability to quickly whip up a command line script or application is a powerful skill for a developer to have. Unlike the Dart language itself, which offers a tremendous developer experience when building many kinds of apps, cli-based Dart libraries like `package:args` leave a lot to desire when it comes to getting up and running quickly, and being able to focus on building application logic instead of parsing and managing dynamic string data.

`cli-gen` aims to offer quality-of-life improvements for building and maintaining CLI apps, by allowing you to generate command line APIs from plain Dart functions. It does so by providing the following features:

- type-safe arguments via generated string parsing
- `help` text generation from param names, doc comments, and default values
- proper error handling, without printing stack traces to the console

`cli-gen` was designed to make writing CLI applications as intuitive as writing any other piece of Dart code, by abstracting away the underlying `package:args` semantics while providing access to the underlying details, if ever necessary.

<table>
<tr>
<th>Before</th>
<th>After</th>
</tr>
<tr>
<td valign="top">

<!--  screenshots are located in docs/before_and_after/screenshots/** (before.png and after.png) -->

[![Before](docs/before_and_after/screenshots/before.png)](docs/before_and_after/screenshots/before.png)

</td>
<td valign="top">

[![After](docs/before_and_after/screenshots/after.png)](docs/before_and_after/screenshots/after.png)

</td>
</tr>
</table>

## Table of Contents

- [Motivation](#motivation)
- [Quick Start](#quick-start)
- [Features](#features)
- [Under the Hood](#under-the-hood)
- [Design Goals](#design-goals)
- [Inspiration](#inspiration)
- [License](#license)

## Quick Start

1. Add `cli_annotations` to your `pubspec` dependencies and `cli_gen` and `build_runner` as dev dependencies.

   ```yaml
   name: dart_git
   description: An implementation of the git CLI in Dart.

   environment:
     sdk: ^3.0.0

   dependencies:
     cli_annotations: ^0.1.0-dev.1

   dev_dependencies:
    build_runner: ^2.4.8
     cli_gen: ^0.1.0-dev.1

   # define an executable name (optional)
   executables:
     dart_git:
       path: main # file name of `main()` in bin/ directory
   ```

   You can optionally define an executable name and activate it using [pub global activate](https://dart.dev/tools/pub/cmd/pub-global#activating-a-package-on-your-local-machine).

   Once dependencies are installed, start the `build_runner` to begin code generation.

   ```bash
    $ dart run build_runner watch -d
   ```

2. Create a `CommandRunner` by annotating a class with `@cliRunner` and extending the generated superclass (uses the typical `_$` prefix).

   The generated code contains a single `CommandRunner.run()` method, which is the entry point for your CLI application and will be called from the `main` function.

   ```dart
   @cliRunner
   class GitRunner extends _$GitRunner {
     // ...
   }
   ```

3. Create a `Command` by simply creating a method on the class. Any primative type or enum will be automatically parsed from incoming string arguments.

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

4. As your application grows, you'll begin to want to separate your commands into their own groups.

   You can create a `Subcommand` by annotating a class with `@cliSubcommand` and extending the generated superclass.

   ```dart
   // Create your subcommand
   @cliSubcommand
   class StashSubcommand extends _$StashSubcommand {
     @cliCommand
     Future<void> push() async { /* ... */ }

     @cliCommand
     Future<void> pop() async { /* ... */ }
   }

   // Then mount it to your `CommandRunner` or a parent `Subcommand`
   @cliRunner
   class GitRunner extends _$GitRunner {
     @mount
     Command get stash => StashSubcommand();
   }
   ```

5. Finally, create a `main` function that calls `run` on your `CommandRunner`.

   ```dart
   void main(List<String> arguments) async {
     final runner = GitRunner();
     await runner.run(arguments);
   }
   ```

Your application is ready to go! Run a command to test out the generated help text and see the argument parsing in action.

```bash
# activate the executable (if executable is defined in `pubspec.yaml`)
$ dart pub global activate . --source=path

# run the application
$ dart_git merge --help
```

You should see the following output:

```bash
$ dart_git merge --help
Join two or more development histories together.

Usage: git-runner merge [arguments]
--branch (mandatory)
--commit
--options

Run "git-runner help" to see global options.
```

## Under the Hood

`cli-gen` generates code that uses `package:args` classes and utilities to manage command hierarchies and help text generation. The annotations included with this package are a 1:1 mapping to similar or identical concepts included with `package:args`, for example:

- `@cliRunner`
  - generates a `CommandRunner` class
  - has a `run` method that should be passed args and run from your `main` function
  - mounts any nested commands as subcommands via `CommandRunner.addCommand`
- `@cliCommand`
  - generates a `Command` class
  - overrides the `run` method with a call to your method or function
- `@cliSubcommand`
  - generates a `Command` class
  - adds all nested commands as subcommands via `Command.addSubcommand`

Examples of generated code can be found in the `example` project, within their respective `.g.dart` files.

## Features

- [ ] Arg parser generation from Parameters

  - [ ] Generate from a Constructor or Method/Function signature
  - Auto Argument Parsing (convert a String/bool argument into the expected Dart type, without using annotations to tell the builder what parser to use):
    - [x] Primatives: String, int, double, bool, Uri, DateTime
    - [x] Collections: List, Set, Iterable
      - [ ] Map
    - [ ] User-Defined types:
      - [x] Enums
      - [ ] Classes
      - [ ] Extension Types
  - Multi-Select arguments

    - [ ] List of primative values
    - [ ] enums for a finite list of values

  - `help` comments from doc comments

- Annotations to guide the generator and override default behavior

  - [ ] `@cliCommand` to override the generated command name
  - [ ] `@cliSubcommand` to override the generated subcommand name
  - [ ] `@cliRunner` to override the generated runner name
  - [ ] `@mount` to mount a subcommand to a parent command
  - [ ] `@cliOption` to provide access to `package:args` options

- Command generation

  - [x] Generate a `Command` class using a `@cliCommand` Method or Function annotation
  - [x] Generate a `Subcommand` class using a `@cliSubcommand` Class annotation
  - [x] Generate a `CommandRunner` using a `@cliRunner` Class annotation
    - [x] Allow mounting nested subcommands using a `@mount` annotation on a Getter or Method

## Design Goals

TODO: write a little blurb about the goals (incl. what `cli-gen` is and what it is not).

## Inspiration

Several projects were researched as references of CLI ergonomics and macro libraries, including:

- [clap](https://docs.rs/clap/latest/clap/) - a declarative CLI parser for Rust

## License

`cli-gen` is released under the MIT License. See [LICENSE](LICENSE) for details.
