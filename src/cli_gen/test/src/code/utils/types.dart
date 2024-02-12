import 'package:code_builder/code_builder.dart';

class TestTypes {
  static TypeReference get string =>
      // Reference('String', 'dart:core').type as TypeReference;
      TypeReference((builder) {
        builder.symbol = 'String';
        builder.url = 'dart:core';
        builder.isNullable = false;
      });
  static TypeReference listOf(TypeReference type) => TypeReference((builder) {
        builder.symbol = 'List';
        builder.url = 'dart:core';
        builder.isNullable = false;
        builder.types.add(type);
      });

  static TypeReference get bool => TypeReference((builder) {
        builder.symbol = 'bool';
        builder.url = 'dart:core';
        builder.isNullable = false;
      });

  static TypeReference get uri => TypeReference((builder) {
        builder.symbol = 'Uri';
        builder.url = 'dart:core';
        builder.isNullable = false;
      });

  static TypeReference get void_ =>
      Reference('void', 'dart:core').type as TypeReference;

  static TypeReference get int_ => TypeReference((builder) {
        builder.symbol = 'int';
        builder.url = 'dart:core';
        // builder.isNullable = false;
      });

  static TypeReference get myFooEnum => TypeReference((builder) {
        builder.symbol = 'MyFooEnum';
        builder.url = 'args_example.dart';
        builder.isNullable = false;
        builder.types.addAll([
          Reference('Enum', 'dart:core'),
        ]);
      });
}
