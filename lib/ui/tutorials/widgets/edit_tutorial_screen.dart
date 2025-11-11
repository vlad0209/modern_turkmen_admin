import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_turkmen_admin/ui/tutorials/widgets/tutorial_form.dart';
import 'package:flutter/material.dart';

import '../../core/ui/main_layout.dart';
import '../view_model/tutorial_view_model.dart';

class EditTutorialScreen extends ConsumerStatefulWidget {
  const EditTutorialScreen({super.key, required this.tutorialId});
  final String tutorialId;

  @override
  ConsumerState<EditTutorialScreen> createState() => _EditTutorialScreenState();
}

class _EditTutorialScreenState extends ConsumerState<EditTutorialScreen> {
  @override
  Widget build(BuildContext context) {
    final asyncTutorial =
        ref.watch(tutorialViewModelProvider(widget.tutorialId));
    final viewModel = ref
        .read(tutorialViewModelProvider(widget.tutorialId).notifier);
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
            const Text(' > Edit tutorial')
          ],
        ),
        body: asyncTutorial.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
          data: (tutorial) {
            if (tutorial != null) {
              return TutorialForm(
                id: tutorial.id,
                tutorial: tutorial,
                action: 'update',
                onSuccess: (id) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('A tutorial has been updated'),
                    backgroundColor: Colors.lightGreen,
                  ));
                },
                onFail: (exception) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(exception)));
                },
                addTutorial: viewModel.addTutorial,
                updateTutorial: viewModel.updateTutorial,
              );
            }

            return const Center(child: Text('Tutorial not found'));
          },
        ));
  }
}
