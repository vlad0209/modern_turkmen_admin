import 'package:flutter_test/flutter_test.dart';
import 'package:modern_turkmen_admin/domain/models/exercise/exercise.dart';
import 'package:modern_turkmen_admin/ui/exercises/ui_state/exercise_ui_state.dart';

void main() {
  group('ExerciseUiState', () {
    test('should create instance with required parameters', () {
      const exercise = Exercise(
        id: '1',
        description: 'Test Description', items: [], exampleTranslation: '', example: '', orderNumber: null,
      );
      const tutorialName = 'Test Tutorial';

      const state = ExerciseUiState(
        exercise: exercise,
        tutorialName: tutorialName,
      );

      expect(state.exercise, equals(exercise));
      expect(state.tutorialName, equals(tutorialName));
    });

    test('should create instance with null exercise', () {
      const tutorialName = 'Test Tutorial';

      const state = ExerciseUiState(
        exercise: null,
        tutorialName: tutorialName,
      );

      expect(state.exercise, isNull);
      expect(state.tutorialName, equals(tutorialName));
    });

    test('should support equality comparison', () {
      const exercise = Exercise(
        id: '1',
        description: 'Test Description', items: [], exampleTranslation: '', example: '', orderNumber: null,
      );
      const tutorialName = 'Test Tutorial';

      const state1 = ExerciseUiState(
        exercise: exercise,
        tutorialName: tutorialName,
      );

      const state2 = ExerciseUiState(
        exercise: exercise,
        tutorialName: tutorialName,
      );

      expect(state1, equals(state2));
    });

    test('should have proper toString representation', () {
      const exercise = Exercise(
        id: '1',
        description: 'Test Description', items: [], exampleTranslation: '', example: '', orderNumber: null,
      );
      const tutorialName = 'Test Tutorial';

      const state = ExerciseUiState(
        exercise: exercise,
        tutorialName: tutorialName,
      );

      expect(state.toString(), contains('ExerciseUiState'));
      expect(state.toString(), contains('exercise'));
      expect(state.toString(), contains('tutorialName'));
    });

    test('should support copyWith method', () {
      const exercise = Exercise(
        id: '1',
        description: 'Test Description', items: [], exampleTranslation: '', example: '', orderNumber: null,
      );
      const tutorialName = 'Test Tutorial';

      const state = ExerciseUiState(
        exercise: exercise,
        tutorialName: tutorialName,
      );

      final updatedState = state.copyWith(tutorialName: 'Updated Tutorial');

      expect(updatedState.exercise, equals(exercise));
      expect(updatedState.tutorialName, equals('Updated Tutorial'));
    });
  });
}