import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_turkmen_admin/config/app_constants.dart';
import 'package:modern_turkmen_admin/ui/exercises/view_model.dart/exercise_view_model.dart';
import 'package:modern_turkmen_admin/ui/exercises/widgets/exercise_form.dart';
import 'package:flutter/material.dart';

import '../../core/ui/main_layout.dart';

class EditExerciseScreen extends ConsumerWidget {
  const EditExerciseScreen(
      {super.key,
      required this.tutorialId,
      required this.exerciseId,
      required this.lang});
  final String tutorialId;
  final String exerciseId;
  final String lang;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUiState =
        ref.watch(exerciseViewModelProvider(tutorialId, lang, exerciseId));
    final viewModel = ref
        .read(exerciseViewModelProvider(tutorialId, lang, exerciseId).notifier);

    return asyncUiState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
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
                        context.go('/tutorials/$tutorialId/$lang/exercises');
                      },
                      child: Text(
                        ' > Exercises${tutorialName.isNotEmpty ? ' of $tutorialName' : ''} (${kLanguages[lang]})',
                      )),
                ),
                const Text(' > Edit exercise')
              ],
            ),
            body: ExerciseForm(
              id: uiState.exercise?.id,
              tutorialId: tutorialId,
              exercise: uiState.exercise,
              action: 'update',
              onSuccess: (tutorialId, exerciseId) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('An exercise has been updated'),
                  backgroundColor: Colors.lightGreen,
                ));
              },
              onFail: (exception) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(exception)));
              },
              languageCode: lang,
              setSourceUrl: viewModel.setSourceUrl,
              onPlayerStateChanged: viewModel.getPlayerStateStream(),
              pauseAudio: viewModel.pauseAudio,
              resumeAudio: viewModel.resumeAudio,
              createExercise: viewModel.createExercise,
              updateExercise: viewModel.updateExercise,
            ));
      },
    );
  }
}
