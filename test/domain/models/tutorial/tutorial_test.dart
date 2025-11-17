import 'package:flutter_test/flutter_test.dart';
import 'package:modern_turkmen_admin/domain/models/tutorial/tutorial.dart';

void main() {
  group('Tutorial', () {
    const mockTutorial = Tutorial(
      id: 'test-id',
      titleEn: 'Test Title EN',
      titleRu: 'Test Title RU',
      thumbUrl: 'https://example.com/thumb.jpg',
      imageUrl: 'https://example.com/image.jpg',
      contentEn: 'Test content EN',
      contentRu: 'Test content RU',
      publicEn: true,
      publicRu: false,
    );

    test('should create Tutorial instance with all fields', () {
      expect(mockTutorial.id, 'test-id');
      expect(mockTutorial.titleEn, 'Test Title EN');
      expect(mockTutorial.titleRu, 'Test Title RU');
      expect(mockTutorial.thumbUrl, 'https://example.com/thumb.jpg');
      expect(mockTutorial.imageUrl, 'https://example.com/image.jpg');
      expect(mockTutorial.contentEn, 'Test content EN');
      expect(mockTutorial.contentRu, 'Test content RU');
      expect(mockTutorial.publicEn, true);
      expect(mockTutorial.publicRu, false);
    });

    test('should create Tutorial with nullable fields as null', () {
      const tutorial = Tutorial(
        id: 'test-id',
        titleEn: 'Test Title EN',
        titleRu: 'Test Title RU',
        thumbUrl: null,
        imageUrl: null,
        contentEn: null,
        contentRu: null,
        publicEn: true,
        publicRu: false,
      );

      expect(tutorial.thumbUrl, null);
      expect(tutorial.imageUrl, null);
      expect(tutorial.contentEn, null);
      expect(tutorial.contentRu, null);
    });

    test('should serialize to JSON correctly', () {
      final json = mockTutorial.toJson();

      expect(json['id'], 'test-id');
      expect(json['titleEn'], 'Test Title EN');
      expect(json['titleRu'], 'Test Title RU');
      expect(json['thumbUrl'], 'https://example.com/thumb.jpg');
      expect(json['imageUrl'], 'https://example.com/image.jpg');
      expect(json['contentEn'], 'Test content EN');
      expect(json['contentRu'], 'Test content RU');
      expect(json['publicEn'], true);
      expect(json['publicRu'], false);
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 'test-id',
        'titleEn': 'Test Title EN',
        'titleRu': 'Test Title RU',
        'thumbUrl': 'https://example.com/thumb.jpg',
        'imageUrl': 'https://example.com/image.jpg',
        'contentEn': 'Test content EN',
        'contentRu': 'Test content RU',
        'publicEn': true,
        'publicRu': false,
      };

      final tutorial = Tutorial.fromJson(json);

      expect(tutorial.id, 'test-id');
      expect(tutorial.titleEn, 'Test Title EN');
      expect(tutorial.titleRu, 'Test Title RU');
      expect(tutorial.thumbUrl, 'https://example.com/thumb.jpg');
      expect(tutorial.imageUrl, 'https://example.com/image.jpg');
      expect(tutorial.contentEn, 'Test content EN');
      expect(tutorial.contentRu, 'Test content RU');
      expect(tutorial.publicEn, true);
      expect(tutorial.publicRu, false);
    });

    test('should handle null values in JSON', () {
      final json = {
        'id': 'test-id',
        'titleEn': 'Test Title EN',
        'titleRu': 'Test Title RU',
        'thumbUrl': null,
        'imageUrl': null,
        'contentEn': null,
        'contentRu': null,
        'publicEn': true,
        'publicRu': false,
      };

      final tutorial = Tutorial.fromJson(json);

      expect(tutorial.thumbUrl, null);
      expect(tutorial.imageUrl, null);
      expect(tutorial.contentEn, null);
      expect(tutorial.contentRu, null);
    });

    test('should support equality comparison', () {
      const tutorial1 = Tutorial(
        id: 'test-id',
        titleEn: 'Test Title EN',
        titleRu: 'Test Title RU',
        thumbUrl: null,
        imageUrl: null,
        contentEn: null,
        contentRu: null,
        publicEn: true,
        publicRu: false,
      );

      const tutorial2 = Tutorial(
        id: 'test-id',
        titleEn: 'Test Title EN',
        titleRu: 'Test Title RU',
        thumbUrl: null,
        imageUrl: null,
        contentEn: null,
        contentRu: null,
        publicEn: true,
        publicRu: false,
      );

      expect(tutorial1, tutorial2);
      expect(tutorial1.hashCode, tutorial2.hashCode);
    });

    test('should support copyWith method', () {
      final updatedTutorial = mockTutorial.copyWith(
        titleEn: 'Updated Title EN',
        publicEn: false,
      );

      expect(updatedTutorial.titleEn, 'Updated Title EN');
      expect(updatedTutorial.publicEn, false);
      expect(updatedTutorial.id, mockTutorial.id);
      expect(updatedTutorial.titleRu, mockTutorial.titleRu);
    });
  });
}