import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';
import 'package:recase/recase.dart';

import '../../types/identifiers.dart';
import '../models/command_parameter_model.dart';
import '../utils/remove_doc_slashes.dart';

/// Responsible for generating an instance of `ArgParser` and adding flags/options to it.
class ArgParserInstanceExp {
  const ArgParserInstanceExp();

  /// Creates a new `ArgParser` instance and adds a flag/option for each of [parameters].
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
    var argParserExp = argParserRef.newInstance([]);

    for (final parameter in parameters) {
      argParserExp = generateArgOption(argParserExp, parameter);
    }

    return argParserExp;
  }

  /// Generates a single `addOption` or `addFlag` method call on the given
  /// [argParserExp].
  ///
  /// To generate the entire `ArgParser` instance, see [buildArgParserInstance].
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
  @visibleForTesting
  Expression generateArgOption(
    Expression argParserExp,
    CommandParameterModel parameter,
  ) {
    final name = parameter.ref;

    final docComment = parameter.docComments;

    final type = parameter.type;
    final isRequired = parameter.isRequired;

    final boolRef = Identifiers.dart.bool;
    final isFlag = type.symbol == boolRef.symbol && type.url == boolRef.url;
    final defaultValue = parameter.computedDefaultValue;
    final isNegatable = false;

    final property = isFlag ? 'addFlag' : 'addOption';

    // we change the option name from camelCase to param-case, for example:
    // `authorDateOrder` to `author-date-order`.
    final optionName = name.symbol!.paramCase;

    return argParserExp.cascade(property).call([
      literalString(optionName),
    ], {
      // 'abbr': literalString('p'),
      if (!isFlag) 'mandatory': literalBool(isRequired),
      if (!isFlag) 'valueHelp': literalString('property'),
      // if (!isFlag) 'allowed': literalList([]),
      if (isFlag) 'negatable': literalBool(isNegatable),
      if (defaultValue != null) 'defaultsTo': defaultValue,
      if (docComment != null)
        'help': literalString(removeDocSlashes(docComment)!),
    });
  }
}

void x() {
  ArgParserInstanceExp()
    ..buildArgParserInstance([
      // TODO
    ])
    ..buildArgParserInstance([
      // TODO
    ]);
}
