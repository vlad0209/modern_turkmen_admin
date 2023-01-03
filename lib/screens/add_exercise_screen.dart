import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modern_turkmen_admin/constants.dart';
import 'package:modern_turkmen_admin/screens/edit_exercise_screen.dart';
import 'package:modern_turkmen_admin/screens/tutorials_list_screen.dart';
import 'package:modern_turkmen_admin/screens/exercises_list_screen.dart';
import 'package:modern_turkmen_admin/widgets/exercise_form.dart';
import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

import '../main_layout.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({Key? key}) : super(key: key);
  static String routePath = '/tutorials/:tutorial_id/:lang/add-exercise/';

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  String tutorialName = '';
  String? tutorialId;
  String? language;

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
    tutorialId ??= context.vRouter.pathParameters['tutorial_id'];
    language ??= context.vRouter.pathParameters['lang'];

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
                  ).replaceFirst(':lang', language!));
                },
                child: Text(
                  ' > Exercises${tutorialName.isNotEmpty ? ' of $tutorialName' :
                  ''} (${kLanguages[language]})',
                  style: const TextStyle(color: Colors.white),
                )),
          ),
          const Text(' > Add exercise')
        ],
      ),
      body: ExerciseForm(
        tutorialId: tutorialId!,
        action: 'create',
        onSuccess: (tutorialId, exerciseId) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('An exercise has been created'),
                backgroundColor: Colors.lightGreen,
              )
          );
          context.vRouter.to(EditExerciseScreen.routePath.replaceFirst(
              ':tutorial_id',
              tutorialId
          ).replaceFirst(':exercise_id', exerciseId));
        },
        onFail: () {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to create an exercise'))
          );
        }, languageCode: language!,
      ),
    );
  }
}
