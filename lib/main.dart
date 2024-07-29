import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_turkmen_admin/screens/add_tutorial_screen.dart';
import 'package:modern_turkmen_admin/screens/add_exercise_screen.dart';
import 'package:modern_turkmen_admin/screens/edit_tutorial_screen.dart';
import 'package:modern_turkmen_admin/screens/edit_exercise_screen.dart';
import 'package:modern_turkmen_admin/screens/tutorials_list_screen.dart';
import 'package:modern_turkmen_admin/screens/login_screen.dart';
import 'package:modern_turkmen_admin/screens/exercises_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp(
      {super.key,
      required this.auth,
      required this.firestore,
      required this.storage});
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final _router = GoRouter(redirect: _redirect, routes: [
    GoRoute(
        path: '/',
        builder: (context, state) => TutorialsListScreen(
              firestore: widget.firestore,
              auth: widget.auth,
            ),
        routes: [
          GoRoute(
            path: 'login',
            builder: (context, state) => LoginScreen(
              auth: widget.auth,
              firestore: widget.firestore,
            ),
          ),
          GoRoute(
              path: 'tutorials',
              builder: (context, state) => TutorialsListScreen(
                    firestore: widget.firestore,
                    auth: widget.auth,
                  ),
              routes: [
                GoRoute(
                  path: 'add-tutorial',
                  builder: (context, state) => AddTutorialScreen(
                    auth: widget.auth,
                    firestore: widget.firestore,
                    storage: widget.storage,
                  ),
                ),
                GoRoute(
                  path: 'edit-tutorial/:id',
                  builder: (context, state) => EditTutorialScreen(
                    tutorialId: state.pathParameters['id']!,
                    auth: widget.auth,
                    firestore: widget.firestore,
                    storage: widget.storage,
                  ),
                ),
                GoRoute(
                  path: ':tutorial_id/:lang/exercises',
                  builder: (context, state) => ExercisesListScreen(
                    tutorialId: state.pathParameters['tutorial_id']!,
                    languageCode: state.pathParameters['lang']!,
                    firestore: widget.firestore,
                    auth: widget.auth,
                  ),
                ),
                GoRoute(
                  path: ':tutorial_id/:lang/add-exercise',
                  builder: (context, state) => AddExerciseScreen(
                    tutorialId: state.pathParameters['tutorial_id']!,
                    language: state.pathParameters['lang']!,
                    auth: widget.auth,
                    firestore: widget.firestore,
                    storage: widget.storage,
                  ),
                ),
                GoRoute(
                  path: ':tutorial_id/:lang/edit-exercise/:exercise_id',
                  builder: (context, state) => EditExerciseScreen(
                    auth: widget.auth,
                    tutorialId: state.pathParameters['tutorial_id']!,
                    exerciseId: state.pathParameters['exercise_id']!,
                    lang: state.pathParameters['lang']!,
                    firestore: widget.firestore,
                    storage: widget.storage,
                  ),
                )
              ]),
        ]),
  ]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Modern Turkmen Admin',
      theme: ThemeData(
          brightness: Brightness.light,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 14.0),
          )),
      debugShowCheckedModeBanner: false,
    );
  }

  String? _redirect(BuildContext context, GoRouterState state) {
    final isLoggedIn = widget.auth.currentUser != null;
    final isLoginRoute = state.matchedLocation == '/login';

    if (!isLoggedIn && !isLoginRoute) {
      return '/login';
    }
    return null;
  }
}
