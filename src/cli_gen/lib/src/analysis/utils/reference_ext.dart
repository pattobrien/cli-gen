import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart' hide FunctionType;

import '../../types/identifiers.dart';

extension IdentifierToRefExt on Identifier {
  Reference toRef() {
    return refer(
      name,
      staticElement!.librarySource?.uri.toString(),
    );
  }
}

extension TypeAnnotationToRefExt on TypeAnnotation {
  TypeReference toTypeRef() {
    final thisNode = this;
    switch (thisNode) {
      case NamedType():
        return TypeReference((builder) {
          builder.symbol = thisNode.name2.lexeme;
          builder.url = thisNode.element?.librarySource?.uri.toString();

          final args = thisNode.typeArguments?.arguments ?? <TypeAnnotation>[];
          builder.types.addAll(args.map((e) => e.toTypeRef()));
        });
      default:
        throw UnimplementedError(
          'Only NamedType is supported for TypeAnnotation.toTypeRef() method.',
        );
    }
  }
}

extension TypeRefExt on Reference {
  TypeReference toTypeRef({
    List<Reference> typeArguments = const [],
    bool? isNullable,
  }) {
    final typeRef = type as TypeReference;
    return typeRef.rebuild((b) {
      b.types.addAll(typeArguments);
      b.isNullable = isNullable ?? b.isNullable;
    });
  }
}

extension ParameterElementToRefExt on ParameterElement {
  Reference toRef() {
    return refer(
      name,
      librarySource?.uri.toString(),
    );
  }
}

extension ExecutableElementToRefExt on ExecutableElement {
  TypeReference toRef() {
    return TypeReference((builder) {
      builder.symbol = name;
      builder.url = librarySource.uri.toString();
      builder.types.addAll(
        typeParameters.map((e) => refer(e.name, librarySource.uri.toString())),
      );
    });
  }
}

extension ClassElementToRefExt on ClassElement {
  Reference toRef() {
    return refer(
      name,
      librarySource.uri.toString(),
    );
  }
}

extension MethodElementToRefExt on MethodElement {
  Reference toRef() {
    return refer(
      name,
      librarySource.uri.toString(),
    );
  }
}

extension FieldElementToRefExt on FieldElement {
  Reference toRef() {
    return refer(
      name,
      library.source.uri.toString(),
    );
  }
}

extension VariableElementToRefExt on VariableElement {
  Reference toRef() {
    return refer(
      name,
      library?.source.uri.toString(),
    );
  }
}

extension DartTypeExt on DartType {
  TypeReference toTypeRef() {
    if (this is InterfaceType) {
      final thisType = this as InterfaceType;
      final element = thisType.element;
      return TypeReference((builder) {
        builder.symbol = element.name;
        builder.url = element.librarySource.uri.toString();
        builder.isNullable = nullabilitySuffix == NullabilitySuffix.question;
        builder.types.addAll(
          thisType.typeArguments.map((e) => e.toTypeRef()),
        );
      });
    }
    if (this is VoidType) {
      return Identifiers.dart.void_.toTypeRef();
    }
    if (this is DynamicType) {
      return Identifiers.dart.dynamic.toTypeRef();
    }

    throw UnimplementedError(
      'Only InterfaceType is supported for DartType.toRef() method.',
    );
  }
}

extension InterfaceElementExt on InterfaceElement {
  Reference toRef() {
    return refer(
      name,
      librarySource.uri.toString(),
    );
  }
}
