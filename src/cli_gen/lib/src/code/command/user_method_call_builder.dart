import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';
import 'package:recase/recase.dart';

import '../../analysis/utils/reference_ext.dart';
import '../models/command_method_model.dart';
import '../models/command_parameter_model.dart';

class UserMethodCallBuilder {
  const UserMethodCallBuilder();

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
          e.name.symbol!,
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
    if (!param.isNamed) {
      // handle positional param
      final positionalVar = refer(param.name.symbol!);
      final parser = param.parser;
      final parserExpression = parser?.call([positionalVar]) ?? positionalVar;
      final isNullable = (param.type.isNullable ?? false) || !param.isRequired;

      final hasDefault = param.defaultValueAsCode != null;

      switch ((isNullable, hasDefault)) {
        case (true, true):
          return positionalVar.notEqualTo(literalNull).conditional(
                parserExpression,
                param.defaultValueAsCode!,
              );
        case (true, false):
          return positionalVar.notEqualTo(literalNull).conditional(
                parserExpression,
                literalNull,
              );
        case (false, true):
          return positionalVar.notEqualTo(literalNull).conditional(
                parserExpression,
                param.defaultValueAsCode!,
              );
        case (false, false):
          return parserExpression;
      }
    }
    final resultsRef = refer('results');
    // final parser = refer('int.parse');
    final parser = param.parser;
    // NOTE: i think its safe to assume that a required value wont be null,
    // as ArgParser takes care of erroring to the user in those cases (presumably).

    final resultKeyValue =
        resultsRef.index(literalString(param.name.symbol!.paramCase));

    // TODO: not sure if assuming `null` is the right approach here
    // but we never require passing a null or non-null value anywhere in the
    // creating of references, so this is probably a safe move.
    final isNullable = param.type.isNullable ?? false;
    final hasDefault = param.defaultValueAsCode != null;

    // create the parser expression based on:
    // a) whether a parser is available (will only be null for String and bool types)
    // b) whether the parameter is iterable and needs to call `.map` on the result
    Expression parserExpression;
    final isIterable = param.optionType == OptionType.multi;
    final hasParser = param.parser != null;
    if (isIterable && hasParser) {
      parserExpression = refer('List')
          .toTypeRef(typeArguments: [refer('String')])
          .property('from')
          .call([resultKeyValue])
          .property('map')
          .call([param.parser!]);
      if (param.type.symbol == 'List') {
        parserExpression = parserExpression.property('toList').call([]);
      } else if (param.type.symbol == 'Set') {
        parserExpression = parserExpression.property('toSet').call([]);
      }
    } else if (isIterable && param.parser == null) {
      parserExpression = refer('List')
          .toTypeRef(typeArguments: [refer('String')])
          .property('from')
          .call([resultKeyValue]);
    } else {
      parserExpression = parser?.call([resultKeyValue]) ?? resultKeyValue;
    }

    switch ((isNullable, hasDefault)) {
      case (true, true):
        if (hasParser || isIterable) {
          return resultKeyValue.notEqualTo(literalNull).conditional(
                parserExpression,
                param.defaultValueAsCode!,
              );
        } else {
          return parserExpression
              .asA(param.type.toTypeRef(isNullable: true))
              .ifNullThen(param.defaultValueAsCode!);
        }
      case (true, false):
        if (hasParser || isIterable) {
          return resultKeyValue.notEqualTo(literalNull).conditional(
                parserExpression,
                literalNull,
              );
        } else {
          return parserExpression
              .asA(
                param.type.toTypeRef(isNullable: true),
              )
              .ifNullThen(literalNull);
        }
      case (false, true):
        // in this case, we need to copy the defaultValueCode into the elseThen
        // expression of the conditional, because otherwise we're passing a null
        // value into a non-nullable parameter.
        if (hasParser || isIterable) {
          return resultKeyValue.notEqualTo(literalNull).conditional(
                parserExpression,
                param.defaultValueAsCode!,
              );
        } else {
          return parserExpression
              .asA(
                param.type.toTypeRef(isNullable: true),
              )
              .ifNullThen(
                param.defaultValueAsCode!,
              );
        }
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
