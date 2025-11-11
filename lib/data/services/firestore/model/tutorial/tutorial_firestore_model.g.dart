// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutorial_firestore_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TutorialFirestoreModel _$TutorialFirestoreModelFromJson(
        Map<String, dynamic> json) =>
    _TutorialFirestoreModel(
      id: json['id'] as String,
      contentEn: json['content_en'] as String,
      contentRu: json['content_ru'] as String,
      createdAt: timeFromJson(json['created_at']),
      updatedAt: timeFromJson(json['updated_at']),
      imageUrl: json['image_url'] as String,
      index: (json['index'] as num?)?.toInt(),
      publicEn: json['public_en'] as bool,
      publicRu: json['public_ru'] as bool,
      thumbUrl: json['thumb_url'] as String,
      titleEn: json['title_en'] as String,
      titleRu: json['title_ru'] as String,
    );

Map<String, dynamic> _$TutorialFirestoreModelToJson(
        _TutorialFirestoreModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content_en': instance.contentEn,
      'content_ru': instance.contentRu,
      'image_url': instance.imageUrl,
      'public_en': instance.publicEn,
      'public_ru': instance.publicRu,
      'thumb_url': instance.thumbUrl,
      'title_en': instance.titleEn,
      'title_ru': instance.titleRu,
    };
