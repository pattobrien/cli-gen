// // ignore: implementation_imports, depend_on_referenced_packages
// import 'package:_fe_analyzer_shared/src/macros/api.dart';

// import 'identifier_part.dart';

// /// A reference to a Macro identifier.
// class MacroIdentifierPart extends IdentifierPart {
//   MacroIdentifierPart(
//     this.identifier,
//     Uri uri,
//   ) : super(identifier.name, uri);

//   final Identifier identifier;

//   @override
//   String get name => identifier.name;

//   @override
//   String toCodeString() => name;

//   @override
//   String toString() {
//     return 'MacroIdentifier{name: $name, uri: $uri}';
//   }

//   @override
//   int get hashCode => name.hashCode ^ uri.hashCode ^ identifier.hashCode;

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is MacroIdentifierPart &&
//         other.name == name &&
//         other.uri == uri &&
//         other.identifier == identifier;
//   }
// }
