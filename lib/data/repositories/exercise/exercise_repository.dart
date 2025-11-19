import 'dart:async';
import 'package:modern_turkmen_admin/domain/models/exercise/exercise.dart';

abstract class ExerciseRepository {
  FutureOr<Exercise?> getExercise(String tutorialId, String languageCode, String exerciseId);

  Future<String> createExercise(String tutorialId, String languageCode, Map<String, dynamic> data);

  Future<void> updateExercise(String tutorialId, String languageCode, Map<String, dynamic> data);

  Future<List<Exercise>> getExercises(String tutorialId, String languageCode);

  Future<void> deleteExercise(String tutorialId, String languageCode, String exerciseId);
}