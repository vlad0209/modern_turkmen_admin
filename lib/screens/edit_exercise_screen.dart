import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_turkmen_admin/constants.dart';
import 'package:modern_turkmen_admin/widgets/exercise_form.dart';
import 'package:flutter/material.dart';

import '../main_layout.dart';

class EditExerciseScreen extends StatefulWidget {
  const EditExerciseScreen(
      {super.key,
      required this.tutorialId,
      required this.exerciseId,
      required this.lang,
      required this.auth,
      required this.firestore,
      required this.storage});
  final String tutorialId;
  final String exerciseId;
  final String lang;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  @override
  State<EditExerciseScreen> createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends State<EditExerciseScreen> {
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
    final DocumentReference exerciseRef = widget.firestore
        .collection('tutorials/${widget.tutorialId}/exercises_${widget.lang}')
        .doc(widget.exerciseId);

    return MainLayout(
        auth: widget.auth,
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
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                  onTap: () {
                    context.go(
                        '/tutorials/${widget.tutorialId}/${widget.lang}/exercises');
                  },
                  child: Text(
                    ' > Exercises${tutorialName.isNotEmpty ? ' of $tutorialName' : ''} (${kLanguages[widget.lang]})',
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
                firestore: widget.firestore,
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
                },
                languageCode: widget.lang,
                auth: widget.auth,
                storage: widget.storage,
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
