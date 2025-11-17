import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:modern_turkmen_admin/data/repositories/exercise/exercise_repository_firestore.dart';
import 'package:modern_turkmen_admin/data/services/firestore/firestore_service.dart';
import 'package:modern_turkmen_admin/data/services/firestore/model/exercise/exercise_firestore_model.dart';
import 'package:modern_turkmen_admin/domain/models/exercise/exercise.dart';

import 'exercise_repository_firestore_test.mocks.dart';

@GenerateMocks([FirestoreService])
void main() {
  late ExerciseRepositoryFirestore repository;
  late MockFirestoreService mockFirestoreService;

  setUp(() {
    mockFirestoreService = MockFirestoreService();
    repository = ExerciseRepositoryFirestore(firestoreService: mockFirestoreService);
  });

  group('ExerciseRepositoryFirestore', () {
    const tutorialId = 'tutorial1';
    const languageCode = 'en';
    const exerciseId = 'exercise1';

    group('getExercise', () {
      test('returns Exercise when model exists', () async {
        const mockModel = ExerciseFirestoreModel(
          id: exerciseId,
          items: [
            {
              'options': ['option1', 'option2', 'option3'],
              'sentence': 'Test sentence',
              'sound': 'test_sound_url',
              'translation': 'Test translation',
              'solution': 'option1',
            }
          ],
          description: 'Test description',
          exampleTranslation: 'Test translation',
          example: 'Test example',
          orderNumber: 1,
        );
        
        when(mockFirestoreService.getExercise(tutorialId, languageCode, exerciseId))
            .thenAnswer((_) async => mockModel);

        final result = await repository.getExercise(tutorialId, languageCode, exerciseId);

        expect(result, isA<Exercise>());
        expect(result?.id, equals(exerciseId));
        expect(result?.description, equals('Test description'));
        expect(result?.items, hasLength(1));
        verify(mockFirestoreService.getExercise(tutorialId, languageCode, exerciseId));
      });

      test('returns null when model does not exist', () async {
        when(mockFirestoreService.getExercise(tutorialId, languageCode, exerciseId))
            .thenAnswer((_) async => null);

        final result = await repository.getExercise(tutorialId, languageCode, exerciseId);

        expect(result, isNull);
        verify(mockFirestoreService.getExercise(tutorialId, languageCode, exerciseId));
      });
    });

    group('createExercise', () {
      test('calls firestore service with correct parameters', () async {
        final data = {
          'id': exerciseId,
          'description': 'Test',
          'example': 'Test example',
          'items': [
            {
              'options': ['option1', 'option2', 'option3'],
              'sentence': 'Test sentence',
              'sound': 'test_sound_url',
              'translation': 'Test translation',
              'solution': 'option1',
            }
          ],
          'order_number': 1,
          'example_translation': 'Test translation',
        };
        
        when(mockFirestoreService.createExercise(any, any, any))
            .thenAnswer((_) async {});

        await repository.createExercise(tutorialId, languageCode, data);

        verify(mockFirestoreService.createExercise(tutorialId, languageCode, any));
      });
    });

    group('updateExercise', () {
      test('calls firestore service with correct parameters', () async {
        final data = {
          'id': exerciseId,
          'description': 'Updated',
          'example': 'Updated example',
          'items': [
            {
              'options': ['option1', 'option2', 'option3'],
              'sentence': 'Updated sentence',
              'sound': 'updated_sound_url',
              'translation': 'Updated translation',
              'solution': 'option2',
            }
          ],
          'order_number': 1,
          'example_translation': 'Updated translation',
        };
        
        when(mockFirestoreService.updateExercise(any, any, any))
            .thenAnswer((_) async {});

        await repository.updateExercise(tutorialId, languageCode, data);

        verify(mockFirestoreService.updateExercise(tutorialId, languageCode, any));
      });
    });

    group('getExercises', () {
      test('returns list of exercises', () async {
        final mockModels = [
          const ExerciseFirestoreModel(
            id: 'exercise1',
            items: [
              {
                'options': ['option1', 'option2', 'option3'],
                'sentence': 'Test sentence 1',
                'sound': 'test_sound_url_1',
                'translation': 'Test translation 1',
                'solution': 'option1',
              }
            ],
            description: 'Test 1',
            exampleTranslation: 'Translation 1',
            example: 'Example 1',
            orderNumber: 1,
          ),
          const ExerciseFirestoreModel(
            id: 'exercise2',
            items: [
              {
                'options': ['option1', 'option2', 'option3'],
                'sentence': 'Test sentence 2',
                'sound': 'test_sound_url_2',
                'translation': 'Test translation 2',
                'solution': 'option2',
              }
            ],
            description: 'Test 2',
            exampleTranslation: 'Translation 2',
            example: 'Example 2',
            orderNumber: 2,
          ),
        ];

        when(mockFirestoreService.getExercises(tutorialId, languageCode))
            .thenAnswer((_) async => mockModels);

        final result = await repository.getExercises(tutorialId, languageCode);

        expect(result, hasLength(2));
        expect(result[0].id, equals('exercise1'));
        expect(result[1].id, equals('exercise2'));
        verify(mockFirestoreService.getExercises(tutorialId, languageCode));
      });
    });

    group('deleteExercise', () {
      test('calls firestore service with correct parameters', () async {
        when(mockFirestoreService.deleteExercise(tutorialId, languageCode, exerciseId))
            .thenAnswer((_) async {});

        await repository.deleteExercise(tutorialId, languageCode, exerciseId);

        verify(mockFirestoreService.deleteExercise(tutorialId, languageCode, exerciseId));
      });
    });
  });
}