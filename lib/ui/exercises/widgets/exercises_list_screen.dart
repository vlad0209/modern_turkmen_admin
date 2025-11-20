import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_turkmen_admin/config/app_constants.dart';
import 'package:flutter/material.dart';

import '../../core/ui/main_layout.dart';
import '../view_model/exercises_list_view_model.dart';

class ExercisesListScreen extends ConsumerStatefulWidget {
  const ExercisesListScreen(
      {super.key, required this.tutorialId, required this.languageCode});
  final String tutorialId;
  final String languageCode;

  @override
  ConsumerState<ExercisesListScreen> createState() => _ExercisesListScreenState();
}

class _ExercisesListScreenState extends ConsumerState<ExercisesListScreen> {
  Future<void>? _pendingDeleteExercise;
@override
  Widget build(BuildContext context) {
    final asyncUiState =
        ref.watch(exercisesListViewModelProvider(widget.tutorialId, widget.languageCode));

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
                  '(${kLanguages[widget.languageCode]})',
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
                              '/tutorials/${widget.tutorialId}/${widget.languageCode}/edit-exercise/${exercise.id}'),
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
                context.go('/tutorials/${widget.tutorialId}/${widget.languageCode}/add-exercise');
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
                FutureBuilder(
                  future: _pendingDeleteExercise,
                  builder: (context, asyncSnapshot) {
                    return TextButton(
                      onPressed: () {
                        final future = ref
                            .read(exercisesListViewModelProvider(
                                    widget.tutorialId, widget.languageCode)
                                .notifier)
                            .deleteExercise(exerciseId);
                        setState(() {
                          _pendingDeleteExercise = future;
                        });
                        future.then((_) {
                          if (context.mounted) {
                            Navigator.pop(context, 'OK');
                          }
                        });
                      },
                      child: asyncSnapshot.connectionState == ConnectionState.waiting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('OK'),
                    );
                  }
                ),
              ],
            ));
  }
}
