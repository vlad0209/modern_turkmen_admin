import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../config/dependencies.dart';
import '../../../data/repositories/tutorial/tutorial_repository.dart';
import '../../../domain/models/tutorial/tutorial.dart';

part 'tutorial_view_model.g.dart';

@riverpod
class TutorialViewModel extends _$TutorialViewModel {
  late TutorialRepository _tutorialRepository;
  @override
  FutureOr<Tutorial?> build(String? tutorialId) async {
    _tutorialRepository = ref.watch(tutorialRepositoryProvider);
    return tutorialId == null ? null : await _tutorialRepository.getTutorial(tutorialId);
  }

  Future addTutorial(Map<String, dynamic> data) async {
    await _tutorialRepository.addTutorial(data);
  }

  Future updateTutorial(Map<String, dynamic> data) async {
    await _tutorialRepository.updateTutorial({'id': tutorialId, ...data});
  }
}