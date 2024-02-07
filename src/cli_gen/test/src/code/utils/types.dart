import 'package:code_builder/code_builder.dart';

class TestTypes {
  static TypeReference get string =>
      Reference('String', 'dart:core').type as TypeReference;

  static TypeReference get bool =>
      Reference('bool', 'dart:core').type as TypeReference;
}
