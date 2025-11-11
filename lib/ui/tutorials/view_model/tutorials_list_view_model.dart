import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../config/dependencies.dart';
import '../../../data/repositories/tutorial/tutorial_repository.dart';
import '../../../domain/models/tutorial/tutorial.dart';

part 'tutorials_list_view_model.g.dart';

@riverpod
class TutorialsListViewModel extends _$TutorialsListViewModel {
  late TutorialRepository _tutorialRepository;
  @override
  Stream<List<Tutorial>> build() {
    _tutorialRepository = ref.watch(tutorialRepositoryProvider);
    return _tutorialRepository.getTutorialsStream();
  }

  Future<void> deleteTutorial(String tutorialId) async {
    await _tutorialRepository.deleteTutorial(tutorialId);
  }
}