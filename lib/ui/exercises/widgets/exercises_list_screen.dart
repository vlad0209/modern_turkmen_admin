import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_turkmen_admin/config/app_constants.dart';
import 'package:flutter/material.dart';

import '../../core/ui/main_layout.dart';
import '../view_model.dart/exercises_list_view_model.dart';

class ExercisesListScreen extends ConsumerWidget {
  const ExercisesListScreen(
      {super.key, required this.tutorialId, required this.languageCode});
  final String tutorialId;
  final String languageCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUiState =
        ref.watch(exercisesListViewModelProvider(tutorialId, languageCode));

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
                Text(
                  ' > Exercises${tutorialName.isNotEmpty ? ' of $tutorialName' : ''} '
                  '(${kLanguages[languageCode]})',
                ),
              ],
            ),
            body: ListView(
                padding: const EdgeInsets.all(11),
                shrinkWrap: true,
                children: uiState.exercises!
                    .map((exercise) {
                      return ListTile(
                        title: TextButton(
                          onPressed: () => context.go(
                              '/tutorials/$tutorialId/$languageCode/edit-exercise/${exercise.id}'),
                          child: Text(exercise.description ?? 'No description'),
                        ),
                        trailing: IconButton(
                          onPressed: () =>
                              deleteExercise(context, ref, exercise.id),
                          icon: const Icon(Icons.delete),
                        ),
                      );
                    })
                    .toList()
                    .cast()),
            floatActionButton: FloatingActionButton(
              onPressed: () {
                context.go('/tutorials/$tutorialId/$languageCode/add-exercise');
              },
              child: const Icon(Icons.add),
            ),
          );
        });
  }

  void deleteExercise(BuildContext context, WidgetRef ref, String exerciseId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Deleting exercise'),
              content:
                  const Text('Are you sure you want to delete this exercise'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel')),
                TextButton(
                  onPressed: () {
                    ref
                        .read(exercisesListViewModelProvider(
                                tutorialId, languageCode)
                            .notifier)
                        .deleteExercise(exerciseId)
                        .then((value) => context.mounted
                            ? Navigator.pop(context, 'OK')
                            : null);
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }
}
