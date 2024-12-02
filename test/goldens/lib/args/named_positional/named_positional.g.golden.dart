// **************************************************************************
// CliRunnerGenerator
// **************************************************************************

/// A class for invoking [Command]s based on raw command-line arguments.
///
/// The type argument `T` represents the type returned by [Command.run] and
/// [CommandRunner.run]; it can be ommitted if you're not using the return
/// values.
class _$NamedPositional<T extends dynamic> extends CommandRunner<dynamic> {
  _$NamedPositional()
      : super(
          'named-positional',
          '',
        ) {
    final upcastedType = (this as NamedPositional);
    addCommand(PositionalCommand(upcastedType.positional));
    addCommand(NamedCommand(upcastedType.named));
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

class PositionalCommand extends Command<void> {
  PositionalCommand(this.userMethod) {
    argParser
      ..addOption(
        'req-value',
        mandatory: true,
      )
      ..addOption(
        'opt-value',
        mandatory: false,
      )
      ..addOption(
        'def-value',
        defaultsTo: 'default',
        mandatory: false,
      );
  }

  final void Function(
    String, [
    String?,
    String,
  ]) userMethod;

  @override
  String get name => 'positional';

  @override
  String get description => '';

  @override
  void run() {
    final results = argResults!;
    var [
      String reqValue,
      String? optValue,
      String? defValue,
    ] = results.rest;
    return userMethod(
      reqValue,
      optValue != null ? optValue : null,
      defValue != null ? defValue : 'default',
    );
  }
}

class NamedCommand extends Command<void> {
  NamedCommand(this.userMethod) {
    argParser
      ..addOption(
        'req-value',
        mandatory: true,
      )
      ..addOption(
        'opt-value',
        mandatory: false,
      )
      ..addOption(
        'def-value',
        defaultsTo: 'default',
        mandatory: false,
      );
  }

  final void Function({
    required String reqValue,
    String? optValue,
    String defValue,
  }) userMethod;

  @override
  String get name => 'named';

  @override
  String get description => '';

  @override
  void run() {
    final results = argResults!;
    return userMethod(
      reqValue: results['req-value'],
      optValue: (results['opt-value'] as String?) ?? null,
      defValue: (results['def-value'] as String?) ?? 'default',
    );
  }
}
