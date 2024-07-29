import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_turkmen_admin/constants.dart';
import 'package:flutter/material.dart';

import '../main_layout.dart';

class TutorialsListScreen extends StatefulWidget {
  const TutorialsListScreen({super.key, required this.firestore, required this.auth});
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  @override
  State<TutorialsListScreen> createState() => _TutorialsListScreenState();
}

class _TutorialsListScreenState extends State<TutorialsListScreen> {
  late final Stream<QuerySnapshot> _tutorialsStream =
      widget.firestore.collection('tutorials').orderBy(
          'created_at',
          descending: true
      ).snapshots();


  @override
  Widget build(BuildContext context) {
    return MainLayout(
      auth: widget.auth,
      title: const Text('Tutorials'),
      body: StreamBuilder<QuerySnapshot>(
        stream: _tutorialsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
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
                              context.go('/tutorials/edit-tutorial/${document.id}'),
                          child: Text(data['title_en']),
                        ),
                        trailing: SizedBox(
                          width: 400,
                          child: Row(
                            children: [
                              Row(
                                children: kLanguages.keys.map(
                                        (languageCode) => TextButton(
                                          onPressed: () => context.go(
                                            '/tutorials/${document.id}/$languageCode/exercises'
                                          ), 
                                          child: Text('Exercises (${kLanguages[languageCode]})'),
                                        ))
                                    .toList().cast(),
                              ),
                              IconButton(
                                onPressed: () => deleteTutorial(document.id),
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                    .toList()
                    .cast());
          } else {
            return const Center(
              child: Text('There is no tutorials available'),
            );
          }
        },
      ),
      floatActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/tutorials/add-tutorial');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void deleteTutorial(String tutorialId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Deleting tutorial'),
              content: const Text('Are you sure you want to delete this tutorial'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel')),
                TextButton(
                  onPressed: () {
                    widget.firestore
                        .doc('tutorials/$tutorialId')
                        .delete()
                        .then((value) => Navigator.pop(context, 'OK'));
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }
}
