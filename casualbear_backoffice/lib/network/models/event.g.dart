// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      json['id'] as int,
      json['name'] as String,
      json['description'] as String,
      json['selectedColor'] as int,
      json['rawUrl'] as String?,
      json['createdAt'] as String,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'selectedColor': instance.selectedColor,
      'rawUrl': instance.rawUrl,
      'createdAt': instance.createdAt,
    };
