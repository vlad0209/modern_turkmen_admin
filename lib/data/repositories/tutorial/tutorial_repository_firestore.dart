import 'package:modern_turkmen_admin/data/services/firestore/model/tutorial/tutorial_firestore_model.dart';
import 'package:modern_turkmen_admin/domain/models/tutorial/tutorial.dart';

import '../../services/firestore/firestore_service.dart';
import 'tutorial_repository.dart';

class TutorialRepositoryFirestore implements TutorialRepository {
  final FirestoreService _firestoreService;
  TutorialRepositoryFirestore({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  @override
  Future<Tutorial> getTutorial(String tutorialId) async {
    final model = await _firestoreService.getTutorial(tutorialId);
    return Tutorial(
        id: model.id!,
        titleEn: model.titleEn,
        titleRu: model.titleRu,
        thumbUrl: model.thumbUrl,
        imageUrl: model.imageUrl,
        contentEn: model.contentEn,
        contentRu: model.contentRu,
        publicEn: model.publicEn,
        publicRu: model.publicRu);
  }

  @override
  Future<String> addTutorial(Map<String, dynamic> data) async {
    return await _firestoreService.addTutorial(TutorialFirestoreModel.fromJson(data));
  }

  @override
  Future<void> updateTutorial(Map<String, dynamic> data) async {
    return await _firestoreService.updateTutorial(TutorialFirestoreModel.fromJson(data));
  }

  @override
  Stream<List<Tutorial>> getTutorialsStream() {
    return _firestoreService.getTutorialsStream().map((models) {
      return models.map((model) {
        return Tutorial(
            id: model.id!,
            titleEn: model.titleEn,
            titleRu: model.titleRu,
            thumbUrl: model.thumbUrl,
            imageUrl: model.imageUrl,
            contentEn: model.contentEn,
            contentRu: model.contentRu,
            publicEn: model.publicEn,
            publicRu: model.publicRu);
      }).toList();
    });
  }

  @override
  Future<void> deleteTutorial(String tutorialId) async {
    await _firestoreService.deleteTutorial(tutorialId);
  }
}
