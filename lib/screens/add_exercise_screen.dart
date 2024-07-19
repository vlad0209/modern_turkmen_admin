import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_turkmen_admin/constants.dart';
import 'package:modern_turkmen_admin/screens/edit_exercise_screen.dart';
import 'package:modern_turkmen_admin/screens/tutorials_list_screen.dart';
import 'package:modern_turkmen_admin/screens/exercises_list_screen.dart';
import 'package:modern_turkmen_admin/widgets/exercise_form.dart';
import 'package:flutter/material.dart';

import '../main_layout.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({super.key, required this.tutorialId, required this.language});
  static String routePath = '/tutorials/:tutorial_id/:lang/add-exercise/';
  final String tutorialId;
  final String language;

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  String tutorialName = '';
  

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      FirebaseFirestore.instance.collection('tutorials')
          .doc(widget.tutorialId).get().then((tutorial) {
        setState(() {
          tutorialName = tutorial['title_en'];
        });

      });

    });
    super.initState();
  }
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
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
                onTap: () {
                  context.push(ExercisesListScreen.routePath.replaceFirst(
                      ':tutorial_id',
                      widget.tutorialId
                  ).replaceFirst(':lang', widget.language));
                },
                child: Text(
                  ' > Exercises${tutorialName.isNotEmpty ? ' of $tutorialName' :
                  ''} (${kLanguages[widget.language]})',
                  style: const TextStyle(color: Colors.white),
                )),
          ),
          const Text(' > Add exercise')
        ],
      ),
      body: ExerciseForm(
        tutorialId: widget.tutorialId,
        action: 'create',
        onSuccess: (tutorialId, exerciseId) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('An exercise has been created'),
                backgroundColor: Colors.lightGreen,
              )
          );
          context.push(EditExerciseScreen.routePath.replaceFirst(
              ':tutorial_id',
              tutorialId
          ).replaceFirst(':exercise_id', exerciseId).replaceFirst(
              ':lang',
              widget.language
          ));
        },
        onFail: () {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to create an exercise'))
          );
        }, languageCode: widget.language,
      ),
    );
  }
}
