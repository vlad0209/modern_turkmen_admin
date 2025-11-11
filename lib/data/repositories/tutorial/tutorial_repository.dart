import '../../../domain/models/tutorial/tutorial.dart';

abstract class TutorialRepository {
  Future<Tutorial> getTutorial(String tutorialId);

  Future<String> addTutorial(Map<String, dynamic> data);
  Future<void> updateTutorial(Map<String, dynamic> data);

  Stream<List<Tutorial>> getTutorialsStream();

  Future<void> deleteTutorial(String tutorialId);
}