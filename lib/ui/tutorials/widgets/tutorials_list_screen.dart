import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_turkmen_admin/config/app_constants.dart';
import 'package:flutter/material.dart';

import '../../core/ui/main_layout.dart';
import '../view_model/tutorials_list_view_model.dart';

class TutorialsListScreen extends ConsumerWidget {
  const TutorialsListScreen({super.key});

 


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTutorials = ref.watch(tutorialsListViewModelProvider);
    return MainLayout(
      title: const Text('Tutorials'),
      body: asyncTutorials.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('$error\n $stackTrace'),
        ),
        data: (tutorials) {
          if (tutorials.isNotEmpty) {
            return ListView(
                padding: const EdgeInsets.all(11),
                shrinkWrap: true,
                children: tutorials
                    .map((tutorial) {
                      return ListTile(
                        title: TextButton(
                          onPressed: () =>
                              context.go('/tutorials/edit-tutorial/${tutorial.id}'),
                          child: Text(tutorial.titleEn),
                        ),
                        trailing: SizedBox(
                          width: 400,
                          child: Row(
                            children: [
                              Row(
                                children: kLanguages.keys.map(
                                        (languageCode) => TextButton(
                                          onPressed: () => context.go(
                                            '/tutorials/${tutorial.id}/$languageCode/exercises'
                                          ), 
                                          child: Text('Exercises (${kLanguages[languageCode]})'),
                                        ))
                                    .toList().cast(),
                              ),
                              IconButton(
                                onPressed: () => deleteTutorial(context, ref, tutorial.id),
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                    .toList()
                    .cast());
          } else {
            return const Center(
              child: Text('There is no tutorials available'),
            );
          }
        },
      ),
      floatActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/tutorials/add-tutorial');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void deleteTutorial(BuildContext context, WidgetRef ref, String tutorialId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Deleting tutorial'),
              content: const Text('Are you sure you want to delete this tutorial'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel')),
                TextButton(
                  onPressed: () {
                    ref
                        .read(tutorialsListViewModelProvider.notifier)
                        .deleteTutorial(tutorialId)
                        .then((value) => context.mounted ? Navigator.pop(context, 'OK') : null);
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }
}
