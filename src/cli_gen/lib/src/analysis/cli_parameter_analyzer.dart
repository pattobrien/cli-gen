import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

import '../code/models/command_parameter_model.dart';
import '../code/utils/remove_doc_slashes.dart';
import 'utils/reference_ext.dart';

class CliParameterAnalyzer {
  const CliParameterAnalyzer();

  List<CommandParameterModel> fromExecutableElement(ExecutableElement element) {
    final parameters = element.parameters;
    return parameters.map(fromParameter).toList();
  }

  CommandParameterModel fromParameter(ParameterElement element) {
    final docComments = getDocComments(element);
    final cleanedUpComments = removeDocSlashes(docComments);
    final availableOptions = getImplicitAvailableOptions(element);
    // final defaultValue = getDefaultValueCode(element);
    final computedDefaultValue = getDefaultConstantValue(element);
    return CommandParameterModel(
      ref: element.toRef(),
      type: element.type.toRef().toTypeRef(),
      isRequired: element.isRequired,
      isNamed: element.isNamed,
      optionType:
          isMultiOptional(element) ? OptionType.multiOption : OptionType.single,
      availableOptions: availableOptions,
      defaultValueCode: element.defaultValueCode,
      computedDefaultValue: computedDefaultValue,
      docComments: cleanedUpComments,
      annotations: [
        // TODO: add support for annotations
      ],
    );
  }

  String? getDefaultConstantValue(ParameterElement element) {
    final hasDefaultValue = element.defaultValueCode != null;
    if (!hasDefaultValue) return null;

    final constant = element.computeConstantValue();
    final reader = ConstantReader(constant);

    if (constant == null) return null;
    final thisType = reader.objectValue.type;
    if (thisType is! InterfaceType) return null; // TODO: handle this case

    final typeProvider = element.library!.typeProvider;
    final enumType = typeProvider.enumElement!.thisType;

    if (thisType.allSupertypes.contains(enumType)) {
      // print('found an enum');
      final value = reader.read('_name').stringValue;
      print('enum value is: $value');

      return value;
    }
    if (thisType.isDartCoreString) {
      return reader.stringValue;
    }

    if (thisType.isDartCoreInt) {
      return reader.intValue.toString();
    }
    if (thisType.isDartCoreBool) {
      return reader.boolValue.toString();
    }
    if (thisType.isDartCoreDouble) {
      return reader.doubleValue.toString();
    }
    if (thisType.isDartCoreList) {
      return reader.listValue.toString();
    }

    return null;
  }

  // String? getDefaultValueCode(ParameterElement element) {
  //   final path = element.librarySource!.uri.path;
  //   final result = element.session!.getParsedLibrary(path);
  //   if (result is! ParsedLibraryResult) return null;
  //   final parameterLocation = element.nameOffset;
  //   final visitor = ParameterNodeVisitor(element);
  //   final nodeAtOffset = result.units.single.unit.accept(visitor);

  //   return element.defaultValueCode;
  // }

  // for a parameter to be multi-optional, it must have the following properties:
  // - be a list type
  bool isMultiOptional(ParameterElement element) {
    return element.type.isDartCoreList;
  }

  // for a parameter to have options to select from, it must:
  // - be an enum OR
  // - explicitly have a list of options in the annotations
  List<String>? getImplicitAvailableOptions(ParameterElement element) {
    return switch (element.type) {
      InterfaceType(:InterfaceElement element) => switch (element) {
          EnumElement() => () {
              final e = element;
              final values = e.fields.where((f) => f.isEnumConstant).toList();
              final names = values.map((f) => f.name).toList();
              return names;
            }(),
          _ => null,
        },
      _ => null,
    };
  }

  String? getDocComments(ParameterElement element) {
    return switch (element) {
      FieldFormalParameterElement(:final field) =>
        element.documentationComment ?? field?.documentationComment,
      SuperFormalParameterElement(
        :ParameterElement superConstructorParameter,
      ) =>
        element.documentationComment ??
            getDocComments(superConstructorParameter),
      ParameterElement() => element.documentationComment,
    };
  }
}
