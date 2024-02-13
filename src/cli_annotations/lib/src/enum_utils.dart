extension EnumFromString on Enum {
  /// Returns the enum constant that matches the given [value].
  static T fromString<T extends Enum>(String value, List<T> values) {
    return values.firstWhere((e) => e.name == value);
  }
}

class EnumParser<T extends Enum> {
  final List<T> values;

  const EnumParser(this.values);

  T parse(String value) {
    return EnumFromString.fromString(value, values);
  }
}

// -- example usage --
enum MyEnum { a, b, c }

void main() {
  final value = EnumFromString.fromString('b', MyEnum.values);
  print(value); // MyEnum.b

  const parser = EnumParser(MyEnum.values);
  final parsed = parser.parse('c');
  print(parsed); // MyEnum.c
}
