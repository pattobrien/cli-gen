// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'runner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Foo _$FooFromJson(Map<String, dynamic> json) => Foo(
      stringValue: json['stringValue'] as String? ?? 'default',
      boolValue: json['boolValue'] as bool? ?? true,
      intValue: json['intValue'] as int? ?? 42,
    );

Map<String, dynamic> _$FooToJson(Foo instance) => <String, dynamic>{
      'stringValue': instance.stringValue,
      'boolValue': instance.boolValue,
      'intValue': instance.intValue,
    };
