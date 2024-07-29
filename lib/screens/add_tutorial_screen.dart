import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_turkmen_admin/widgets/tutorial_form.dart';
import 'package:flutter/material.dart';

import '../main_layout.dart';

class AddTutorialScreen extends StatelessWidget {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  
  final FirebaseStorage storage;
  const AddTutorialScreen({super.key, required this.auth, required this.firestore, required this.storage});
  

  @override
  Widget build(BuildContext context) {
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
                  style: TextStyle(color: Colors.white),
                )),
          ),
          const Text(' > Add tutorial')
        ],
      ),
      body: TutorialForm(
        action: 'create',
        onSuccess: (id) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('A tutorial has been created'),
                backgroundColor: Colors.lightGreen,
              )
          );
          context.go('/tutorials/edit-tutorial/$id');
        },
        onFail: () {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to create a tutorial'))
          );
        },
        auth: auth, firestore: firestore, storage: storage,
      ), auth: auth,
    );
  }
}
