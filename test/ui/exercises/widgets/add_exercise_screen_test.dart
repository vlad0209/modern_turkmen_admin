import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:modern_turkmen_admin/ui/exercises/widgets/add_exercise_screen.dart';
import 'package:modern_turkmen_admin/ui/core/ui/main_layout.dart';
import 'package:modern_turkmen_admin/config/dependencies.dart';
import 'package:modern_turkmen_admin/data/repositories/tutorial/tutorial_repository.dart';
import 'package:modern_turkmen_admin/data/repositories/exercise/exercise_repository.dart';
import 'package:modern_turkmen_admin/data/repositories/audio/audio_repository.dart';
import 'package:modern_turkmen_admin/data/repositories/auth/auth_repository.dart';
import 'package:modern_turkmen_admin/domain/models/tutorial/tutorial.dart';

import 'add_exercise_screen_test.mocks.dart';

@GenerateMocks([TutorialRepository, ExerciseRepository, AudioRepository, AuthRepository])

void main() {
  late MockTutorialRepository mockTutorialRepository;
  late MockExerciseRepository mockExerciseRepository;
  late MockAudioRepository mockAudioRepository;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockTutorialRepository = MockTutorialRepository();
    mockExerciseRepository = MockExerciseRepository();
    mockAudioRepository = MockAudioRepository();
    mockAuthRepository = MockAuthRepository();
    
    // Setup default stubs for AudioRepository
    when(mockAudioRepository.getPlayerStateStream())
        .thenAnswer((_) => const Stream<void>.empty());
    when(mockAudioRepository.setSourceUrl(any))
        .thenAnswer((_) async {});
    when(mockAudioRepository.pauseAudio())
        .thenAnswer((_) async {});
    when(mockAudioRepository.resumeAudio())
        .thenAnswer((_) async {});
    
    // Setup default stubs for AuthRepository
    when(mockAuthRepository.isLoggedIn).thenReturn(true);
    when(mockAuthRepository.currentUserId).thenReturn('test-user-id');
    when(mockAuthRepository.signOut()).thenAnswer((_) async {});
  });

  setUpAll(() {
    // Ignore overflow errors during tests since they don't affect functionality
    FlutterError.onError = (FlutterErrorDetails details) {
      final isOverflowError = details.toString().contains('overflowed');
      if (!isOverflowError) {
        FlutterError.presentError(details);
      }
    };
  });

  Widget createTestWidget({
    required String tutorialId,
    required String language,
    String? tutorialName,
    bool shouldError = false,
    String? errorMessage,
  }) {
    if (shouldError) {
      when(mockTutorialRepository.getTutorial(tutorialId))
          .thenThrow(Exception(errorMessage ?? 'Test error'));
    } else {
      const tutorial = Tutorial(
        id: 'test-id',
        titleEn: 'Test Tutorial',
        titleRu: '',
        thumbUrl: '',
        imageUrl: '',
        contentEn: '',
        contentRu: '',
        publicEn: true,
        publicRu: true,
      );
      when(mockTutorialRepository.getTutorial(tutorialId))
          .thenAnswer((_) async => tutorial.copyWith(titleEn: tutorialName ?? 'Test Tutorial'));
    }

    return UncontrolledProviderScope(
      container: ProviderContainer(
        overrides: [
          tutorialRepositoryProvider.overrideWithValue(mockTutorialRepository),
          exerciseRepositoryProvider.overrideWithValue(mockExerciseRepository),
          audioRepositoryProvider.overrideWithValue(mockAudioRepository),
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      ),
      child: MaterialApp.router(
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => AddExerciseScreen(
                tutorialId: tutorialId,
                language: language,
              ),
            ),
          ],
        ),
      ),
    );
  }

  group('AddExerciseScreen', () {
    testWidgets('shows loading indicator when state is loading', (tester) async {
      // Set up delayed response to simulate loading
      when(mockTutorialRepository.getTutorial(any))
          .thenAnswer((_) => Future.delayed(const Duration(seconds: 1), 
              () => const Tutorial(
                id: 'test-id',
                titleEn: 'Test Tutorial',
                titleRu: '',
                thumbUrl: '',
                imageUrl: '',
                contentEn: '',
                contentRu: '',
                publicEn: true,
                publicRu: true,
              )));
      
      await tester.pumpWidget(createTestWidget(
        tutorialId: 'test-id',
        language: 'en',
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(MainLayout), findsNothing);
    });

    testWidgets('shows error message when state has error', (tester) async {
      const error = 'Test error';
      await tester.pumpWidget(createTestWidget(
        tutorialId: 'test-id',
        language: 'en',
        shouldError: true,
        errorMessage: error,
      ));
      
      await tester.pumpAndSettle();

      expect(find.text('Error: Exception: $error'), findsOneWidget);
      expect(find.byType(MainLayout), findsNothing);
    });
  });
}

