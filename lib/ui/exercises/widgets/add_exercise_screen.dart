import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_turkmen_admin/config/app_constants.dart';
import 'package:modern_turkmen_admin/ui/exercises/widgets/exercise_form.dart';
import 'package:flutter/material.dart';

import '../../core/ui/main_layout.dart';
import '../view_model.dart/exercise_view_model.dart';

class AddExerciseScreen extends ConsumerWidget {
  const AddExerciseScreen({
    super.key,
    required this.tutorialId,
    required this.language,
  });
  final String tutorialId;
  final String language;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUiState =
        ref.watch(exerciseViewModelProvider(tutorialId, language, null));
    final viewModel = ref
        .read(exerciseViewModelProvider(tutorialId, language, null).notifier);
    return asyncUiState.when(
        loading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
        error: (error, stackTrace) => Scaffold(
              body: Center(child: Text('Error: $error')),
            ),
        data: (uiState) {
          final tutorialName = uiState.tutorialName;
          return MainLayout(
            title: Row(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                      onTap: () {
                        context.go('/tutorials');
                      },
                      child: const Text(
                        'Tutorials',
                      )),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                      onTap: () {
                        context
                            .go('/tutorials/$tutorialId/$language/exercises');
                      },
                      child: Text(
                        ' > Exercises${tutorialName.isNotEmpty ? ' of $tutorialName' : ''} (${kLanguages[language]})',
                      )),
                ),
                const Text(' > Add exercise')
              ],
            ),
            body: ExerciseForm(
              tutorialId: tutorialId,
              action: 'create',
              onSuccess: (tutorialId, exerciseId) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('An exercise has been created'),
                  backgroundColor: Colors.lightGreen,
                ));
                context.go(
                    '/tutorials/$tutorialId/$language/edit-exercise/$exerciseId');
              },
              onFail: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Failed to create an exercise')));
              },
              languageCode: language,
              setSourceUrl: viewModel.setSourceUrl,
              onPlayerStateChanged: viewModel.getPlayerStateStream(),
              pauseAudio: viewModel.pauseAudio,
              resumeAudio: viewModel.resumeAudio,
              createExercise: viewModel.createExercise,
              updateExercise: viewModel.updateExercise,
            ),
          );
        });
  }
}
