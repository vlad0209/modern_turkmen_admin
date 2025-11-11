import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_turkmen_admin/ui/tutorials/widgets/add_tutorial_screen.dart';
import 'package:modern_turkmen_admin/ui/exercises/widgets/add_exercise_screen.dart';
import 'package:modern_turkmen_admin/ui/tutorials/widgets/edit_tutorial_screen.dart';
import 'package:modern_turkmen_admin/ui/exercises/widgets/edit_exercise_screen.dart';
import 'package:modern_turkmen_admin/ui/tutorials/widgets/tutorials_list_screen.dart';
import 'package:modern_turkmen_admin/ui/auth/widgets/login_screen.dart';
import 'package:modern_turkmen_admin/ui/exercises/widgets/exercises_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'config/dependencies.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.userChanges().first;

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final _router =
      GoRouter(redirect: _redirect, initialLocation: '/tutorials', routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
        path: '/tutorials',
        builder: (context, state) => const TutorialsListScreen(),
        routes: [
          GoRoute(
            path: 'add-tutorial',
            builder: (context, state) => const AddTutorialScreen(),
          ),
          GoRoute(
            path: 'edit-tutorial/:id',
            builder: (context, state) => EditTutorialScreen(
              tutorialId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: ':tutorial_id/:lang/exercises',
            builder: (context, state) => ExercisesListScreen(
              tutorialId: state.pathParameters['tutorial_id']!,
              languageCode: state.pathParameters['lang']!,
            ),
          ),
          GoRoute(
            path: ':tutorial_id/:lang/add-exercise',
            builder: (context, state) => AddExerciseScreen(
              tutorialId: state.pathParameters['tutorial_id']!,
              language: state.pathParameters['lang']!,
            ),
          ),
          GoRoute(
            path: ':tutorial_id/:lang/edit-exercise/:exercise_id',
            builder: (context, state) => EditExerciseScreen(
                tutorialId: state.pathParameters['tutorial_id']!,
                exerciseId: state.pathParameters['exercise_id']!,
                lang: state.pathParameters['lang']!),
          )
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
    final authRepostiroy = ref.read(authRepositoryProvider);
    final isLoginRoute = state.matchedLocation == '/login';

    if (!authRepostiroy.isLoggedIn && !isLoginRoute) {
      return '/login';
    }
    return null;
  }
}
