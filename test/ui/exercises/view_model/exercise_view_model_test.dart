import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:modern_turkmen_admin/config/dependencies.dart';
import 'package:modern_turkmen_admin/data/repositories/audio/audio_repository.dart';
import 'package:modern_turkmen_admin/data/repositories/exercise/exercise_repository.dart';
import 'package:modern_turkmen_admin/data/repositories/tutorial/tutorial_repository.dart';
import 'package:modern_turkmen_admin/domain/models/exercise/exercise.dart';
import 'package:modern_turkmen_admin/domain/models/tutorial/tutorial.dart';
import 'package:modern_turkmen_admin/ui/exercises/view_model/exercise_view_model.dart';

import 'exercise_view_model_test.mocks.dart';

@GenerateMocks([TutorialRepository, ExerciseRepository, AudioRepository])
void main() {
  late MockTutorialRepository mockTutorialRepository;
  late MockExerciseRepository mockExerciseRepository;
  late MockAudioRepository mockAudioRepository;
  late ProviderContainer container;

  setUp(() {
    mockTutorialRepository = MockTutorialRepository();
    mockExerciseRepository = MockExerciseRepository();
    mockAudioRepository = MockAudioRepository();

    container = ProviderContainer(
      overrides: [
        tutorialRepositoryProvider.overrideWithValue(mockTutorialRepository),
        exerciseRepositoryProvider.overrideWithValue(mockExerciseRepository),
        audioRepositoryProvider.overrideWithValue(mockAudioRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ExerciseViewModel', () {
    test(
        'build returns ExerciseUiState with tutorial name when exerciseId is null',
        () async {
      const tutorialId = 'tutorial1';
      const languageCode = 'en';
      const tutorial = Tutorial(
          id: tutorialId,
          titleEn: 'Test Tutorial',
          titleRu: '',
          thumbUrl: '',
          imageUrl: '',
          contentEn: '',
          contentRu: '',
          publicEn: true,
          publicRu: true);

      when(mockTutorialRepository.getTutorial(tutorialId))
          .thenAnswer((_) async => tutorial);

      final provider =
          exerciseViewModelProvider(tutorialId, languageCode, null);
      final result = await container.read(provider.future);

      expect(result.exercise, isNull);
      expect(result.tutorialName, equals('Test Tutorial'));
    });

    test(
        'build returns ExerciseUiState with exercise when exerciseId is provided',
        () async {
      const tutorialId = 'tutorial1';
      const languageCode = 'en';
      const exerciseId = 'exercise1';
      const tutorial = Tutorial(
          id: tutorialId,
          titleEn: 'Test Tutorial',
          titleRu: '',
          thumbUrl: '',
          imageUrl: '',
          contentEn: '',
          contentRu: '',
          publicEn: false,
          publicRu: false);
      const exercise = Exercise(
          id: exerciseId,
          items: [],
          description: '',
          exampleTranslation: '',
          example: '',
          orderNumber: null);

      when(mockTutorialRepository.getTutorial(tutorialId))
          .thenAnswer((_) async => tutorial);
      when(mockExerciseRepository.getExercise(
              tutorialId, languageCode, exerciseId))
          .thenAnswer((_) async => exercise);

      final provider =
          exerciseViewModelProvider(tutorialId, languageCode, exerciseId);
      final result = await container.read(provider.future);

      expect(result.exercise, equals(exercise));
      expect(result.tutorialName, equals('Test Tutorial'));
    });

    test('setSourceUrl calls audioRepository.setSourceUrl', () async {
      const sourceUrl = 'http://example.com/audio.mp3';

      when(mockAudioRepository.setSourceUrl(sourceUrl))
          .thenAnswer((_) async => {});

      final provider = exerciseViewModelProvider('tutorial1', 'en', null);
      final viewModel = container.read(provider.notifier);

      await viewModel.setSourceUrl(sourceUrl);

      verify(mockAudioRepository.setSourceUrl(sourceUrl)).called(1);
    });

    test('getPlayerStateStream returns stream from audioRepository', () {
      const stream = Stream<void>.empty();

      when(mockAudioRepository.getPlayerStateStream()).thenAnswer((_) => stream);

      final provider = exerciseViewModelProvider('tutorial1', 'en', null);
      final viewModel = container.read(provider.notifier);

      final result = viewModel.getPlayerStateStream();

      expect(result, equals(stream));
      verify(mockAudioRepository.getPlayerStateStream()).called(1);
    });

    test('pauseAudio calls audioRepository.pauseAudio', () {
      final provider = exerciseViewModelProvider('tutorial1', 'en', null);
      final viewModel = container.read(provider.notifier);

      viewModel.pauseAudio();

      verify(mockAudioRepository.pauseAudio()).called(1);
    });

    test('resumeAudio calls audioRepository.resumeAudio', () {
      final provider = exerciseViewModelProvider('tutorial1', 'en', null);
      final viewModel = container.read(provider.notifier);

      viewModel.resumeAudio();

      verify(mockAudioRepository.resumeAudio()).called(1);
    });

    test('createExercise calls exerciseRepository.createExercise', () async {
      const tutorialId = 'tutorial1';
      const languageCode = 'en';
      final data = {'name': 'Test Exercise'};

      when(mockExerciseRepository.createExercise(
              tutorialId, languageCode, data))
          .thenAnswer((_) async => 'created_exercise_id');

      final provider =
          exerciseViewModelProvider(tutorialId, languageCode, null);
      final viewModel = container.read(provider.notifier);

      await viewModel.createExercise(data);

      verify(mockExerciseRepository.createExercise(
              tutorialId, languageCode, data))
          .called(1);
    });

    test(
        'updateExercise calls exerciseRepository.updateExercise with exercise id',
        () async {
      const tutorialId = 'tutorial1';
      const languageCode = 'en';
      const exerciseId = 'exercise1';
      final data = {'name': 'Updated Exercise'};
      final expectedData = {...data, 'id': exerciseId};

      when(mockExerciseRepository.updateExercise(
              tutorialId, languageCode, expectedData))
          .thenAnswer((_) async {});

      final provider =
          exerciseViewModelProvider(tutorialId, languageCode, exerciseId);
      final viewModel = container.read(provider.notifier);

      await viewModel.updateExercise(data);

      verify(mockExerciseRepository.updateExercise(
              tutorialId, languageCode, expectedData))
          .called(1);
    });
  });
}
