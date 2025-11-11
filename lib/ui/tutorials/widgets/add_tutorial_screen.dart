import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_turkmen_admin/ui/tutorials/view_model/tutorial_view_model.dart';
import 'package:modern_turkmen_admin/ui/tutorials/widgets/tutorial_form.dart';
import 'package:flutter/material.dart';

import '../../core/ui/main_layout.dart';

class AddTutorialScreen extends ConsumerWidget {
  const AddTutorialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(tutorialViewModelProvider(null));
    final viewModel = ref
        .read(tutorialViewModelProvider(null).notifier);
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
          const Text(' > Add tutorial')
        ],
      ),
      body: TutorialForm(
        action: 'create',
        onSuccess: (id) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('A tutorial has been created'),
            backgroundColor: Colors.lightGreen,
          ));
          context.go('/tutorials/edit-tutorial/$id');
        },
        onFail: () {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to create a tutorial')));
        },
        addTutorial: viewModel.addTutorial,
        updateTutorial: viewModel.updateTutorial,
      ),
    );
  }
}
