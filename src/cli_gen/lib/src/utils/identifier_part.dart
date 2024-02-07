import 'package:code_builder/code_builder.dart';

sealed class EmitterPart {
  const EmitterPart();

  String toCodeString();
}

class StringPart implements EmitterPart {
  final String code;

  const StringPart(this.code);

  @override
  String toCodeString() => code;

  @override
  String toString() {
    return 'StringPart{code: $code}';
  }

  @override
  int get hashCode => code.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StringPart && other.code == code;
  }
}

class IdentifierPart extends Reference implements EmitterPart {
  final String name;
  final Uri uri;

  IdentifierPart(this.name, this.uri) : super(name, uri.toString());

  factory IdentifierPart.fromStrings(String name, String uri) {
    return IdentifierPart(name, Uri.parse(uri));
  }

  @override
  String toCodeString() => name;

  @override
  String toString() {
    return 'IdentifierPart{name: $name, uri: $uri}';
  }

  @override
  int get hashCode => name.hashCode ^ uri.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IdentifierPart && other.name == name && other.uri == uri;
  }
}
