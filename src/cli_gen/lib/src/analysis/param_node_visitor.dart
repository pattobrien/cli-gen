// import 'package:analyzer/dart/ast/ast.dart';
// import 'package:analyzer/dart/ast/visitor.dart';
// import 'package:analyzer/dart/element/element.dart';

// class ParameterNodeVisitor extends GeneralizingAstVisitor {
//   const ParameterNodeVisitor(
//     this.parameterElement,
//   );

//   final ParameterElement parameterElement;

//   @override
//   void visitSimpleFormalParameter(SimpleFormalParameter node) {
//     final nameOffset = node.name?.offset;
//     final elementNameOffset = parameterElement.nameOffset;
//     if (nameOffset == elementNameOffset) {
//       print('Found parameter: ${node.name}');
//     }
//     super.visitSimpleFormalParameter(node);
//   }

//   // default parameter
//   @override
//   void visitDefaultFormalParameter(DefaultFormalParameter node) {
//     final nameOffset = node.parameter.name?.offset;
//     final elementNameOffset = parameterElement.nameOffset;
//     if (nameOffset == elementNameOffset) {
//       print('Found parameter: ${node.parameter.name}');
//     }
//     super.visitDefaultFormalParameter(node);
//   }
// }
