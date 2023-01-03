import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modern_turkmen_admin/constants.dart';
import 'package:modern_turkmen_admin/screens/tutorials_list_screen.dart';
import 'package:modern_turkmen_admin/screens/exercises_list_screen.dart';
import 'package:modern_turkmen_admin/widgets/tutorial_form.dart';
import 'package:modern_turkmen_admin/widgets/exercise_form.dart';
import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

import '../main_layout.dart';


class EditExerciseScreen extends StatefulWidget {
  const EditExerciseScreen({Key? key}) : super(key: key);
  static String routePath = '/tutorials/:tutorial_id/:lang/edit-exercise/:exercise_id';

  @override
  State<EditExerciseScreen> createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends State<EditExerciseScreen> {
  String tutorialName = '';

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      String? tutorialId = context.vRouter.pathParameters['tutorial_id'];

      FirebaseFirestore.instance.collection('tutorials')
          .doc(tutorialId).get().then((tutorial) {
        setState(() {
          tutorialName = tutorial['title_en'];
        });
      });

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String? exerciseId = context.vRouter.pathParameters['exercise_id'];
    String? tutorialId = context.vRouter.pathParameters['tutorial_id'];
    String? lang = context.vRouter.pathParameters['lang'];
    final DocumentReference exerciseRef = FirebaseFirestore.instance.collection(
        'tutorials/$tutorialId/exercises_$lang'
    ).doc(exerciseId);

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
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                  onTap: () {
                    context.vRouter.to(ExercisesListScreen.routePath.replaceFirst(
                        ':tutorial_id',
                        tutorialId!
                    ).replaceFirst(':lang', lang!));
                  },
                  child: Text(
                    ' > Exercises${tutorialName.isNotEmpty ? ' of $tutorialName' :
                    ''} (${kLanguages[lang]})',
                    style: const TextStyle(color: Colors.white),
                  )),
            ),
            const Text(' > Edit exercise')
          ],
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: exerciseRef.get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              return ExerciseForm(
                id: snapshot.data?.id,
                tutorialId: tutorialId!,
                data: snapshot.data?.data() as Map,
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
                }, languageCode: lang!,
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
