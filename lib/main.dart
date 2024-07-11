import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modern_turkmen_admin/screens/add_tutorial_screen.dart';
import 'package:modern_turkmen_admin/screens/add_exercise_screen.dart';
import 'package:modern_turkmen_admin/screens/edit_tutorial_screen.dart';
import 'package:modern_turkmen_admin/screens/edit_exercise_screen.dart';
import 'package:modern_turkmen_admin/screens/tutorials_list_screen.dart';
import 'package:modern_turkmen_admin/screens/login_screen.dart';
import 'package:modern_turkmen_admin/screens/exercises_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VRouter(
      title: 'Modern Turkmen Admin',
      theme: ThemeData(
          brightness: Brightness.light,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 14.0),
          )),
      debugShowCheckedModeBanner: false,
      mode: VRouterMode.history,
      initialUrl: TutorialsListScreen.routePath,
      routes: [
        VWidget(path: LoginScreen.routePath, widget: const LoginScreen()),
        VGuard(
            beforeEnter: (vRedirector) async {
              bool authorized;
              User? currentUser = FirebaseAuth.instance.currentUser;
              currentUser ??= await FirebaseAuth.instance.authStateChanges().first;
              if(currentUser == null) {
                authorized = false;
              } else {
                final userData = (await FirebaseFirestore.instance.doc(
                    'users/${currentUser.uid}'
                ).get()).data();
                if(userData == null) {
                  authorized = false;
                } else {
                  authorized = userData['admin'];
                }
              }
              if(!authorized) {
                vRedirector.to(LoginScreen.routePath);
              } else {
                return null;
              }
            },
            stackedRoutes: [
              VWidget(
                  path: TutorialsListScreen.routePath,
                  widget: const TutorialsListScreen()),
              VWidget(
                  path: AddTutorialScreen.routePath,
                  widget: const AddTutorialScreen()
              ),
              VWidget(
                  path: EditTutorialScreen.routePath,
                  widget: const EditTutorialScreen()
              ),
              VWidget(
                  path: ExercisesListScreen.routePath,
                  widget: const ExercisesListScreen()
              ),
              VWidget(
                  path: AddExerciseScreen.routePath,
                  widget: const AddExerciseScreen()
              ),
              VWidget(
                  path: EditExerciseScreen.routePath,
                  widget: const EditExerciseScreen()
              ),
            ])
      ],
    );
  }
}
