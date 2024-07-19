import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_turkmen_admin/constants.dart';
import 'package:modern_turkmen_admin/screens/add_exercise_screen.dart';
import 'package:modern_turkmen_admin/screens/edit_exercise_screen.dart';
import 'package:flutter/material.dart';
import 'package:modern_turkmen_admin/screens/tutorials_list_screen.dart';

import '../main_layout.dart';

class ExercisesListScreen extends StatefulWidget {
  const ExercisesListScreen({super.key, required this.tutorialId, required this.languageCode});
  final String tutorialId;
  final String languageCode;
  static String routePath = '/tutorials/:tutorial_id/:lang/exercises';

  @override
  State<ExercisesListScreen> createState() => _ExercisesListScreenState();
}

class _ExercisesListScreenState extends State<ExercisesListScreen> {
  late Stream<QuerySnapshot> _exercisesStream;
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

    _exercisesStream = FirebaseFirestore.instance.collection(
        'tutorials/${widget.tutorialId}/exercises_${widget.languageCode}'
    ).snapshots();

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
          Text(
            ' > Exercises${tutorialName.isNotEmpty ? ' of $tutorialName' : ''} '
                '(${kLanguages[widget.languageCode]})',
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
                              context.push(EditExerciseScreen.routePath
                                  .replaceFirst(':tutorial_id', widget.tutorialId)
                                  .replaceFirst(':lang', widget.languageCode)
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
          context.push(AddExerciseScreen.routePath.replaceFirst(
              ':tutorial_id',
              widget.tutorialId
          ).replaceFirst(':lang', widget.languageCode));
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
                        .doc('tutorials/${widget.tutorialId}/exercises_${widget.languageCode}/$exerciseId')
                        .delete()
                        .then((value) => Navigator.pop(context, 'OK'));
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }
}
