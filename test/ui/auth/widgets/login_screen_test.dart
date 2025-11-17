import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'dart:async';
import 'package:modern_turkmen_admin/config/dependencies.dart';
import 'package:modern_turkmen_admin/data/repositories/auth/auth_repository.dart';
import 'package:modern_turkmen_admin/ui/auth/widgets/login_screen.dart';

import 'login_screen_test.mocks.dart';

@GenerateMocks([AuthRepository, GoRouter])
void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  Widget createTestWidget() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
    
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const LoginScreen(),
            ),
            GoRoute(
              path: '/tutorials',
              builder: (context, state) => const Scaffold(body: Text('Tutorials')),
            ),
          ],
        ),
      ),
    );
  }

  group('LoginScreen', () {
    testWidgets('renders login form correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('shows validation errors for empty fields', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Please enter an email address'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
    });

    testWidgets('calls login when form is valid', (tester) async {
      when(mockAuthRepository.login(email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async {});

      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      verify(mockAuthRepository.login(email: 'test@example.com', password: 'password123')).called(1);
    });

    testWidgets('shows loading spinner during login', (tester) async {
      final completer = Completer<void>();
      when(mockAuthRepository.login(email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) => completer.future);

      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Login'), findsNothing);

      completer.complete();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('shows error message on login failure', (tester) async {
      when(mockAuthRepository.login(email: anyNamed('email'), password: anyNamed('password')))
          .thenThrow(Exception('Login failed'));

      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'wrongpassword');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Exception: Login failed'), findsOneWidget);
    });

    testWidgets('submits form on email field enter', (tester) async {
      when(mockAuthRepository.login(email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async {});

      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      verify(mockAuthRepository.login(email: 'test@example.com', password: 'password123')).called(1);
    });

    testWidgets('submits form on password field enter', (tester) async {
      when(mockAuthRepository.login(email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async {});

      await tester.pumpWidget(createTestWidget());

      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      verify(mockAuthRepository.login(email: 'test@example.com', password: 'password123')).called(1);
    });
  });
}