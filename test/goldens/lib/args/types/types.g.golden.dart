// **************************************************************************
// CliRunnerGenerator
// **************************************************************************

/// A class for invoking [Command]s based on raw command-line arguments.
///
/// The type argument `T` represents the type returned by [Command.run] and
/// [CommandRunner.run]; it can be ommitted if you're not using the return
/// values.
class _$Types<T extends dynamic> extends CommandRunner<dynamic> {
  _$Types()
      : super(
          'types',
          '',
        ) {
    final upcastedType = (this as Types);
    addCommand(PrimativeTypesCommand(upcastedType.primativeTypes));
    addCommand(UserTypesCommand(upcastedType.userTypes));
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

class PrimativeTypesCommand extends Command<void> {
  PrimativeTypesCommand(this.userMethod) {
    argParser
      ..addOption(
        'string-value',
        mandatory: true,
      )
      ..addOption(
        'int-value',
        mandatory: true,
      )
      ..addFlag('bool-value');
  }

  final void Function(
    String,
    int,
    bool,
  ) userMethod;

  @override
  String get name => 'primative-types';

  @override
  String get description => '';

  @override
  void run() {
    final results = argResults!;
    return userMethod(
      results['string-value'],
      int.parse(results['int-value']),
      results['bool-value'],
    );
  }
}

class UserTypesCommand extends Command<void> {
  UserTypesCommand(this.userMethod) {
    argParser
      ..addOption(
        'enum-value',
        mandatory: true,
        allowed: [
          'value1',
          'value2',
        ],
      )
      ..addOption(
        'enum-value2',
        defaultsTo: 'value1',
        mandatory: false,
        allowed: [
          'value1',
          'value2',
        ],
      )
      ..addOption(
        'const-var',
        defaultsTo: '42',
        mandatory: false,
      )
      ..addOption(
        'custom-parser-option',
        defaultsTo: '0',
        mandatory: false,
      );
  }

  final void Function(
    MyFooEnum, {
    MyFooEnum enumValue2,
    int constVar,
    int customParserOption,
  }) userMethod;

  @override
  String get name => 'user-types';

  @override
  String get description => '';

  @override
  void run() {
    final results = argResults!;
    return userMethod(
      EnumParser(MyFooEnum.values).parse(results['enum-value']),
      enumValue2: results['enum-value2'] != null
          ? EnumParser(MyFooEnum.values).parse(results['enum-value2'])
          : MyFooEnum.value1,
      constVar: results['const-var'] != null
          ? int.parse(results['const-var'])
          : someConstant,
      customParserOption: results['custom-parser-option'] != null
          ? customParser(results['custom-parser-option'])
          : 0,
    );
  }
}
