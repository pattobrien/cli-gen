import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart' hide FunctionType;

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
          builder.url = thisNode.element!.librarySource!.uri.toString();

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
  }) {
    final typeRef = type as TypeReference;
    return typeRef.rebuild((b) {
      b.types.addAll(typeArguments);
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
    // return refer(
    //   name,
    //   librarySource.uri.toString(),
    // );
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

extension DartTypeExt on DartType {
  Reference toRef() {
    if (this is InterfaceType) {
      final ref = (this as InterfaceType).toRef();
      final isNull = nullabilitySuffix == NullabilitySuffix.question;
      return ref.rebuild((b) => b.isNullable = isNull);
    }
    if (this is VoidType) {
      return refer('void');
    }

    throw UnimplementedError(
      'Only InterfaceType is supported for DartType.toRef() method.',
    );
  }
}

extension InterfaceTypeExt on InterfaceType {
  TypeReference toRef() {
    return TypeReference((builder) {
      builder.symbol = element.name;
      builder.url = element.librarySource.uri.toString();
      builder.types.addAll(
        typeArguments.map((e) => e.toRef()),
      );
    });
    // return refer(
    //   element.name,
    //   element.librarySource.uri.toString(),
    // );
  }
}

// extension FunctionTypeExt on FunctionType {
//   Reference toRef() {
//     return refer(
//       getDisplayString(withNullability: false),
//     );
//   }
// }

extension InterfaceElementExt on InterfaceElement {
  Reference toRef() {
    return refer(
      name,
      librarySource.uri.toString(),
    );
  }
}
