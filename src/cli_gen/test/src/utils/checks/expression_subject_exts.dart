import 'package:analyzer/dart/ast/ast.dart';
import 'package:checks/checks.dart';

extension MethodInvocationX on Subject<MethodInvocation> {
  Subject<Expression> hasSingleArg() {
    return has((p0) => p0.argumentList.arguments.single, 'single argument');
  }

  void hasMethodNamed(String name) {
    has((p0) => p0.methodName.name, 'method name').equals(name);
  }

  Subject<Expression?> hasRealTarget() {
    return has((p0) => p0.realTarget, 'real target');
  }

  void hasRealTargetNamed(String name) {
    has((p0) => p0.realTarget, 'type target')
        .isA<SimpleIdentifier>()
        .has((p0) => p0.name, 'type name')
        .equals(name);
  }
}

extension IndexExpressionSubject on Subject<IndexExpression> {
  void hasTargetNamed(String name) {
    has((p0) => p0.target, 'name')
        .isA<SimpleIdentifier>()
        .has((p0) => p0.name, 'name')
        .equals(name);
  }

  void hasKeyNamed(String name) {
    has((p0) => p0.index, 'index expression')
        .isA<SimpleStringLiteral>()
        .has((p0) => p0.value, 'key value')
        .equals(name);
  }
}

extension NamedExpressionX on Subject<NamedExpression> {
  void hasLabelNamed(String name) {
    has((p0) => p0.name.label.name, 'label name').equals(name);
  }
}

extension NamedTypeX on Subject<NamedType> {
  void hasName(String name) {
    has((p0) => p0.name2.lexeme, 'name').equals(name);
  }

  Subject<TypeAnnotation> hasSingleTypeArg() {
    return has((p0) => p0.typeArguments?.arguments.single, 'type arguments')
        .isNotNull();
  }
}

extension InstanceCreationExpressionX on Subject<InstanceCreationExpression> {
  Subject<NamedType> hasType() {
    return has((p0) => p0.constructorName.type, 'type name');
  }

  Subject<Expression> hasSingleArg() {
    return has((p0) => p0.argumentList.arguments.single, 'single argument');
  }
}
