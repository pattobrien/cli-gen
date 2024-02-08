import 'package:code_builder/code_builder.dart';

class TestTypes {
  static TypeReference get string =>
      // Reference('String', 'dart:core').type as TypeReference;
      TypeReference((builder) {
        builder.symbol = 'String';
        builder.url = 'dart:core';
        builder.isNullable = false;
      });

  static TypeReference get bool =>
      Reference('bool', 'dart:core').type as TypeReference;

  static TypeReference get void_ =>
      Reference('void', 'dart:core').type as TypeReference;

  static TypeReference get myFooEnum => TypeReference((builder) {
        builder.symbol = 'MyFooEnum';
        builder.url = 'args_example.dart';
        builder.types.addAll([
          Reference('Enum', 'dart:core'),
        ]);
      });
}
