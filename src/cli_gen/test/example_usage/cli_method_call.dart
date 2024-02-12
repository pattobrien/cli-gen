enum MyFooEnum {
  value1,
  value2;

  factory MyFooEnum.parse(String value) {
    return MyFooEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError(
        'Invalid value for MyFooEnum: $value',
      ),
    );
  }
}
