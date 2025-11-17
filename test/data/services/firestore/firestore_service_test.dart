import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:modern_turkmen_admin/data/services/firestore/firestore_service.dart';
import 'package:modern_turkmen_admin/data/services/firestore/model/exercise/exercise_firestore_model.dart';
import 'package:modern_turkmen_admin/data/services/firestore/model/tutorial/tutorial_firestore_model.dart';
import 'package:modern_turkmen_admin/domain/models/user/user.dart';

import 'firestore_service_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  Query,
  QuerySnapshot,
  QueryDocumentSnapshot,
])
void main() {
  late FirestoreService service;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDocumentRef;
  late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;
  late MockQuery<Map<String, dynamic>> mockQuery;
  late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
  late MockQueryDocumentSnapshot<Map<String, dynamic>> mockQueryDoc;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference<Map<String, dynamic>>();
    mockDocumentRef = MockDocumentReference<Map<String, dynamic>>();
    mockDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
    mockQuery = MockQuery<Map<String, dynamic>>();
    mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    mockQueryDoc = MockQueryDocumentSnapshot<Map<String, dynamic>>();
    service = FirestoreService(mockFirestore);
  });

  group('getUser', () {
    test('should return user when document exists', () async {
      const userId = 'user123';
      final userData = {'admin': true};

      when(mockFirestore.collection('users')).thenReturn(mockCollection);
      when(mockCollection.doc(userId)).thenReturn(mockDocumentRef);
      when(mockDocumentRef.get()).thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.exists).thenReturn(true);
      when(mockDocumentSnapshot.data()).thenReturn(userData);
      when(mockDocumentSnapshot.id).thenReturn(userId);

      final result = await service.getUser(userId);

      expect(result, isA<User>());
      verify(mockFirestore.collection('users')).called(1);
      verify(mockCollection.doc(userId)).called(1);
    });

    test('should throw exception when user not found', () async {
      const userId = 'user123';

      when(mockFirestore.collection('users')).thenReturn(mockCollection);
      when(mockCollection.doc(userId)).thenReturn(mockDocumentRef);
      when(mockDocumentRef.get()).thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.exists).thenReturn(false);

      expect(() => service.getUser(userId), throwsException);
    });
  });

  group('getTutorial', () {
    test('should return tutorial when document exists', () async {
      const tutorialId = 'tutorial123';
      final tutorialData = {
        'title_en': 'Test Tutorial',
        'title_ru': 'Тестовый урок',
        'content_en': 'English content',
        'content_ru': 'Русский контент',
        'image_url': 'https://example.com/image.jpg',
        'thumb_url': 'https://example.com/thumb.jpg',
        'public_en': true,
        'public_ru': false,
      };

      when(mockFirestore.collection('tutorials')).thenReturn(mockCollection);
      when(mockCollection.doc(tutorialId)).thenReturn(mockDocumentRef);
      when(mockDocumentRef.get()).thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.exists).thenReturn(true);
      when(mockDocumentSnapshot.data()).thenReturn(tutorialData);
      when(mockDocumentSnapshot.id).thenReturn(tutorialId);

      final result = await service.getTutorial(tutorialId);

      expect(result, isA<TutorialFirestoreModel>());
      verify(mockFirestore.collection('tutorials')).called(1);
      verify(mockCollection.doc(tutorialId)).called(1);
    });

    test('should throw exception when tutorial not found', () async {
      const tutorialId = 'tutorial123';

      when(mockFirestore.collection('tutorials')).thenReturn(mockCollection);
      when(mockCollection.doc(tutorialId)).thenReturn(mockDocumentRef);
      when(mockDocumentRef.get()).thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.exists).thenReturn(false);

      expect(() => service.getTutorial(tutorialId), throwsException);
    });
  });

  group('getExercise', () {
    test('should return exercise when document exists', () async {
      const tutorialId = 'tutorial123';
      const languageCode = 'en';
      const exerciseId = 'exercise123';
      final exerciseData = {
        'description': 'Test Exercise',
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

      when(mockFirestore
              .collection('tutorials/$tutorialId/exercises_$languageCode'))
          .thenReturn(mockCollection);
      when(mockCollection.doc(exerciseId)).thenReturn(mockDocumentRef);
      when(mockDocumentRef.get()).thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.exists).thenReturn(true);
      when(mockDocumentSnapshot.data()).thenReturn(exerciseData);
      when(mockDocumentSnapshot.id).thenReturn(exerciseId);

      final result =
          await service.getExercise(tutorialId, languageCode, exerciseId);

      expect(result, isA<ExerciseFirestoreModel>());
    });

    test('should return null when exercise not found', () async {
      const tutorialId = 'tutorial123';
      const languageCode = 'en';
      const exerciseId = 'exercise123';

      when(mockFirestore
              .collection('tutorials/$tutorialId/exercises_$languageCode'))
          .thenReturn(mockCollection);
      when(mockCollection.doc(exerciseId)).thenReturn(mockDocumentRef);
      when(mockDocumentRef.get()).thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.exists).thenReturn(false);

      final result =
          await service.getExercise(tutorialId, languageCode, exerciseId);

      expect(result, isNull);
    });
  });

  group('getExercises', () {
    test('should return list of exercises', () async {
      const tutorialId = 'tutorial123';
      const languageCode = 'en';
      final exerciseData = {
        'description': 'Test Exercise',
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

      when(mockFirestore
              .collection('tutorials/$tutorialId/exercises_$languageCode'))
          .thenReturn(mockCollection);
      when(mockCollection.orderBy('order_number')).thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([mockQueryDoc]);
      when(mockQueryDoc.data()).thenReturn(exerciseData);
      when(mockQueryDoc.id).thenReturn('exercise123');

      final result = await service.getExercises(tutorialId, languageCode);

      expect(result, isA<List<ExerciseFirestoreModel>>());
      expect(result.length, 1);
    });
  });

  group('createExercise', () {
    test('should create exercise successfully', () async {
      const tutorialId = 'tutorial123';
      const languageCode = 'en';
      const exercise = ExerciseFirestoreModel(
        id: 'exercise123',
        description: 'Test Exercise',
        orderNumber: 1,
        example: 'Test example',
        items: [
          {
            'options': ['option1', 'option2', 'option3'],
            'sentence': 'Test sentence',
            'sound': 'test_sound_url',
            'translation': 'Test translation',
            'solution': 'option1',
          }
        ],
        exampleTranslation: 'Test translation',
      );

      when(mockFirestore
              .collection('tutorials/$tutorialId/exercises_$languageCode'))
          .thenReturn(mockCollection);
      when(mockCollection.add(any)).thenAnswer((_) async => mockDocumentRef);

      await service.createExercise(tutorialId, languageCode, exercise);

      verify(mockCollection.add(any)).called(1);
    });
  });

  group('updateExercise', () {
    test('should update exercise successfully', () async {
      const tutorialId = 'tutorial123';
      const languageCode = 'en';
      const exercise = ExerciseFirestoreModel(
        id: 'exercise123',
        description: 'Updated Exercise',
        orderNumber: 1,
        example: 'Updated example',
        items: [
          {
            'options': ['option1', 'option2', 'option3'],
            'sentence': 'Updated sentence',
            'sound': 'updated_sound_url',
            'translation': 'Updated translation',
            'solution': 'option2',
          }
        ],
        exampleTranslation: 'Updated translation',
      );

      when(mockFirestore
              .collection('tutorials/$tutorialId/exercises_$languageCode'))
          .thenReturn(mockCollection);
      when(mockCollection.doc(exercise.id)).thenReturn(mockDocumentRef);
      when(mockDocumentRef.update(any)).thenAnswer((_) async => {});

      await service.updateExercise(tutorialId, languageCode, exercise);

      verify(mockDocumentRef.update(any)).called(1);
    });
  });

  group('deleteExercise', () {
    test('should delete exercise successfully', () async {
      const tutorialId = 'tutorial123';
      const languageCode = 'en';
      const exerciseId = 'exercise123';

      when(mockFirestore
              .collection('tutorials/$tutorialId/exercises_$languageCode'))
          .thenReturn(mockCollection);
      when(mockCollection.doc(exerciseId)).thenReturn(mockDocumentRef);
      when(mockDocumentRef.delete()).thenAnswer((_) async => {});

      await service.deleteExercise(tutorialId, languageCode, exerciseId);

      verify(mockDocumentRef.delete()).called(1);
    });
  });

  group('addTutorial', () {
    test('should add tutorial successfully', () async {
      const tutorial = TutorialFirestoreModel(
        id: 'tutorial123',
        titleEn: 'Test Tutorial',
        contentEn: '',
        contentRu: '',
        imageUrl: '',
        publicEn: true,
        publicRu: true,
        thumbUrl: '',
        titleRu: '',
      );

      when(mockFirestore.collection('tutorials')).thenReturn(mockCollection);
      when(mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.size).thenReturn(5);
      when(mockCollection.add(any)).thenAnswer((_) async => mockDocumentRef);
      when(mockDocumentRef.id).thenReturn('tutorial123');

      final result = await service.addTutorial(tutorial);

      expect(result, 'tutorial123');
      verify(mockCollection.add(any)).called(1);
    });
  });

  group('updateTutorial', () {
    test('should update tutorial successfully', () async {
      const tutorial = TutorialFirestoreModel(
        id: 'tutorial123',
        titleEn: 'Updated Tutorial',
        contentEn: '',
        contentRu: '',
        imageUrl: '',
        publicEn: true,
        publicRu: true,
        thumbUrl: '',
        titleRu: '',
      );

      when(mockFirestore.collection('tutorials')).thenReturn(mockCollection);
      when(mockCollection.doc(tutorial.id)).thenReturn(mockDocumentRef);
      when(mockDocumentRef.update(any)).thenAnswer((_) async => {});

      await service.updateTutorial(tutorial);

      verify(mockDocumentRef.update(any)).called(1);
    });
  });

  group('deleteTutorial', () {
    test('should delete tutorial successfully', () async {
      const tutorialId = 'tutorial123';

      when(mockFirestore.collection('tutorials')).thenReturn(mockCollection);
      when(mockCollection.doc(tutorialId)).thenReturn(mockDocumentRef);
      when(mockDocumentRef.delete()).thenAnswer((_) async => {});

      await service.deleteTutorial(tutorialId);

      verify(mockDocumentRef.delete()).called(1);
    });
  });
}
