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
/// This adds an [Option] with the given properties to [options].
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
@Target({TargetKind.field, TargetKind.parameter})
class Option<T> {
  final String? abbr;
  final String? help;
  final T? valueHelp;
  final bool? negatable; // TODO: only useful for bool options
  final bool? hide;
  final T? defaultsTo; // TODO: this could be a list, if this is a MultiOption
  final List<T>? allowed;
  final Map<T, String>? allowedHelp;
  final List<String>? aliases;

  const Option({
    this.abbr,
    this.help,
    this.defaultsTo,
    this.negatable,
    this.valueHelp,
    this.hide,
    this.allowed,
    this.allowedHelp,
    this.aliases,
  });
}
