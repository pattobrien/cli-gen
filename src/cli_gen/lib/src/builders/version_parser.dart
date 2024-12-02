import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

import '../types/identifiers.dart';

Future<Field?> generateVersionField(
  BuildStep step,
) async {
  final version = await parseVersion(step);
  if (version == null) {
    return null;
  }

  return Field((b) {
    b.name = 'version';
    b.type = Identifiers.dart.string;
    b.modifier = FieldModifier.constant;
    b.assignment = literalString(version).code;
  });
}

Future<String?> parseVersion(
  BuildStep step,
) async {
  final pubspecAsset = AssetId(step.inputId.package, 'pubspec.yaml');

  if (!await step.canRead(pubspecAsset)) {
    return null;
  }

  final pubspecContent = await step.readAsString(pubspecAsset);
  final pubspec = Pubspec.parse(pubspecContent, sourceUrl: pubspecAsset.uri);
  if (pubspec.version == null) {
    return null;
  }

  return pubspec.version.toString();
}
