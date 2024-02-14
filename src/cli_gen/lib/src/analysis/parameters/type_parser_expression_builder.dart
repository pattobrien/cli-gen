import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';

import '../../types/identifiers.dart';
import '../annotations/options_annotation_analyzer.dart';

/// Generates an expression for a String -> [paramType] parse method.
///
/// See [getParserForParameter] for usage details.
class TypeParserExpressionBuilder {
  const TypeParserExpressionBuilder();

  /// Generates an expression for a String -> [paramType] parse method.
  ///
  /// For example, the type `int` would generate `int.parse`.
  ///
  /// The provided [element] is only used for error reporting. If the type
  /// is not supported, an [InvalidGenerationSource] will be thrown.
  Expression? getParserForParameter(
    Element element,
    DartType paramType,
  ) {
    // the first thing we do is check for any options annotations that
    // may define a parser, and if so we use that parser.
    final optionAnnotationAnalyzer = OptionsAnnotationAnalyzer();
    final annotations = optionAnnotationAnalyzer.annotationsForElement(element);
    final parserExpressions = annotations.map((e) => e.parser).nonNulls;
    if (parserExpressions.isNotEmpty) {
      return parserExpressions.first;
    }

    // `package:args` already parses to bool and String, so no parser is needed.
    if (paramType.isDartCoreBool) return null;
    if (paramType.isDartCoreString) return null;

    final isDartCore =
        paramType.element!.librarySource!.uri.toString() == 'dart:core';

    // built-in parsers: int, double, num, BigInt, Uri, DateTime
    if (paramType.isDartCoreInt) {
      return Identifiers.dart.int.property('parse');
    }
    if (paramType.isDartCoreDouble) {
      return Identifiers.dart.double.property('parse');
    }
    if (paramType.isDartCoreNum) {
      return Identifiers.dart.num.property('parse');
    }
    if (paramType.element!.name == 'BigInt' && isDartCore) {
      return Identifiers.dart.bigInt.property('parse');
    }

    if (paramType.element!.name == 'Uri' && isDartCore) {
      return Identifiers.dart.uri.property('parse');
    }
    if (paramType.element!.name == 'DateTime' && isDartCore) {
      return Identifiers.dart.dateTime.property('parse');
    }

    // If the element is an Enum, use the `EnumParser` included in
    // `package:cli_annotations` along with `MyEnum.values`.
    // e.g. `EnumParser(MyEnum.values).parse`
    final enumType =
        paramType.element?.library?.typeProvider.enumElement!.thisType;

    if (paramType is InterfaceType &&
        paramType.allSupertypes.contains(enumType)) {
      return refer('EnumParser').newInstance([
        refer('${paramType.element.name}.values'),
      ]).property('parse');
    }

    // if the element is a Collection type, check if the type argument is one
    // of the above types, and use the corresponding parser + .split(',')
    final isCollectionType = paramType.isDartCoreIterable ||
        paramType.isDartCoreList ||
        paramType.isDartCoreSet;
    if (isCollectionType) {
      final typeArg = paramType as ParameterizedType;
      final argType = typeArg.typeArguments.single;
      return getParserForParameter(element, argType);
    }

    // TODO: extension type is not supported yet
    // Extension Types require the user to define a `fromString` factory
    // on the extension type (similarly to how a user-defined class would
    // be handled). This requires implementations of `cli_gen` annotations.

    // if the element is a extension type, get the extension type erasure
    // to get the underlying type, then get the corresponding parser
    // by calling `getParserForParameter` recursively.
    final isExtensionType = paramType.extensionTypeErasure != paramType;
    if (isExtensionType) {
      // final erasure = type.extensionTypeErasure;
      // return getParserForParameter(element, erasure);
      throw InvalidGenerationSource(
        'Extension types are not supported by `cli-gen` yet.',
        element: element,
        todo: 'Please use a supported type',
      );
    }

    throw InvalidGenerationSource(
      '`${paramType.element!.name}` is not a supported type for arg parsing.',
      element: element,
      todo: 'Please use a supported type',
    );
  }
}
