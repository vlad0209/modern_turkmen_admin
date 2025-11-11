// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Exercise _$ExerciseFromJson(Map<String, dynamic> json) => _Exercise(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ExerciseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String?,
      exampleTranslation: json['exampleTranslation'] as String?,
      example: json['example'] as String?,
      orderNumber: (json['orderNumber'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ExerciseToJson(_Exercise instance) => <String, dynamic>{
      'id': instance.id,
      'items': instance.items,
      'description': instance.description,
      'exampleTranslation': instance.exampleTranslation,
      'example': instance.example,
      'orderNumber': instance.orderNumber,
    };
