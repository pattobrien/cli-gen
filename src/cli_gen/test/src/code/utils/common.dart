import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart' hide Block;
import 'package:code_builder/code_builder.dart' hide Expression;
import 'package:dart_style/dart_style.dart';

/// Converts a [Code] object into a [CompilationUnit] object.
///
/// NOTE: The returned [CompilationUnit] is not resolved.
CompilationUnit codeToUnresolvedUnit(Code code) {
  final emitter = DartEmitter(useNullSafetySyntax: true);
  final content = code.accept(emitter).toString();
  final formatter = DartFormatter();
  final formattedContent = formatter.format(content);
  return parseString(content: formattedContent).unit;
}
