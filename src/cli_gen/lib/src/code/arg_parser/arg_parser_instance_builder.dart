import 'package:code_builder/code_builder.dart';
import 'package:recase/recase.dart';

import '../../types/identifiers.dart';
import '../models/command_parameter_model.dart';
import '../utils/remove_doc_slashes.dart';

/// Responsible for generating the `ArgParser` and adding flags/options to it.
class ArgParserInstanceExp {
  const ArgParserInstanceExp();

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
    final defaultValue = parameter.defaultValueCode;
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
      if (defaultValue != null)
        'defaultsTo': CodeExpression(Code(defaultValue)),
      if (docComment != null)
        'help': literalString(removeDocSlashes(docComment)!),
    });
  }
}
