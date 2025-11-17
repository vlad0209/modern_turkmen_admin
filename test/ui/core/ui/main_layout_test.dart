import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:modern_turkmen_admin/ui/core/ui/main_layout.dart';
import 'package:modern_turkmen_admin/data/repositories/auth/auth_repository.dart';
import 'package:modern_turkmen_admin/config/dependencies.dart';

import 'main_layout_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  Widget createTestWidget({
    Widget? body,
    Widget? title,
    Widget? floatActionButton,
    String initialLocation = '/tutorials',
  }) {
    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/tutorials',
          builder: (context, state) => MainLayout(
            title: title ?? const Text('Test Title'),
            body: body ?? const Text('Test Body'),
            floatActionButton: floatActionButton,
          ),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const Scaffold(body: Text('Login Page')),
        ),
      ],
    );

    return UncontrolledProviderScope(
      container: ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      ),
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  group('MainLayout Widget Tests', () {
    testWidgets('should display provided title and body', (tester) async {
      await tester.pumpWidget(createTestWidget(
        title: const Text('Custom Title'),
        body: const Text('Custom Body'),
      ));

      expect(find.text('Custom Title'), findsOneWidget);
      expect(find.text('Custom Body'), findsOneWidget);
    });

    testWidgets('should display floating action button when provided', (tester) async {
      await tester.pumpWidget(createTestWidget(
        floatActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ));

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('should display drawer with logo and tutorials menu', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.byType(DrawerHeader), findsOneWidget);
      expect(find.text('Tutorials'), findsOneWidget);
    });

    testWidgets('should navigate to tutorials when drawer item is tapped', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tutorials'));
      await tester.pumpAndSettle();

      // After tapping tutorials, we should still be on the tutorials page
      expect(find.text('Test Body'), findsOneWidget);
    });

    testWidgets('should display sign out button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Sign Out'), findsOneWidget);
    });

    testWidgets('calls signOut when Sign Out button is tapped', (tester) async {
      when(mockAuthRepository.signOut()).thenAnswer((_) async {});
      
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('Sign Out'));
      await tester.pumpAndSettle();

      verify(mockAuthRepository.signOut()).called(1);
    });

    testWidgets('should select tutorials menu item when on tutorials route', (tester) async {
      await tester.pumpWidget(createTestWidget(initialLocation: '/tutorials'));

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      final tutorialsListTile = find.ancestor(
        of: find.text('Tutorials'),
        matching: find.byType(ListTile),
      );

      final listTile = tester.widget<ListTile>(tutorialsListTile);
      expect(listTile.selected, isTrue);
    });
  });
}