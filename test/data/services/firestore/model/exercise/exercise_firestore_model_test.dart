import 'package:flutter_test/flutter_test.dart';
import 'package:modern_turkmen_admin/data/services/firestore/model/exercise/exercise_firestore_model.dart';

void main() {
  group('ExerciseFirestoreModel', () {
    test('should create instance with required fields', () {
      const model = ExerciseFirestoreModel(
        description: 'Test description',
        example: 'Test example',
        items: [{'key': 'value'}],
        orderNumber: 1,
      );

      expect(model.description, 'Test description');
      expect(model.example, 'Test example');
      expect(model.items, [{'key': 'value'}]);
      expect(model.orderNumber, 1);
      expect(model.id, isNull);
      expect(model.exampleTranslation, isNull);
    });

    test('should create instance with all fields', () {
      const model = ExerciseFirestoreModel(
        id: 'test-id',
        description: 'Test description',
        example: 'Test example',
        items: [{'key': 'value'}],
        orderNumber: 1,
        exampleTranslation: 'Test translation',
      );

      expect(model.id, 'test-id');
      expect(model.description, 'Test description');
      expect(model.example, 'Test example');
      expect(model.items, [{'key': 'value'}]);
      expect(model.orderNumber, 1);
      expect(model.exampleTranslation, 'Test translation');
    });

    test('should create from JSON', () {
      final json = {
        'id': 'test-id',
        'description': 'Test description',
        'example': 'Test example',
        'items': [{'key': 'value'}],
        'order_number': 1,
        'example_translation': 'Test translation',
      };

      final model = ExerciseFirestoreModel.fromJson(json);

      expect(model.id, 'test-id');
      expect(model.description, 'Test description');
      expect(model.example, 'Test example');
      expect(model.items, [{'key': 'value'}]);
      expect(model.orderNumber, 1);
      expect(model.exampleTranslation, 'Test translation');
    });

    test('should create from JSON with missing optional fields', () {
      final json = {
        'description': 'Test description',
        'example': 'Test example',
        'items': [{'key': 'value'}],
        'order_number': 1,
      };

      final model = ExerciseFirestoreModel.fromJson(json);

      expect(model.description, 'Test description');
      expect(model.example, 'Test example');
      expect(model.items, [{'key': 'value'}]);
      expect(model.orderNumber, 1);
      expect(model.id, isNull);
      expect(model.exampleTranslation, isNull);
    });

    test('should convert to JSON', () {
      const model = ExerciseFirestoreModel(
        id: 'test-id',
        description: 'Test description',
        example: 'Test example',
        items: [{'key': 'value'}],
        orderNumber: 1,
        exampleTranslation: 'Test translation',
      );

      final json = model.toJson();

      expect(json['description'], 'Test description');
      expect(json['example'], 'Test example');
      expect(json['items'], [{'key': 'value'}]);
      expect(json['order_number'], 1);
      expect(json['example_translation'], 'Test translation');
      expect(json.containsKey('id'), isFalse);
    });

    test('should support equality comparison', () {
      const model1 = ExerciseFirestoreModel(
        description: 'Test description',
        example: 'Test example',
        items: [{'key': 'value'}],
        orderNumber: 1,
      );

      const model2 = ExerciseFirestoreModel(
        description: 'Test description',
        example: 'Test example',
        items: [{'key': 'value'}],
        orderNumber: 1,
      );

      const model3 = ExerciseFirestoreModel(
        description: 'Different description',
        example: 'Test example',
        items: [{'key': 'value'}],
        orderNumber: 1,
      );

      expect(model1, equals(model2));
      expect(model1, isNot(equals(model3)));
    });
  });
}