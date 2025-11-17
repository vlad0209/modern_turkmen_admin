import 'package:flutter_test/flutter_test.dart';
import 'package:modern_turkmen_admin/domain/models/exercise/exercise.dart';
import 'package:modern_turkmen_admin/ui/exercises/ui_state/exercises_list_ui_state.dart';

void main() {
  group('ExercisesListUiState', () {
    test('should create instance with required parameters', () {
      const state = ExercisesListUiState(
        exercises: null,
        tutorialName: 'Test Tutorial',
      );

      expect(state.exercises, isNull);
      expect(state.tutorialName, equals('Test Tutorial'));
    });

    test('should create instance with exercises list', () {
      const exercises = <Exercise>[];
      const state = ExercisesListUiState(
        exercises: exercises,
        tutorialName: 'Test Tutorial',
      );

      expect(state.exercises, equals(exercises));
      expect(state.tutorialName, equals('Test Tutorial'));
    });

    test('should support equality', () {
      const state1 = ExercisesListUiState(
        exercises: null,
        tutorialName: 'Test Tutorial',
      );
      const state2 = ExercisesListUiState(
        exercises: null,
        tutorialName: 'Test Tutorial',
      );

      expect(state1, equals(state2));
    });

    test('should support copyWith', () {
      const originalState = ExercisesListUiState(
        exercises: null,
        tutorialName: 'Test Tutorial',
      );

      final newState = originalState.copyWith(
        tutorialName: 'Updated Tutorial',
      );

      expect(newState.exercises, isNull);
      expect(newState.tutorialName, equals('Updated Tutorial'));
    });
  });
}