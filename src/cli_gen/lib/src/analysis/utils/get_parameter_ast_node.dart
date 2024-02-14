import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

extension ParameterAstNodeX on ParameterElement {
  Future<FormalParameter> asAstNode(Resolver resolver) async {
    final result = await resolver.astNodeFor(this);
    if (result is! FormalParameter) {
      throw InvalidGenerationSourceError(
        'Expected a FormalParameter, but got $result',
        element: this,
      );
    }

    return result;
  }
}
