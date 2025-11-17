import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modern_turkmen_admin/config/dependencies.dart';
import 'package:modern_turkmen_admin/data/repositories/exercise/exercise_repository.dart';
import 'package:modern_turkmen_admin/data/repositories/tutorial/tutorial_repository.dart';
import 'package:modern_turkmen_admin/domain/models/exercise/exercise.dart';
import 'package:modern_turkmen_admin/domain/models/tutorial/tutorial.dart';
import 'package:modern_turkmen_admin/ui/exercises/view_model/exercises_list_view_model.dart';

import 'exercises_list_view_model_test.mocks.dart';

@GenerateMocks([TutorialRepository, ExerciseRepository])
void main() {
  late MockTutorialRepository mockTutorialRepository;
  late MockExerciseRepository mockExerciseRepository;
  late ProviderContainer container;

  setUp(() {
    mockTutorialRepository = MockTutorialRepository();
    mockExerciseRepository = MockExerciseRepository();

    container = ProviderContainer(
      overrides: [
        tutorialRepositoryProvider.overrideWithValue(mockTutorialRepository),
        exerciseRepositoryProvider.overrideWithValue(mockExerciseRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ExercisesListViewModel', () {
    test('build returns correct state when repositories return data', () async {
      // Arrange
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
      final exercises = [
        const Exercise(
            id: 'ex1',
            items: [],
            description: '',
            exampleTranslation: '',
            example: '',
            orderNumber: null)
      ];

      when(mockTutorialRepository.getTutorial(tutorialId))
          .thenAnswer((_) async => tutorial);
      when(mockExerciseRepository.getExercises(tutorialId, languageCode))
          .thenAnswer((_) async => exercises);

      // Act
      final provider = exercisesListViewModelProvider(tutorialId, languageCode);
      final state = await container.read(provider.future);

      // Assert
      expect(state.exercises, equals(exercises));
      expect(state.tutorialName, equals('Test Tutorial'));
      verify(mockTutorialRepository.getTutorial(tutorialId)).called(1);
      verify(mockExerciseRepository.getExercises(tutorialId, languageCode))
          .called(1);
    });

    test('deleteExercise calls repository with correct parameters', () async {
      // Arrange
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
          publicEn: true,
          publicRu: true);

      when(mockTutorialRepository.getTutorial(tutorialId))
          .thenAnswer((_) async => tutorial);
      when(mockExerciseRepository.getExercises(tutorialId, languageCode))
          .thenAnswer((_) async => []);
      when(mockExerciseRepository.deleteExercise(
              tutorialId, languageCode, exerciseId))
          .thenAnswer((_) async {});

      // Act
      final provider = exercisesListViewModelProvider(tutorialId, languageCode);
      final viewModel = container.read(provider.notifier);
      await container.read(provider.future); // Initialize the view model
      await viewModel.deleteExercise(exerciseId);

      // Assert
      verify(mockExerciseRepository.deleteExercise(
              tutorialId, languageCode, exerciseId))
          .called(1);
    });

    test('build calls tutorial repository with correct parameters', () async {
      // Arrange
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
      final exercises = <Exercise>[];

      when(mockTutorialRepository.getTutorial(tutorialId))
          .thenAnswer((_) async => tutorial);
      when(mockExerciseRepository.getExercises(tutorialId, languageCode))
          .thenAnswer((_) async => exercises);

      // Act
      final provider = exercisesListViewModelProvider(tutorialId, languageCode);
      await container.read(provider.future);

      // Assert
      verify(mockTutorialRepository.getTutorial(tutorialId)).called(1);
      verify(mockExerciseRepository.getExercises(tutorialId, languageCode)).called(1);
    });

    test('build uses correct language for tutorial title', () async {
      // Arrange
      const tutorialId = 'tutorial1';
      const languageCode = 'en';
      const tutorial = Tutorial(
          id: tutorialId,
          titleEn: 'English Title',
          titleRu: 'Russian Title',
          thumbUrl: '',
          imageUrl: '',
          contentEn: '',
          contentRu: '',
          publicEn: true,
          publicRu: true);
      final exercises = <Exercise>[];

      when(mockTutorialRepository.getTutorial(tutorialId))
          .thenAnswer((_) async => tutorial);
      when(mockExerciseRepository.getExercises(tutorialId, languageCode))
          .thenAnswer((_) async => exercises);

      // Act
      final provider = exercisesListViewModelProvider(tutorialId, languageCode);
      final result = await container.read(provider.future);

      // Assert
      expect(result.tutorialName, equals('English Title'));
      expect(result.exercises, equals(exercises));
    });
  });
}
