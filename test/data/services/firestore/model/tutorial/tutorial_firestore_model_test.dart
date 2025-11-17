import 'package:flutter_test/flutter_test.dart';
import 'package:modern_turkmen_admin/data/services/firestore/model/tutorial/tutorial_firestore_model.dart';

void main() {
  group('TutorialFirestoreModel', () {
    test('should create instance with all required fields', () {
      const model = TutorialFirestoreModel(
        contentEn: 'English content',
        contentRu: 'Russian content',
        imageUrl: 'https://example.com/image.jpg',
        publicEn: true,
        publicRu: false,
        thumbUrl: 'https://example.com/thumb.jpg',
        titleEn: 'English title',
        titleRu: 'Russian title',
      );

      expect(model.contentEn, equals('English content'));
      expect(model.contentRu, equals('Russian content'));
      expect(model.imageUrl, equals('https://example.com/image.jpg'));
      expect(model.publicEn, equals(true));
      expect(model.publicRu, equals(false));
      expect(model.thumbUrl, equals('https://example.com/thumb.jpg'));
      expect(model.titleEn, equals('English title'));
      expect(model.titleRu, equals('Russian title'));
    });

    test('should create instance with optional fields', () {
      const model = TutorialFirestoreModel(
        id: 'test-id',
        contentEn: 'Content',
        contentRu: 'Контент',
        imageUrl: 'image.jpg',
        index: 5,
        publicEn: true,
        publicRu: true,
        thumbUrl: 'thumb.jpg',
        titleEn: 'Title',
        titleRu: 'Заголовок',
      );

      expect(model.id, equals('test-id'));
      expect(model.index, equals(5));
    });

    test('should serialize to JSON correctly', () {
      const model = TutorialFirestoreModel(
        id: 'test-id',
        contentEn: 'Content',
        contentRu: 'Контент',
        imageUrl: 'image.jpg',
        index: 5,
        publicEn: true,
        publicRu: false,
        thumbUrl: 'thumb.jpg',
        titleEn: 'Title',
        titleRu: 'Заголовок',
      );

      final json = model.toJson();

      expect(json['content_en'], equals('Content'));
      expect(json['content_ru'], equals('Контент'));
      expect(json['image_url'], equals('image.jpg'));
      expect(json['public_en'], equals(true));
      expect(json['public_ru'], equals(false));
      expect(json['thumb_url'], equals('thumb.jpg'));
      expect(json['title_en'], equals('Title'));
      expect(json['title_ru'], equals('Заголовок'));
      expect(json.containsKey('id'), isFalse);
      expect(json.containsKey('index'), isFalse);
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 'test-id',
        'content_en': 'Content',
        'content_ru': 'Контент',
        'image_url': 'image.jpg',
        'index': 5,
        'public_en': true,
        'public_ru': false,
        'thumb_url': 'thumb.jpg',
        'title_en': 'Title',
        'title_ru': 'Заголовок',
      };

      final model = TutorialFirestoreModel.fromJson(json);

      expect(model.id, equals('test-id'));
      expect(model.contentEn, equals('Content'));
      expect(model.contentRu, equals('Контент'));
      expect(model.imageUrl, equals('image.jpg'));
      expect(model.index, equals(5));
      expect(model.publicEn, equals(true));
      expect(model.publicRu, equals(false));
      expect(model.thumbUrl, equals('thumb.jpg'));
      expect(model.titleEn, equals('Title'));
      expect(model.titleRu, equals('Заголовок'));
    });

    test('should handle equality correctly', () {
      const model1 = TutorialFirestoreModel(
        contentEn: 'Content',
        contentRu: 'Контент',
        imageUrl: 'image.jpg',
        publicEn: true,
        publicRu: false,
        thumbUrl: 'thumb.jpg',
        titleEn: 'Title',
        titleRu: 'Заголовок',
      );

      const model2 = TutorialFirestoreModel(
        contentEn: 'Content',
        contentRu: 'Контент',
        imageUrl: 'image.jpg',
        publicEn: true,
        publicRu: false,
        thumbUrl: 'thumb.jpg',
        titleEn: 'Title',
        titleRu: 'Заголовок',
      );

      expect(model1, equals(model2));
      expect(model1.hashCode, equals(model2.hashCode));
    });

    test('should handle copyWith correctly', () {
      const original = TutorialFirestoreModel(
        contentEn: 'Original content',
        contentRu: 'Оригинальный контент',
        imageUrl: 'original.jpg',
        publicEn: true,
        publicRu: false,
        thumbUrl: 'original_thumb.jpg',
        titleEn: 'Original title',
        titleRu: 'Оригинальный заголовок',
      );

      final updated = original.copyWith(
        titleEn: 'Updated title',
        publicEn: false,
      );

      expect(updated.titleEn, equals('Updated title'));
      expect(updated.publicEn, equals(false));
      expect(updated.contentEn, equals('Original content'));
      expect(updated.titleRu, equals('Оригинальный заголовок'));
    });
  });
}