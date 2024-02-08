import 'package:test/test.dart';

import '../utils/analyzer_parsers.dart';

void main() {
  group('cli method call builder ...', () {
    // TODO: Implement test
    final invocationExp = generateArgResultHandlerExp();
    test('', () {
      print('invocationExp: $invocationExp');
    });
  });
}
