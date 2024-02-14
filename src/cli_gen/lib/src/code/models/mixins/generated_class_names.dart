import 'package:recase/recase.dart';

mixin GeneratedClassNames {
  String get userClassName;

  /// The name that will be used for the executable.
  ///
  /// The logic for determining the executable name is as follows:
  /// - TODO: if a name is provided in an annotation, that will be used
  /// - otherwise, the name of the annotated class will be used, with the following
  ///   transformations:
  ///   - if the name ends with `Runner` or `Command` or `CommandRunner`, remove those suffixes
  ///   - convert to hyphen-case (e.g. `DartGit` -> `dart-git`)
  String get executableName {
    final regex = RegExp(r'Runner$|Command$|CommandRunner$|Subcommand$');
    return userClassName.replaceAll(regex, '').paramCase;
  }

  /// The name of the generated Runner class.
  String get generatedClassName => '_\$$userClassName';
}
