import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
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
  String? getDefaultConstantValue(ParameterElement element) {
    final hasDefaultValue = element.defaultValueCode != null;
    if (!hasDefaultValue) return null;

    final constant = element.computeConstantValue();
    if (constant == null) return null;

    final reader = ConstantReader(constant);
    final thisType = reader.objectValue.type!;

    if (thisType.isDartCoreNull) return null;

    // note: we need to supply the enumType, since `getSingleValueForObject`
    // doesn't have access to the typeProvider.
    final enumType = element.library!.typeProvider.enumElement!.thisType;
    return getSingleValueForObject(constant, enumType);
  }

  String getSingleValueForObject(
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
    if (thisType.isDartCoreInt) return reader.intValue.toString();
    if (thisType.isDartCoreBool) return reader.boolValue.toString();
    if (thisType.isDartCoreDouble) return reader.doubleValue.toString();
    if (thisType.isDartCoreList) {
      // TODO: we should allow `computedDefaultValue` to be a
      // list of strings, not just a single string.
      return reader.listValue
          .map((e) => getSingleValueForObject(e, enumType))
          .join(', ');
    }
    if (thisType.isDartCoreSet) {
      // TODO: we should allow `computedDefaultValue` to be a
      // list of strings, not just a single string.
      return reader.setValue
          .map((e) => getSingleValueForObject(e, enumType))
          .join(', ');
    }

    throw InvalidGenerationSourceError(
      'Invalid type for constant value: $thisType',
    );
  }

  Iterable<String> getMultiValuesForObject(
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
      return reader.listValue.map((e) => getSingleValueForObject(e, enumType));
    }
    if (thisType.isDartCoreSet) {
      return reader.setValue.map((e) => getSingleValueForObject(e, enumType));
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
