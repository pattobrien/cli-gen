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
  final userFilePath = 'lib/args/default_values/default_values.dart';
  final genFilePath = 'lib/args/default_values/default_values.g.dart';

  final goldenPath = 'lib/args/default_values/default_values.g.golden.dart';

  final fileContents = File(p.join(dirPath, userFilePath)).readAsStringSync();
  final genFileContents = File(p.join(dirPath, genFilePath)).readAsStringSync();
  final goldenContents = File(p.join(dirPath, goldenPath)).readAsStringSync();

  group('default values golden tests -', () {
    test('standard values', () async {
      await testBuilder(
        cliGenerator(BuilderOptions({})),
        {
          'a|foo/default_values.dart': fileContents,
        },
        reader: await PackageAssetReader.currentIsolate(),
        outputs: {
          'a|foo/default_values.cli_generator.g.part': goldenContents,
        },
      );
    });
  });
}
