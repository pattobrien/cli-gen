import 'package:code_builder/code_builder.dart';

import '../../types/identifiers.dart';
import '../models/command_parameter_model.dart';

/// Generates an instance of `ArgParser` and adding flags/options to it.
///
/// see [ArgParserInstanceExp.buildArgParserInstance] for usage.
class ArgParserInstanceExp {
  const ArgParserInstanceExp();

  /// Generates an `ArgParser` instance and adds a flag/option for [parameters].
  ///
  /// Example of generated code:
  /// ```dart
  /// ArgParser()
  ///   ..addOption(
  ///     'foo-option-name',
  ///     mandatory: true,
  ///     help: 'Some doc comment here.',
  ///   );
  /// ```
  Expression buildArgParserInstance(
    List<CommandParameterModel> parameters,
  ) {
    final argParserRef = Identifiers.args.argParser;
    var argParserInstance = argParserRef.newInstance([]);

    for (final parameter in parameters) {
      argParserInstance = generateArgOption(argParserInstance, parameter);
    }

    return argParserInstance;
  }

  /// Generates a single `addOption` or `addFlag` method call on the given
  /// [argParserInstance].
  ///
  /// To generate the entire `ArgParser` instance, use [buildArgParserInstance].
  ///
  /// Example of generated code:
  /// ```dart
  /// argParserExp
  ///   ..addOption(
  ///     'foo-option-name',
  ///     mandatory: true,
  ///     help: 'Some doc comment here.',
  ///   );
  /// ```
  Expression generateArgOption(
    Expression argParserInstance,
    CommandParameterModel param,
  ) {
    final boolRef = Identifiers.dart.bool;
    final type = param.type;
    final isFlag = type.symbol == boolRef.symbol && type.url == boolRef.url;
    final isMultiOption = param.optionType == OptionType.multi;
    final isSingleOption = !isFlag && !isMultiOption;

    final methodName = isFlag
        ? 'addFlag'
        : isMultiOption
            ? 'addMultiOption'
            : 'addOption';

    return argParserInstance.cascade(methodName).call([
      literalString(param.cliArgumentName),
    ], {
      if (param.abbr != null) 'abbr': literalString(param.abbr!),
      if (param.hide != null) 'hide': literalBool(param.hide!),
      if (param.aliases != null) 'aliases': literalList(param.aliases!),
      if (param.docComments != null) 'help': literalString(param.docComments!),
      if (param.computedDefault != null) 'defaultsTo': param.computedDefault!,
      if (isSingleOption) 'mandatory': literalBool(param.isRequired),
      if (isFlag && param.negatable != null)
        'negatable': literalBool(param.negatable!),
      if (!isFlag && param.valueHelp != null) 'valueHelp': param.valueHelp!,
      if (!isFlag && param.allowed != null)
        'allowed': literalList(param.allowed!),
      if (!isFlag && param.allowedHelp != null)
        'allowedHelp': literalMap(param.allowedHelp!),
    });
  }
}
