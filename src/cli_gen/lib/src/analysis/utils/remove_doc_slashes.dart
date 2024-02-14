/// Removes the `///` from the beginning of a doc comment.
String? removeDocSlashes(String? docComment) {
  if (docComment == null) {
    return null;
  }

  final lines = docComment.split('\n');
  final result = lines.map((line) {
    if (line.startsWith('///')) {
      return line.substring(3).trim();
    }
    return line;
  }).join('\n');

  return result;
}
