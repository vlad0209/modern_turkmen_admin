import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_turkmen_admin/screens/tutorials_list_screen.dart';
import 'package:modern_turkmen_admin/widgets/tutorial_form.dart';
import 'package:flutter/material.dart';

import '../main_layout.dart';


class EditTutorialScreen extends StatefulWidget {
  const EditTutorialScreen({super.key, required this.tutorialId});
  static String routePath = '/tutorials/edit-tutorial/:id';
  final String tutorialId;

  @override
  State<EditTutorialScreen> createState() => _EditTutorialScreenState();
}

class _EditTutorialScreenState extends State<EditTutorialScreen> {
  @override
  Widget build(BuildContext context) {
    final DocumentReference tutorialRef = FirebaseFirestore.instance.collection(
        'tutorials'
    ).doc(widget.tutorialId);

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
            const Text(' > Edit tutorial')
          ],
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: tutorialRef.get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              return TutorialForm(
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
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
