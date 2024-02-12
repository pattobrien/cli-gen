import 'package:code_builder/code_builder.dart';

import '../models/command_method_model.dart';
import '../models/command_parameter_model.dart';

class CliMethodCallBuilder {
  const CliMethodCallBuilder();

  Code buildInlineCallStatement(CommandMethodModel method) {
    final methodCallArgs = buildMethodArguments(method.parameters);
    return method.methodRef
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
  Expression buildSingleArgParseExp(CommandParameterModel param) {
    // imagine a parser value on param model that probides us with a method
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
    final hasDefault = param.defaultValueCode != null;

    switch ((isNullable, hasDefault)) {
      case (true, _):
        return resultKeyValue.notEqualTo(literalNull).conditional(
              parser?.call([resultKeyValue]) ?? resultKeyValue,
              literalNull,
            );
      case (false, true):
        // in this case, we need to copy the defaultValueCode into the elseThen
        // expression of the conditional, because otherwise we're passing a null
        // value into a non-nullable parameter.
        return resultKeyValue.notEqualTo(literalNull).conditional(
              parser?.call([resultKeyValue]) ?? resultKeyValue,
              CodeExpression(Code(param.defaultValueCode!)),
            );
      case (false, false):
        return parser?.call([resultKeyValue]) ?? resultKeyValue;
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
