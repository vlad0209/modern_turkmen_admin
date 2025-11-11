import 'dart:async';

import 'package:modern_turkmen_admin/data/repositories/exercise/exercise_repository.dart';
import 'package:modern_turkmen_admin/data/services/firestore/firestore_service.dart';
import 'package:modern_turkmen_admin/data/services/firestore/model/exercise/exercise_firestore_model.dart';
import 'package:modern_turkmen_admin/domain/models/exercise/exercise.dart';
import 'package:modern_turkmen_admin/domain/models/exercise_item/exercise_item.dart';

class ExerciseRepositoryFirestore implements ExerciseRepository {
  final FirestoreService _firestoreService;

  ExerciseRepositoryFirestore({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  @override
  FutureOr<Exercise?> getExercise(
      String tutorialId, String languageCode, String exerciseId) async {
    final model = await _firestoreService.getExercise(
        tutorialId, languageCode, exerciseId);
    if (model == null) {
      return null;
    }
    return Exercise(
        id: model.id!,
        items: model.items.map((map) => ExerciseItem.fromJson(map)).toList(),
        description: model.description,
        exampleTranslation: model.exampleTranslation,
        example: model.example,
        orderNumber: model.orderNumber);
  }

  @override
  Future<void> createExercise(
      String tutorialId, String languageCode, Map<String, dynamic> data) async {
  final exercise = ExerciseFirestoreModel.fromJson(data);
    return await _firestoreService.createExercise(
        tutorialId, languageCode, exercise);
  }

  @override
  Future<void> updateExercise(
      String tutorialId, String languageCode, Map<String, dynamic> data) async {
    final exercise = ExerciseFirestoreModel.fromJson(data);
    return await _firestoreService.updateExercise(
        tutorialId, languageCode, exercise);
  }

  @override
  Future<List<Exercise>> getExercises(
      String tutorialId, String languageCode) async {
    final models = await _firestoreService.getExercises(tutorialId, languageCode);
    return models.map((model) {
      return Exercise(
          id: model.id!,
          items: model.items.map((map) => ExerciseItem.fromJson(map)).toList(),
          description: model.description,
          exampleTranslation: model.exampleTranslation,
          example: model.example,
          orderNumber: model.orderNumber);
    }).toList();
  }

  @override
  Future<void> deleteExercise(
      String tutorialId, String languageCode, String exerciseId) async {
    return await _firestoreService.deleteExercise(
        tutorialId, languageCode, exerciseId);
  }
}
