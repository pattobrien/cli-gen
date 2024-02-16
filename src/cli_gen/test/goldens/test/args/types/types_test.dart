// ignore: depend_on_referenced_packages
// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:cli_gen/builder.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

Future<void> main() async {
  final dirPath = Directory.current.path;
  final userFilePath = 'lib/args/types/types.dart';
  final genFilePath = 'lib/args/types/types.g.dart';

  final goldenPath = 'lib/args/types/types.g.golden.dart';

  final fileContents = File(p.join(dirPath, userFilePath)).readAsStringSync();
  final genFileContents = File(p.join(dirPath, genFilePath)).readAsStringSync();
  final goldenContents = File(p.join(dirPath, goldenPath)).readAsStringSync();

  group('types golden tests -', () {
    test('standard values', () async {
      await testBuilder(
        cliGenerator(BuilderOptions({})),
        {
          'a|foo/example.dart': fileContents,
        },
        reader: await PackageAssetReader.currentIsolate(),
        outputs: {
          'a|foo/example.cli_generator.g.part': goldenContents,
        },
      );
    });
  });
}
