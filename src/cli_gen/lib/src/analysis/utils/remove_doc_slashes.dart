/// Removes the `///` from the beginning of a doc comment.
String? removeDocSlashes(
  String? docComment, {
  bool firstLineOnly = true,
}) {
  if (docComment == null) {
    return null;
  }

  final allLines = docComment.split('\n');
  final cleanedLines = allLines.map((line) {
    if (line.startsWith('///')) {
      return line.substring(3).trim();
    }
    return line;
  });

  if (firstLineOnly) {
    return cleanedLines.first;
  }

  return cleanedLines.join('\n');
}
