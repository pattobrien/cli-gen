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
        ) {
    final upcastedType = (this as DefaultValues);
    addCommand(DefaultValuesCommand(upcastedType.defaultValues));
    addCommand(
        DefaultIterableValuesCommand(upcastedType.defaultIterableValues));
    addCommand(AnnotatedParamsCommand(upcastedType.annotatedParams));
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

class DefaultValuesCommand extends Command<void> {
  DefaultValuesCommand(this.userMethod) {
    argParser
      ..addOption(
        'str-val',
        defaultsTo: 'default',
        mandatory: false,
      )
      ..addOption(
        'int-val',
        defaultsTo: '42',
        mandatory: false,
      )
      ..addFlag(
        'bool-val',
        defaultsTo: true,
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
      ..addOption(
        'int-annot',
        defaultsTo: '123',
        mandatory: false,
      );
  }

  final Function({
    String strVal,
    int intVal,
    bool boolVal,
    MyFooEnum enumVal,
    int intAnnot,
  }) userMethod;

  @override
  String get name => 'default-values';

  @override
  String get description => '';

  @override
  void run() {
    final results = argResults!;
    return userMethod(
      strVal: results['str-val'] != null ? results['str-val'] : 'default',
      intVal: results['int-val'] != null ? int.parse(results['int-val']) : 42,
      boolVal: results['bool-val'] != null ? results['bool-val'] : true,
      enumVal: results['enum-val'] != null
          ? EnumParser(MyFooEnum.values).parse(results['enum-val'])
          : MyFooEnum.value1,
      intAnnot:
          results['int-annot'] != null ? int.parse(results['int-annot']) : 123,
    );
  }
}

class DefaultIterableValuesCommand extends Command<void> {
  DefaultIterableValuesCommand(this.userMethod) {
    argParser
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
      ..addMultiOption(
        'multi-enum-val',
        defaultsTo: [
          'value1',
          'value2',
        ],
      );
  }

  final Function({
    List<String> listVal,
    Set<int> setVal,
    Set<MyFooEnum> multiEnumVal,
  }) userMethod;

  @override
  String get name => 'default-iterable-values';

  @override
  String get description => '';

  @override
  void run() {
    final results = argResults!;
    return userMethod(
      listVal: results['list-val'] != null
          ? List<String>.from(results['list-val'])
          : const ['a', 'b', 'c'],
      setVal: results['set-val'] != null
          ? List<String>.from(results['set-val']).map(int.parse).toSet()
          : const {1, 2, 3},
      multiEnumVal: results['multi-enum-val'] != null
          ? List<String>.from(results['multi-enum-val'])
              .map(EnumParser(MyFooEnum.values).parse)
              .toSet()
          : const {MyFooEnum.value1, MyFooEnum.value2},
    );
  }
}

class AnnotatedParamsCommand extends Command<void> {
  AnnotatedParamsCommand(this.userMethod) {
    argParser
      ..addOption(
        'numeric-value',
        defaultsTo: '123',
        mandatory: false,
      )
      ..addFlag(
        'flag-val',
        defaultsTo: true,
      );
  }

  final Function({
    int numericValue,
    bool flagVal,
  }) userMethod;

  @override
  String get name => 'annotated-params';

  @override
  String get description => '';

  @override
  void run() {
    final results = argResults!;
    return userMethod(
      numericValue: results['numeric-value'] != null
          ? int.parse(results['numeric-value'])
          : 123,
      flagVal: results['flag-val'] != null ? results['flag-val'] : true,
    );
  }
}
