import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../config/dependencies.dart';
import '../../../data/repositories/exercise/exercise_repository.dart';
import '../../../data/repositories/tutorial/tutorial_repository.dart';
import '../ui_state/exercises_list_ui_state.dart';

part 'exercises_list_view_model.g.dart';

@riverpod
class ExercisesListViewModel extends _$ExercisesListViewModel {
  late TutorialRepository _tutorialRepository;
  late ExerciseRepository _exerciseRepository;
  @override
  FutureOr<ExercisesListUiState> build(String tutorialId, String languageCode) async {
    _tutorialRepository = ref.watch(tutorialRepositoryProvider);
    _exerciseRepository = ref.watch(exerciseRepositoryProvider);
    final tutorial =
        await _tutorialRepository.getTutorial(tutorialId);
    final exercises = await _exerciseRepository.getExercises(
        tutorialId, languageCode);
    return ExercisesListUiState(
        exercises: exercises, tutorialName: tutorial.titleEn);
  }

  Future<void> deleteExercise(String exerciseId) async {
    await _exerciseRepository.deleteExercise(
        tutorialId, languageCode, exerciseId);
    ref.invalidateSelf();
  }
}