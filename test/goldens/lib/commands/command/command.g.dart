// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'command.dart';

// **************************************************************************
// SubcommandGenerator
// **************************************************************************

class _$FooBarSubcommand<T extends dynamic> extends Command<int> {
  _$FooBarSubcommand() {
    final upcastedType = (this as FooBarSubcommand);
    addSubcommand(FooCommand(upcastedType.foo));
    addSubcommand(BarCommand(upcastedType.bar));
  }

  @override
  String get name => 'foo-bar';

  @override
  String get description => '';
}

class FooCommand extends Command<int> {
  FooCommand(this.userMethod);

  final int Function() userMethod;

  @override
  String get name => 'foo';

  @override
  String get description => '';

  @override
  int run() {
    return userMethod();
  }
}

class BarCommand extends Command<int> {
  BarCommand(this.userMethod);

  final int Function() userMethod;

  @override
  String get name => 'bar';

  @override
  String get description => '';

  @override
  int run() {
    return userMethod();
  }
}
