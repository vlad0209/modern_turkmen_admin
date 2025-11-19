import 'package:modern_turkmen_admin/data/repositories/audio/audio_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../config/dependencies.dart';
import '../../../data/repositories/exercise/exercise_repository.dart';
import '../../../data/repositories/tutorial/tutorial_repository.dart';
import '../../../domain/models/exercise/exercise.dart';
import '../ui_state/exercise_ui_state.dart';

part 'exercise_view_model.g.dart';

@riverpod
class ExerciseViewModel extends _$ExerciseViewModel {
  late TutorialRepository _tutorialRepository;
  late ExerciseRepository _exerciseRepository;
  late AudioRepository _audioRepository;

  @override
  FutureOr<ExerciseUiState> build(
      String tutorialId, String languageCode, String? exerciseId) async {
    _tutorialRepository = ref.watch(tutorialRepositoryProvider);
    _exerciseRepository = ref.watch(exerciseRepositoryProvider);
    _audioRepository = ref.watch(audioRepositoryProvider);
    final tutorial =
        await _tutorialRepository.getTutorial(tutorialId);
    Exercise? exercise;
    if (exerciseId != null) {
      exercise = await _exerciseRepository.getExercise(
          tutorialId, languageCode, exerciseId);
    }
    return ExerciseUiState(exercise: exercise, tutorialName: tutorial.titleEn);
  }

  Future setSourceUrl(String sourceUrl) async {
    return _audioRepository.setSourceUrl(sourceUrl);
  }

  Stream<void> getPlayerStateStream() {
    return _audioRepository.getPlayerStateStream();
  }

  pauseAudio() {
    return _audioRepository.pauseAudio();
  }

  resumeAudio() {
    return _audioRepository.resumeAudio();
  }

  Future<String> createExercise(Map<String, dynamic> data) async {
    return _exerciseRepository.createExercise(
        tutorialId, languageCode, data);
  }

  Future<void> updateExercise(Map<String, dynamic> data) async {
    return _exerciseRepository.updateExercise(tutorialId, languageCode,
        {...data, 'id': exerciseId});
  }
}
