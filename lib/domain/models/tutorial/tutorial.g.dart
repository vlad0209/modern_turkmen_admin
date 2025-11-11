// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutorial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Tutorial _$TutorialFromJson(Map<String, dynamic> json) => _Tutorial(
      id: json['id'] as String,
      titleEn: json['titleEn'] as String,
      titleRu: json['titleRu'] as String,
      thumbUrl: json['thumbUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
      contentEn: json['contentEn'] as String?,
      contentRu: json['contentRu'] as String?,
      publicEn: json['publicEn'] as bool,
      publicRu: json['publicRu'] as bool,
    );

Map<String, dynamic> _$TutorialToJson(_Tutorial instance) => <String, dynamic>{
      'id': instance.id,
      'titleEn': instance.titleEn,
      'titleRu': instance.titleRu,
      'thumbUrl': instance.thumbUrl,
      'imageUrl': instance.imageUrl,
      'contentEn': instance.contentEn,
      'contentRu': instance.contentRu,
      'publicEn': instance.publicEn,
      'publicRu': instance.publicRu,
    };
