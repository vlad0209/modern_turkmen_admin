import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_turkmen_admin/widgets/tutorial_form.dart';
import 'package:flutter/material.dart';

import '../main_layout.dart';

class EditTutorialScreen extends StatefulWidget {
  const EditTutorialScreen(
      {super.key,
      required this.tutorialId,
      required this.auth,
      required this.firestore,
      required this.storage});
  final String tutorialId;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  @override
  State<EditTutorialScreen> createState() => _EditTutorialScreenState();
}

class _EditTutorialScreenState extends State<EditTutorialScreen> {
  @override
  Widget build(BuildContext context) {
    late final DocumentReference tutorialRef =
        widget.firestore.collection('tutorials').doc(widget.tutorialId);

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
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            const Text(' > Edit tutorial')
          ],
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: tutorialRef.get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return TutorialForm(
                firestore: widget.firestore,
                id: snapshot.data?.id,
                data: snapshot.data?.data() as Map,
                action: 'update',
                onSuccess: (id) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('A tutorial has been updated'),
                    backgroundColor: Colors.lightGreen,
                  ));
                },
                onFail: (exception) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(exception)));
                },
                auth: widget.auth,
                storage: widget.storage,
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
