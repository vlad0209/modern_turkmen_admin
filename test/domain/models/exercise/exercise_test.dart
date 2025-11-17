import 'package:flutter_test/flutter_test.dart';
import 'package:modern_turkmen_admin/domain/models/exercise/exercise.dart';
import 'package:modern_turkmen_admin/domain/models/exercise_item/exercise_item.dart';

void main() {
  group('Exercise', () {
    test('should create Exercise with all fields', () {
      const exercise = Exercise(
        id: 'test-id',
        items: [ExerciseItem(options: [], sentence: '', sound: '', translation: '', solution: '')],
        description: 'Test description',
        exampleTranslation: 'Test translation',
        example: 'Test example',
        orderNumber: 1,
      );

      expect(exercise.id, 'test-id');
      expect(exercise.items?.length, 1);
      expect(exercise.description, 'Test description');
      expect(exercise.exampleTranslation, 'Test translation');
      expect(exercise.example, 'Test example');
      expect(exercise.orderNumber, 1);
    });

    test('should create Exercise with nullable fields as null', () {
      const exercise = Exercise(
        id: 'test-id',
        items: null,
        description: null,
        exampleTranslation: null,
        example: null,
        orderNumber: null,
      );

      expect(exercise.id, 'test-id');
      expect(exercise.items, null);
      expect(exercise.description, null);
      expect(exercise.exampleTranslation, null);
      expect(exercise.example, null);
      expect(exercise.orderNumber, null);
    });

    test('should serialize to JSON correctly', () {
      const exercise = Exercise(
        id: 'test-id',
        items: null,
        description: 'Test description',
        exampleTranslation: null,
        example: 'Test example',
        orderNumber: 1,
      );

      final json = exercise.toJson();

      expect(json['id'], 'test-id');
      expect(json['description'], 'Test description');
      expect(json['example'], 'Test example');
      expect(json['orderNumber'], 1);
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 'test-id',
        'items': null,
        'description': 'Test description',
        'exampleTranslation': 'Test translation',
        'example': 'Test example',
        'orderNumber': 1,
      };

      final exercise = Exercise.fromJson(json);

      expect(exercise.id, 'test-id');
      expect(exercise.description, 'Test description');
      expect(exercise.exampleTranslation, 'Test translation');
      expect(exercise.example, 'Test example');
      expect(exercise.orderNumber, 1);
    });

    test('should support equality comparison', () {
      const exercise1 = Exercise(
        id: 'test-id',
        items: null,
        description: 'Test description',
        exampleTranslation: null,
        example: 'Test example',
        orderNumber: 1,
      );

      const exercise2 = Exercise(
        id: 'test-id',
        items: null,
        description: 'Test description',
        exampleTranslation: null,
        example: 'Test example',
        orderNumber: 1,
      );

      expect(exercise1, exercise2);
      expect(exercise1.hashCode, exercise2.hashCode);
    });
  });
}