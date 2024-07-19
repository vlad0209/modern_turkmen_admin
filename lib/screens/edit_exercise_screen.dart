import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_turkmen_admin/constants.dart';
import 'package:modern_turkmen_admin/screens/tutorials_list_screen.dart';
import 'package:modern_turkmen_admin/screens/exercises_list_screen.dart';
import 'package:modern_turkmen_admin/widgets/exercise_form.dart';
import 'package:flutter/material.dart';

import '../main_layout.dart';


class EditExerciseScreen extends StatefulWidget {
  const EditExerciseScreen({super.key, required this.tutorialId, required this.exerciseId, required this.lang});
  static String routePath = '/tutorials/:tutorial_id/:lang/edit-exercise/:exercise_id';
  final String tutorialId;
  final String exerciseId;
  final String lang;
  @override
  State<EditExerciseScreen> createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends State<EditExerciseScreen> {
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
    final DocumentReference exerciseRef = FirebaseFirestore.instance.collection(
        'tutorials/${widget.tutorialId}/exercises_${widget.lang}'
    ).doc(widget.exerciseId);

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
                    ).replaceFirst(':lang', widget.lang));
                  },
                  child: Text(
                    ' > Exercises${tutorialName.isNotEmpty ? ' of $tutorialName' :
                    ''} (${kLanguages[widget.lang]})',
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
                tutorialId: widget.tutorialId,
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
                }, languageCode: widget.lang,
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
