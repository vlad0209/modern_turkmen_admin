import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_turkmen_admin/constants.dart';
import 'package:modern_turkmen_admin/widgets/exercise_form.dart';
import 'package:flutter/material.dart';

import '../main_layout.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen(
      {super.key,
      required this.tutorialId,
      required this.language,
      required this.auth,
      required this.firestore,
      required this.storage});
  final String tutorialId;
  final String language;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
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
                      '/tutorials/${widget.tutorialId}/${widget.language}/exercises');
                },
                child: Text(
                  ' > Exercises${tutorialName.isNotEmpty ? ' of $tutorialName' : ''} (${kLanguages[widget.language]})',
                )),
          ),
          const Text(' > Add exercise')
        ],
      ),
      body: ExerciseForm(
        tutorialId: widget.tutorialId,
        action: 'create',
        onSuccess: (tutorialId, exerciseId) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('An exercise has been created'),
            backgroundColor: Colors.lightGreen,
          ));
          context.go(
              '/tutorials/$tutorialId/${widget.language}/edit-exercise/$exerciseId');
        },
        onFail: () {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to create an exercise')));
        },
        languageCode: widget.language,
        auth: widget.auth,
        firestore: widget.firestore,
        storage: widget.storage,
      ),
    );
  }
}
