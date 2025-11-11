import 'package:freezed_annotation/freezed_annotation.dart';

part 'tutorial.freezed.dart';
part 'tutorial.g.dart';


@freezed
abstract class Tutorial with _$Tutorial {
  const factory Tutorial({
    required String id,
    required String titleEn,
    required String titleRu,
    required String? thumbUrl,
    required String? imageUrl,
    required String? contentEn,
    required String? contentRu,
    required DateTime? updatedAt,
    required bool publicEn,
    required bool publicRu,
  }) = _Tutorial;
  factory Tutorial.fromJson(Map<String, dynamic> json) =>
      _$TutorialFromJson(json);
}