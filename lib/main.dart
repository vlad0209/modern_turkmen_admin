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
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.auth});
  final FirebaseAuth auth;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final _router = GoRouter(redirect: _redirect, routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => TutorialsListScreen.routePath,
    ),
    GoRoute(
      path: LoginScreen.routePath,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: TutorialsListScreen.routePath,
      builder: (context, state) => const TutorialsListScreen(),
    ),
    GoRoute(
      path: AddTutorialScreen.routePath,
      builder: (context, state) => const AddTutorialScreen(),
    ),
    GoRoute(
      path: EditTutorialScreen.routePath,
      builder: (context, state) => EditTutorialScreen(
        tutorialId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: ExercisesListScreen.routePath,
      builder: (context, state) => ExercisesListScreen(
        tutorialId: state.pathParameters['tutorial_id']!,
        languageCode: state.pathParameters['lang']!,
      ),
    ),
    GoRoute(
      path: AddExerciseScreen.routePath,
      builder: (context, state) => AddExerciseScreen(
        tutorialId: state.pathParameters['tutorial_id']!,
        language: state.pathParameters['lang']!,
      ),
    ),
    GoRoute(
      path: EditExerciseScreen.routePath,
      builder: (context, state) => EditExerciseScreen(
        tutorialId: state.pathParameters['tutorial_id']!,
        exerciseId: state.pathParameters['exercise_id']!,
        lang: state.pathParameters['lang']!,
      ),
    )
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
    final isLoginRoute = state.matchedLocation == LoginScreen.routePath;

    if (!isLoggedIn && !isLoginRoute) {
      return LoginScreen.routePath;
    } else if (isLoggedIn && isLoginRoute) {
      return TutorialsListScreen.routePath;
    }
    return null;
  }
}
