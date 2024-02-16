// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_select.dart';

// **************************************************************************
// CliRunnerGenerator
// **************************************************************************

/// A class for invoking [Command]s based on raw command-line arguments.
///
/// The type argument `T` represents the type returned by [Command.run] and
/// [CommandRunner.run]; it can be ommitted if you're not using the return
/// values.
class _$MultiSelect<T extends dynamic> extends CommandRunner<dynamic> {
  _$MultiSelect()
      : super(
          'multi-select',
          '',
        );

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

class DefaultValuesCommand extends Command<void> {
  DefaultValuesCommand(this.userMethod) {
    argParser
      ..addMultiOption(
        'multi-string',
        defaultsTo: [],
      )
      ..addMultiOption(
        'multi-int',
        defaultsTo: [],
      )
      ..addMultiOption(
        'multi-enum',
        defaultsTo: [],
      );
  }

  final Function({
    List<String> multiString,
    Set<int> multiInt,
    Iterable<MyFooEnum> multiEnum,
  }) userMethod;

  @override
  String get name => 'default-values';

  @override
  String get description => '';

  @override
  void run() {
    final results = argResults!;
    return userMethod(
      multiString: results['multi-string'] != null
          ? List<String>.from(results['multi-string'])
          : const [],
      multiInt: results['multi-int'] != null
          ? List<String>.from(results['multi-int']).map(int.parse).toSet()
          : const {},
      multiEnum: results['multi-enum'] != null
          ? List<String>.from(results['multi-enum'])
              .map(EnumParser(MyFooEnum.values).parse)
          : const [],
    );
  }
}
