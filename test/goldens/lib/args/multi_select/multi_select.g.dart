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
        ) {
    final upcastedType = (this as MultiSelect);
    addCommand(MultiValuesCommand(upcastedType.multiValues));
    addCommand(SingleValuesCommand(upcastedType.singleValues));
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

class MultiValuesCommand extends Command<void> {
  MultiValuesCommand(this.userMethod) {
    argParser
      ..addMultiOption('multi-string')
      ..addMultiOption(
        'multi-int',
        defaultsTo: [
          '1',
          '5',
          '7',
        ],
      )
      ..addMultiOption('multi-enum');
  }

  final Function({
    required List<String> multiString,
    Set<int> multiInt,
    Iterable<MyFooEnum> multiEnum,
  }) userMethod;

  @override
  String get name => 'multi-values';

  @override
  String get description => '';

  @override
  void run() {
    final results = argResults!;
    return userMethod(
      multiString: List<String>.from(results['multi-string']),
      multiInt: results['multi-int'] != null
          ? List<String>.from(results['multi-int']).map(int.parse).toSet()
          : const {1, 5, 7},
      multiEnum: List<String>.from(results['multi-enum'])
          .map(EnumParser(MyFooEnum.values).parse),
    );
  }
}

class SingleValuesCommand extends Command<void> {
  SingleValuesCommand(this.userMethod) {
    argParser.addOption(
      'multi-int',
      defaultsTo: '1',
      mandatory: false,
    );
  }

  final Function({int multiInt}) userMethod;

  @override
  String get name => 'single-values';

  @override
  String get description => '';

  @override
  void run() {
    final results = argResults!;
    return userMethod(
        multiInt:
            results['multi-int'] != null ? int.parse(results['multi-int']) : 1);
  }
}
