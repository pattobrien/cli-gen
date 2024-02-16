// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'runner.dart';

// **************************************************************************
// SubcommandGenerator
// **************************************************************************

class _$BarCommand<T extends dynamic> extends Command<dynamic> {
  _$BarCommand();

  @override
  String get name => 'bar';

  @override
  String get description => '';
}

// **************************************************************************
// CliRunnerGenerator
// **************************************************************************

/// A class for invoking [Command]s based on raw command-line arguments.
///
/// The type argument `T` represents the type returned by [Command.run] and
/// [CommandRunner.run]; it can be ommitted if you're not using the return
/// values.
class _$FooBarRunner<T extends dynamic> extends CommandRunner<dynamic> {
  _$FooBarRunner()
      : super(
          'foo-bar',
          '',
        ) {
    final upcastedType = (this as FooBarRunner);
    addCommand(FooCommand(upcastedType.foo));
    addCommand(upcastedType.bar);
  }

  @override
  Future<dynamic> runCommand(ArgResults topLevelResults) async {
    try {
      return await super.runCommand(topLevelResults);
    } on UsageException catch (e) {
      stdout.writeln('${e.message}\n');
      stdout.writeln(e.usage);
    }
  }
}

class FooCommand extends Command<void> {
  FooCommand(this.userMethod);

  final void Function() userMethod;

  @override
  String get name => 'foo';

  @override
  String get description => '';

  @override
  void run() {
    return userMethod();
  }
}
