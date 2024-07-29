import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_turkmen_admin/constants.dart';
import 'package:flutter/material.dart';

import '../main_layout.dart';

class ExercisesListScreen extends StatefulWidget {
  const ExercisesListScreen(
      {super.key, required this.tutorialId, required this.languageCode, required this.firestore, required this.auth});
  final String tutorialId;
  final String languageCode;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  @override
  State<ExercisesListScreen> createState() => _ExercisesListScreenState();
}

class _ExercisesListScreenState extends State<ExercisesListScreen> {
  late Stream<QuerySnapshot> _exercisesStream;
  String tutorialName = '';

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      widget.firestore
          .collection('tutorials')
          .doc(widget.tutorialId)
          .get()
          .then((tutorial) {
        setState(() {
          tutorialName = tutorial['title_en'];
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _exercisesStream = widget.firestore
        .collection(
            'tutorials/${widget.tutorialId}/exercises_${widget.languageCode}')
            .orderBy('order_number')
        .snapshots();

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
          Text(
            ' > Exercises${tutorialName.isNotEmpty ? ' of $tutorialName' : ''} '
            '(${kLanguages[widget.languageCode]})',
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
                          onPressed: () => context.go(
                              '/tutorials/${widget.tutorialId}/${widget.languageCode}/edit-exercise/${document.id}'),
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
          context.go('/tutorials/${widget.tutorialId}/${widget.languageCode}/add-exercise');
        },
        child: const Icon(Icons.add),
      ), auth: widget.auth,
    );
  }

  void deleteExercise(String exerciseId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Deleting exercise'),
              content:
                  const Text('Are you sure you want to delete this exercise'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel')),
                TextButton(
                  onPressed: () {
                    widget.firestore
                        .doc(
                            'tutorials/${widget.tutorialId}/exercises_${widget.languageCode}/$exerciseId')
                        .delete()
                        .then((value) => Navigator.pop(context, 'OK'));
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }
}
