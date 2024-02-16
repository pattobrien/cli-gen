import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';

/// Generates a string that can be used to represent the default value
/// of a given parameter.
///
/// See [getDefaultConstantValue] for more details.
class DefaultValueCodeBuilder {
  const DefaultValueCodeBuilder();

  /// Returns the source code of the default value, with no computation.
  String? getDefaultValueAsCode(ParameterElement element) {
    return element.defaultValueCode;
  }

  /// Returns the default value for the given [element] as a string or null
  /// if no default value is present.
  Expression? getDefaultConstantValue(ParameterElement element) {
    final hasDefaultValue = element.defaultValueCode != null;
    if (!hasDefaultValue) return null;

    final constant = element.computeConstantValue();
    if (constant == null) return null;

    final enumType = element.library!.typeProvider.enumElement!.thisType;

    return getDefaultConstantValue2(
      ConstantReader(constant),
      enumType,
    );
  }

  Expression? getDefaultConstantValue2(
    ConstantReader reader,
    InterfaceType enumType,
  ) {
    final object = reader.objectValue;
    final thisType = reader.objectValue.type!;

    if (thisType.isDartCoreNull) return null;

    if (thisType.isDartCoreBool) {
      return literalBool(reader.boolValue);
    }

    if (thisType.isDartCoreList || thisType.isDartCoreSet) {
      return literalList(
        getMultiValuesAsStrings(object, enumType),
      );
    }

    return literalString(
      getSingleValueAsString(object, enumType).toString(),
    );
  }

  Expression? getDefaultAsValue(
    ConstantReader reader,
    InterfaceType enumType,
  ) {
    final object = reader.objectValue;
    final thisType = reader.objectValue.type!;

    if (thisType.isDartCoreNull) return null;

    if (thisType.isDartCoreBool) {
      return literalBool(reader.boolValue);
    }

    if (thisType.isDartCoreList || thisType.isDartCoreSet) {
      return literalList(
        getMultiValuesForObject(object, enumType),
      );
    }

    return literal(
      getSingleValue(object, enumType),
    );
  }

  /// Returns an [object] as a string representation of the value.
  ///
  /// For example, an int(42) value would return "42" (no quotes).
  String getSingleValueAsString(
    DartObject object,
    InterfaceType enumType,
  ) {
    return getSingleValue(object, enumType).toString();
  }

  Object getSingleValue(
    DartObject object,
    InterfaceType enumType,
  ) {
    final reader = ConstantReader(object);
    final thisType = reader.objectValue.type;
    if (thisType is! InterfaceType) {
      throw InvalidGenerationSourceError(
        'Invalid type for constant value: $thisType',
      );
    }

    // handle Enum types
    // final enumType = object.library!.typeProvider.enumElement!.thisType;
    if (thisType.allSupertypes.contains(enumType)) {
      return reader.read('_name').stringValue;
    }

    // handle Dart Primative types
    if (thisType.isDartCoreString) return reader.stringValue;
    if (thisType.isDartCoreInt) return reader.intValue;
    if (thisType.isDartCoreBool) return reader.boolValue;
    if (thisType.isDartCoreDouble) return reader.doubleValue;
    if (thisType.isDartCoreList) {
      // TODO: we should allow `computedDefaultValue` to be a
      // list of strings, not just a single string.
      return reader.listValue
          .map((e) => getSingleValueAsString(e, enumType))
          .join(', ');
    }
    if (thisType.isDartCoreSet) {
      // TODO: we should allow `computedDefaultValue` to be a
      // list of strings, not just a single string.
      return reader.setValue
          .map((e) => getSingleValueAsString(e, enumType))
          .join(', ');
    }

    throw InvalidGenerationSourceError(
      'Invalid type for constant value: $thisType',
    );
  }

  Iterable<String> getMultiValuesAsStrings(
    DartObject object,
    InterfaceType enumType,
  ) {
    return getMultiValuesForObject(object, enumType).map((e) => e.toString());
  }

  Iterable<Object> getMultiValuesForObject(
    DartObject object,
    InterfaceType enumType,
  ) {
    final reader = ConstantReader(object);
    final thisType = reader.objectValue.type;
    if (thisType is! InterfaceType) {
      throw InvalidGenerationSourceError(
        'Invalid type for constant value: $thisType',
      );
    }

    if (thisType.isDartCoreList) {
      return reader.listValue.map((e) => getSingleValueAsString(e, enumType));
    }
    if (thisType.isDartCoreSet) {
      return reader.setValue.map((e) => getSingleValueAsString(e, enumType));
    }
    if (thisType.isDartCoreMap) {
      // TODO: handle this case
      throw InvalidGenerationSourceError(
        'Maps are not supported as default values for options yet.',
      );
    }

    throw InvalidGenerationSourceError(
      'Unexpected type for constant value: $thisType',
    );
  }
}
