import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';

import '../../analysis/utils/reference_ext.dart';
import '../models/command_method_model.dart';
import '../models/command_parameter_model.dart';

class CliMethodCallBuilder {
  const CliMethodCallBuilder();

  Code buildInlineCallStatement(CommandMethodModel method) {
    final methodCallArgs = buildMethodArguments(method.parameters);
    return refer('userMethod')
        .call(methodCallArgs.positionalArgs, methodCallArgs.namedArgs)
        .returned
        .statement;
  }

  MethodCallArgs buildMethodArguments(List<CommandParameterModel> parameters) {
    final positionalParams = parameters.where((e) => !e.isNamed);
    final namedParams = parameters.where((e) => e.isNamed);

    final positionalArgs =
        positionalParams.map((e) => buildSingleArgParseExp(e)).toList();

    final namedArgs = Map.fromEntries(namedParams.map((e) => MapEntry(
          e.ref.symbol!,
          buildSingleArgParseExp(e),
        )));

    return (positionalArgs: positionalArgs, namedArgs: namedArgs);
  }

  /// Takes a ParameterModel and returns an Expression that calls any
  /// necessary parsing methods to turn a potentially nullable string into
  /// the user's desired type.
  ///
  /// For example:
  /// - non-nullable value: `int.parse(results['intValue'])`
  /// - nullable with no default: `results['stringValue'] != null ? int.parse(results['stringValue']) : null`
  /// - nullable with default value: `results['stringValue'] != null ? int.parse(results['stringValue']) : 42`
  /// - list of non-nullable values: `List<String>.from(results['intValue']).map(int.parse)`
  @visibleForTesting
  Expression buildSingleArgParseExp(CommandParameterModel param) {
    // imagine a parser value on param model that provides us with a method
    // reference (e.g. int.parse, UserId.fromString, etc.)
    final resultsRef = refer('results');
    // final parser = refer('int.parse');
    final parser = param.parser;
    // NOTE: i think its safe to assume that a required value wont be null,
    // as ArgParser takes care of erroring to the user in those cases (presumably).

    final resultKeyValue = resultsRef.index(literalString(param.ref.symbol!));

    // TODO: not sure if assuming `null` is the right approach here
    // but we never require passing a null or non-null value anywhere in the
    // creating of references, so this is probably a safe move.
    final isNullable = param.type.isNullable ?? false;
    final hasDefault = param.computedDefaultValue != null;

    // create the parser expression based on:
    // a) whether a parser is available (will only be null for String types)
    // b) whether the parameter is iterable and needs to call `.map` on the result
    Expression parserExpression;
    final isIterable = param.optionType == OptionType.multiOption;
    if (isIterable && param.parser != null) {
      parserExpression = refer('List')
          .toTypeRef(typeArguments: [refer('String')])
          .property('from')
          .call([resultKeyValue])
          .property('map')
          .call([param.parser!]);
    } else if (isIterable && param.parser == null) {
      parserExpression = refer('List')
          .toTypeRef(typeArguments: [refer('String')])
          .property('from')
          .call([resultKeyValue]);
    } else {
      parserExpression = parser?.call([resultKeyValue]) ?? resultKeyValue;
    }

    switch ((isNullable, hasDefault)) {
      case (true, _):
        return resultKeyValue.notEqualTo(literalNull).conditional(
              parserExpression,
              literalNull,
            );
      case (false, true):
        // in this case, we need to copy the defaultValueCode into the elseThen
        // expression of the conditional, because otherwise we're passing a null
        // value into a non-nullable parameter.
        return resultKeyValue.notEqualTo(literalNull).conditional(
              parserExpression,
              param.computedDefaultValue!,
            );
      case (false, false):
        return parserExpression;
    }
  }

  // Expression buildSingleArgResult(Reference ref, TypeReference type) {
  //   return refer('argResults!').index(literalString(ref.symbol!)).asA(type);
  // }
}

typedef MethodCallArgs = ({
  List<Expression> positionalArgs,
  Map<String, Expression> namedArgs,
});
