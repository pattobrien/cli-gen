// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_values.dart';

// **************************************************************************
// CliRunnerGenerator
// **************************************************************************

/// A class for invoking [Command]s based on raw command-line arguments.
///
/// The type argument `T` represents the type returned by [Command.run] and
/// [CommandRunner.run]; it can be ommitted if you're not using the return
/// values.
class _$DefaultValues<T extends dynamic> extends CommandRunner<dynamic> {
  _$DefaultValues()
      : super(
          'default-values',
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
      ..addOption(
        'string-val',
        defaultsTo: 'default',
        mandatory: false,
      )
      ..addOption(
        'integer-val',
        defaultsTo: '42',
        mandatory: false,
      )
      ..addFlag(
        'boolean-val',
        defaultsTo: true,
      )
      ..addMultiOption(
        'list-val',
        defaultsTo: [
          'a',
          'b',
          'c',
        ],
      )
      ..addMultiOption(
        'set-val',
        defaultsTo: [
          '1',
          '2',
          '3',
        ],
      )
      ..addOption(
        'enum-val',
        defaultsTo: 'value1',
        mandatory: false,
        allowed: [
          'value1',
          'value2',
        ],
      )
      ..addMultiOption(
        'multi-enum-val',
        defaultsTo: [
          'value1',
          'value2',
        ],
      );
  }

  final Function({
    String stringVal,
    int integerVal,
    bool booleanVal,
    List<String> listVal,
    Set<int> setVal,
    MyFooEnum enumVal,
    Set<MyFooEnum> multiEnumVal,
  }) userMethod;

  @override
  String get name => 'default-values';

  @override
  String get description => '';

  @override
  void run() {
    final results = argResults!;
    return userMethod(
      stringVal:
          results['string-val'] != null ? results['string-val'] : 'default',
      integerVal: results['integer-val'] != null
          ? int.parse(results['integer-val'])
          : 42,
      booleanVal:
          results['boolean-val'] != null ? results['boolean-val'] : true,
      listVal: results['list-val'] != null
          ? List<String>.from(results['list-val'])
          : const ['a', 'b', 'c'],
      setVal: results['set-val'] != null
          ? List<String>.from(results['set-val']).map(int.parse).toSet()
          : const {1, 2, 3},
      enumVal: results['enum-val'] != null
          ? EnumParser(MyFooEnum.values).parse(results['enum-val'])
          : MyFooEnum.value1,
      multiEnumVal: results['multi-enum-val'] != null
          ? List<String>.from(results['multi-enum-val'])
              .map(EnumParser(MyFooEnum.values).parse)
              .toSet()
          : const {MyFooEnum.value1, MyFooEnum.value2},
    );
  }
}
