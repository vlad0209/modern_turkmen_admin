import 'package:go_router/go_router.dart';
import 'package:modern_turkmen_admin/screens/edit_tutorial_screen.dart';
import 'package:modern_turkmen_admin/screens/tutorials_list_screen.dart';
import 'package:modern_turkmen_admin/widgets/tutorial_form.dart';
import 'package:flutter/material.dart';

import '../main_layout.dart';

class AddTutorialScreen extends StatelessWidget {
  const AddTutorialScreen({super.key});
  static String routePath = '/tutorials/add-tutorial';

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: Row(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
                onTap: () {
                  context.push(TutorialsListScreen.routePath);
                },
                child: const Text(
                  'Tutorials',
                  style: TextStyle(color: Colors.white),
                )),
          ),
          const Text(' > Add tutorial')
        ],
      ),
      body: TutorialForm(
        action: 'create',
        onSuccess: (id) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('A tutorial has been created'),
                backgroundColor: Colors.lightGreen,
              )
          );
          context.push(EditTutorialScreen.routePath.replaceFirst(':id', id));
        },
        onFail: () {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to create a tutorial'))
          );
        },
      ),
    );
  }
}
