import 'package:flutter_test/flutter_test.dart';
import 'package:modern_turkmen_admin/domain/models/exercise_item/exercise_item.dart';

void main() {
  group('ExerciseItem', () {
    test('should create ExerciseItem with all required fields', () {
      const exerciseItem = ExerciseItem(
        options: ['option1', 'option2', 'option3'],
        sentence: 'Test sentence',
        sound: 'test_sound.mp3',
        translation: 'Test translation',
        solution: 'option1',
      );

      expect(exerciseItem.options, ['option1', 'option2', 'option3']);
      expect(exerciseItem.sentence, 'Test sentence');
      expect(exerciseItem.sound, 'test_sound.mp3');
      expect(exerciseItem.translation, 'Test translation');
      expect(exerciseItem.solution, 'option1');
    });

    test('should create ExerciseItem with null sound', () {
      const exerciseItem = ExerciseItem(
        options: ['option1', 'option2'],
        sentence: 'Test sentence',
        sound: null,
        translation: 'Test translation',
        solution: 'option1',
      );

      expect(exerciseItem.sound, null);
    });

    test('should serialize to JSON correctly', () {
      const exerciseItem = ExerciseItem(
        options: ['option1', 'option2'],
        sentence: 'Test sentence',
        sound: 'test_sound.mp3',
        translation: 'Test translation',
        solution: 'option1',
      );

      final json = exerciseItem.toJson();

      expect(json['options'], ['option1', 'option2']);
      expect(json['sentence'], 'Test sentence');
      expect(json['sound'], 'test_sound.mp3');
      expect(json['translation'], 'Test translation');
      expect(json['solution'], 'option1');
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'options': ['option1', 'option2'],
        'sentence': 'Test sentence',
        'sound': 'test_sound.mp3',
        'translation': 'Test translation',
        'solution': 'option1',
      };

      final exerciseItem = ExerciseItem.fromJson(json);

      expect(exerciseItem.options, ['option1', 'option2']);
      expect(exerciseItem.sentence, 'Test sentence');
      expect(exerciseItem.sound, 'test_sound.mp3');
      expect(exerciseItem.translation, 'Test translation');
      expect(exerciseItem.solution, 'option1');
    });

    test('should handle null sound in JSON', () {
      final json = {
        'options': ['option1', 'option2'],
        'sentence': 'Test sentence',
        'sound': null,
        'translation': 'Test translation',
        'solution': 'option1',
      };

      final exerciseItem = ExerciseItem.fromJson(json);

      expect(exerciseItem.sound, null);
    });

    test('should support equality comparison', () {
      const exerciseItem1 = ExerciseItem(
        options: ['option1', 'option2'],
        sentence: 'Test sentence',
        sound: 'test_sound.mp3',
        translation: 'Test translation',
        solution: 'option1',
      );

      const exerciseItem2 = ExerciseItem(
        options: ['option1', 'option2'],
        sentence: 'Test sentence',
        sound: 'test_sound.mp3',
        translation: 'Test translation',
        solution: 'option1',
      );

      expect(exerciseItem1, equals(exerciseItem2));
      expect(exerciseItem1.hashCode, equals(exerciseItem2.hashCode));
    });
  });
}