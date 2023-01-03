import 'package:modern_turkmen_admin/screens/edit_tutorial_screen.dart';
import 'package:modern_turkmen_admin/screens/tutorials_list_screen.dart';
import 'package:modern_turkmen_admin/widgets/tutorial_form.dart';
import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

import '../main_layout.dart';

class AddTutorialScreen extends StatelessWidget {
  const AddTutorialScreen({Key? key}) : super(key: key);
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
                  context.vRouter.to(TutorialsListScreen.routePath);
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
          context.vRouter.to(EditTutorialScreen.routePath.replaceFirst(':id', id));
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
