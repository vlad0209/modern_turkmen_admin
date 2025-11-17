import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:modern_turkmen_admin/data/repositories/tutorial/tutorial_repository_firestore.dart';
import 'package:modern_turkmen_admin/data/services/firestore/firestore_service.dart';
import 'package:modern_turkmen_admin/data/services/firestore/model/tutorial/tutorial_firestore_model.dart';

@GenerateMocks([FirestoreService])
import 'tutorial_repository_firestore_test.mocks.dart';

void main() {
  late TutorialRepositoryFirestore repository;
  late MockFirestoreService mockFirestoreService;

  setUp(() {
    mockFirestoreService = MockFirestoreService();
    repository = TutorialRepositoryFirestore(firestoreService: mockFirestoreService);
  });

  group('TutorialRepositoryFirestore', () {
    test('getTutorial returns Tutorial from FirestoreService', () async {
      // Arrange
      const tutorialId = 'test-id';
      const firestoreModel = TutorialFirestoreModel(
        id: tutorialId,
        titleEn: 'English Title',
        titleRu: 'Russian Title',
        thumbUrl: 'thumb.jpg',
        imageUrl: 'image.jpg',
        contentEn: 'English Content',
        contentRu: 'Russian Content',
        publicEn: true,
        publicRu: false,
      );
      
      when(mockFirestoreService.getTutorial(tutorialId))
          .thenAnswer((_) async => firestoreModel);

      // Act
      final result = await repository.getTutorial(tutorialId);

      // Assert
      expect(result.id, tutorialId);
      expect(result.titleEn, 'English Title');
      expect(result.titleRu, 'Russian Title');
      verify(mockFirestoreService.getTutorial(tutorialId)).called(1);
    });

    test('addTutorial calls FirestoreService with converted model', () async {
      // Arrange
      const expectedId = 'new-id';
      final data = {
        'title_en': 'New Tutorial',
        'title_ru': 'Новый урок',
        'content_en': 'English content for the tutorial',
        'content_ru': 'Русский контент для урока',
        'image_url': 'https://example.com/image.jpg',
        'thumb_url': 'https://example.com/thumb.jpg',
        'public_en': true,
        'public_ru': false,
      };
      
      when(mockFirestoreService.addTutorial(any))
          .thenAnswer((_) async => expectedId);

      // Act
      final result = await repository.addTutorial(data);

      // Assert
      expect(result, expectedId);
      verify(mockFirestoreService.addTutorial(any)).called(1);
    });

    test('updateTutorial calls FirestoreService with converted model', () async {
      // Arrange
      final data = {
        'id': 'existing-id',
        'title_en': 'Updated Tutorial',
        'title_ru': 'Обновленный урок',
        'content_en': 'Updated English content',
        'content_ru': 'Обновленный русский контент',
        'image_url': 'https://example.com/updated-image.jpg',
        'thumb_url': 'https://example.com/updated-thumb.jpg',
        'public_en': true,
        'public_ru': true,
      };

      when(mockFirestoreService.updateTutorial(any))
          .thenAnswer((_) async {});

      // Act
      await repository.updateTutorial(data);

      // Assert
      verify(mockFirestoreService.updateTutorial(any)).called(1);
    });

    test('getTutorialsStream maps Firestore models to Tutorial domain models', () async {
      // Arrange
      final firestoreModels = [
        const TutorialFirestoreModel(
          id: 'id1',
          titleEn: 'Title 1',
          titleRu: 'Заголовок 1',
          publicEn: true,
          publicRu: false, contentEn: '', contentRu: '', imageUrl: '', thumbUrl: '',
        ),
        const TutorialFirestoreModel(
          id: 'id2',
          titleEn: 'Title 2',
          titleRu: 'Заголовок 2',
          publicEn: false,
          publicRu: true, contentEn: '', contentRu: '', imageUrl: '', thumbUrl: '',
        ),
      ];

      when(mockFirestoreService.getTutorialsStream())
          .thenAnswer((_) => Stream.value(firestoreModels));

      // Act
      final stream = repository.getTutorialsStream();
      final result = await stream.first;

      // Assert
      expect(result, hasLength(2));
      expect(result[0].id, 'id1');
      expect(result[0].titleEn, 'Title 1');
      expect(result[1].id, 'id2');
      expect(result[1].titleRu, 'Заголовок 2');
    });

    test('deleteTutorial calls FirestoreService deleteTutorial', () async {
      // Arrange
      const tutorialId = 'delete-id';
      when(mockFirestoreService.deleteTutorial(tutorialId))
          .thenAnswer((_) async {});

      // Act
      await repository.deleteTutorial(tutorialId);

      // Assert
      verify(mockFirestoreService.deleteTutorial(tutorialId)).called(1);
    });
  });
}