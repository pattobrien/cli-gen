import 'package:args/args.dart';
import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';

/// Used to annotated arguments to a CLI command.
///
/// This annotation will instruct `cli_gen` to generate an `ArgParser` that
/// represents all of the parameters/fields associated with the annotated
/// declaration.
@Target({TargetKind.classType, TargetKind.method, TargetKind.typedefType})
class CliArgs {
  const CliArgs();
}

const cliArgs = CliArgs();

/// Defines an option that takes a value.
///
/// {@template cliCommand}
/// Each argument is added to the argument of the same name in the generated
/// [ArgParser].
///
/// The [abbr] argument is a single-character string that can be used as a
/// shorthand for this option. For example, `abbr: "a"` will allow the user to
/// pass `-a value` or `-avalue`.
///
/// The [help] argument is used by [usage] to describe this option.
///
/// The [valueHelp] argument is used by [usage] as a name for the value this
/// option takes. For example, `valueHelp: "FOO"` will include
/// `--option=<FOO>` rather than just `--option` in the usage string.
///
/// The [allowed] argument is a list of valid values for this option. If
/// it's non-`null` and the user passes a value that's not included in the
/// list, [parse] will throw a [FormatException]. The allowed values will also
/// be included in [usage].
///
/// The [allowedHelp] argument is a map from values in [allowed] to
/// documentation for those values that will be included in [usage].
///
/// The [defaultsTo] argument indicates the value this option will have if the
/// user doesn't explicitly pass it in (or `null` by default).
///
/// If [hide] is `true`, this option won't be included in [usage].
///
/// If [aliases] is provided, these are used as aliases for [name]. These
/// aliases will not appear as keys in the [options] map.
///
/// Throws an [ArgumentError] if:
///
/// * There is already an option with name [name].
/// * There is already an option using abbreviation [abbr].
/// {@endtemplate}
@Target({TargetKind.field, TargetKind.parameter})
sealed class BaseOption<T> {
  final String? abbr;
  final String? help;
  final T? valueHelp;
  final bool? negatable; // only useful for bool options
  final bool? hide;
  final Object? defaultsTo; // this could be a list, if this is a MultiOption
  final List<T>? allowed;
  // not yet implemented
  @experimental
  final Map<T, String>? allowedHelp;
  final List<String>? aliases;
  final bool? splitCommas; // this only applies for MultiOption

  const BaseOption({
    this.abbr,
    this.help,
    this.defaultsTo,
    this.negatable,
    this.valueHelp,
    this.hide,
    this.allowed,
    this.allowedHelp,
    this.aliases,
    this.splitCommas,
  });
}

/// Defines a non-boolean option that takes a single value.
///
/// {@macro cliCommand}
@Target({TargetKind.field, TargetKind.parameter})
class Option<T> extends BaseOption<T> {
  const Option({
    super.abbr,
    super.help,
    super.valueHelp,
    super.hide,
    super.allowed,
    super.allowedHelp,
    super.aliases,
    T? super.defaultsTo,
    this.parser,
  });

  final T Function(String)? parser;
}

/// Defines a non-boolean option that can take multiple values.
///
/// Should be used on a parameter that has any Collection type, such as [List],
/// [Set], or [Iterable].
///
/// {@macro cliCommand}
@Target({TargetKind.field, TargetKind.parameter})
class MultiOption<T> extends BaseOption<T> {
  const MultiOption({
    super.abbr,
    super.help,
    super.valueHelp,
    super.hide,
    super.allowed,
    super.allowedHelp,
    super.aliases,
    super.splitCommas,
    List<T>? super.defaultsTo,
    this.parser,
  });

  final List<T> Function(List<String>)? parser;
}

/// Defines a boolean option that can be negated.
///
/// {@macro cliCommand}
@Target({TargetKind.field, TargetKind.parameter})
class Flag<T> extends BaseOption<T> {
  const Flag({
    super.abbr,
    super.help,
    super.negatable,
    super.hide,
    super.aliases,
    T? super.defaultsTo,
    this.parser,
  });

  final T Function(String)? parser;
}
