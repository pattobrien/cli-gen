// import 'package:args/args.dart';
// import 'package:args/command_runner.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'runner.g.dart';

// void main() async {
//   final runner = ExampleRunner();
//   final args = ['example', '--foo', 'bar']; // explicit option supplied
//   await runner.run(args);

//   final args2 = ['example']; // no explicit option supplied
//   await runner.run(args2);
// }

// class ExampleRunner extends CommandRunner {
//   ExampleRunner() : super('example', 'Example command runner.') {
//     addCommand(ExampleCommand());
//   }
// }

// class ExampleCommand extends Command {
//   @override
//   String get description => 'Example command description.';

//   @override
//   String get name => 'example';

//   @override
//   ArgParser get argParser => ArgParser()
//     ..addOption(
//       'foo',
//       abbr: 'f',
//       mandatory: false,
//       defaultsTo: 'default',
//     )
//     ..addMultiOption(
//       'bar',
//       abbr: 'b',
//       splitCommas: true,
//     )
//     ..addFlag(
//       'bar',
//       abbr: 'b',
//       negatable: false,
//     );

//   @override
//   run() {
//     final results = argResults!;

//     userFunction(
//       results['bar'] as List<String>,
//       foo: results['foo'] as String,
//       baz: results['baz'] != null ? int.parse(results['baz']) : null,
//       email: results.wasParsed(
//               'email') // conditional to check if option was supplied (only necessary for `canBeNull` parameters)
//           ? Email.parse(results['email']) // the `parse` method
//           : const Email('default'), // copied from `defaultValueCode`
//     );
//   }
// }

// void userFunction(
//   List<String> bar, {
//   required String foo,
//   int? baz = 42,
//   Email email = const Email('default'),
// }) {
//   throw UnimplementedError();
// }

// extension type const Email(String value) {
//   factory Email.parse(String value) {
//     // check if value is valid
//     final regexp = RegExp(r'^\S+@\S+\.\S+$');
//     if (!regexp.hasMatch(value)) {
//       throw ArgumentError('Invalid email address');
//     }
//     return Email(value);
//   }
// }

// @JsonSerializable()
// class Foo {
//   final String stringValue;
//   final bool boolValue;
//   final int intValue;
//   final Bar bar;

//   const Foo({
//     this.stringValue = 'default',
//     this.boolValue = true,
//     this.intValue = 42,
//     this.bar = const Bar('default'),
//   });

//   factory Foo.fromJson(Map<String, dynamic> json) => _$FooFromJson(json);
// }

// extension type const Bar(String val) {
//   factory Bar.fromJson(Map<String, dynamic> json) {
//     return Bar(json['val'] as String);
//   }
// }
