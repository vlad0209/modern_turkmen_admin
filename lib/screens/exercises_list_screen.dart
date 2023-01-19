import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modern_turkmen_admin/constants.dart';
import 'package:modern_turkmen_admin/screens/add_exercise_screen.dart';
import 'package:modern_turkmen_admin/screens/edit_exercise_screen.dart';
import 'package:flutter/material.dart';
import 'package:modern_turkmen_admin/screens/tutorials_list_screen.dart';
import 'package:vrouter/vrouter.dart';

import '../main_layout.dart';

class ExercisesListScreen extends StatefulWidget {
  const ExercisesListScreen({Key? key}) : super(key: key);
  static String routePath = '/tutorials/:tutorial_id/:lang/exercises';

  @override
  State<ExercisesListScreen> createState() => _ExercisesListScreenState();
}

class _ExercisesListScreenState extends State<ExercisesListScreen> {
  late Stream<QuerySnapshot> _exercisesStream;
  String tutorialName = '';
  late String tutorialId;
  late String languageCode;

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
    tutorialId = context.vRouter.pathParameters['tutorial_id']!;
    languageCode = context.vRouter.pathParameters['lang']!;

    _exercisesStream = FirebaseFirestore.instance.collection(
        'tutorials/$tutorialId/exercises_$languageCode'
    ).snapshots();

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
          Text(
            ' > Exercises${tutorialName.isNotEmpty ? ' of $tutorialName' : ''} '
                '(${kLanguages[languageCode]})',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _exercisesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView(
                padding: const EdgeInsets.all(11),
                shrinkWrap: true,
                children: snapshot.data!.docs
                    .map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return ListTile(
                        title: TextButton(
                          onPressed: () =>
                              context.vRouter.to(EditExerciseScreen.routePath
                                  .replaceFirst(':tutorial_id', tutorialId)
                                  .replaceFirst(':lang', languageCode)
                                  .replaceFirst(':exercise_id', document.id)),
                          child: Text(data['description']),
                        ),
                        trailing: IconButton(
                          onPressed: () => deleteExercise(document.id),
                          icon: const Icon(Icons.delete),
                        ),
                      );
                    })
                    .toList()
                    .cast());
          } else {
            return const Center(
              child: Text('There is no exercise available'),
            );
          }
        },
      ),
      floatActionButton: FloatingActionButton(
        onPressed: () {
          context.vRouter.to(AddExerciseScreen.routePath.replaceFirst(
              ':tutorial_id',
              tutorialId
          ).replaceFirst(':lang', languageCode));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void deleteExercise(String exerciseId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Deleting exercise'),
              content: const Text('Are you sure you want to delete this exercise'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel')),
                TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .doc('tutorials/$tutorialId/exercises_$languageCode/$exerciseId')
                        .delete()
                        .then((value) => Navigator.pop(context, 'OK'));
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }
}
