import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:modern_turkmen_admin/ui/core/ui/dropzone.dart';
import 'package:modern_turkmen_admin/config/dependencies.dart';
import 'package:modern_turkmen_admin/data/repositories/auth/auth_repository.dart';
import 'package:modern_turkmen_admin/data/repositories/file/file_repository.dart';

@GenerateMocks([FileRepository, AuthRepository])
import 'dropzone_test.mocks.dart';

void main() {
  group('Dropzone Widget Tests', () {
    late MockFileRepository mockFileRepository;
    late MockAuthRepository mockAuthRepository;
    late ProviderContainer container;

    setUp(() {
      mockFileRepository = MockFileRepository();
      mockAuthRepository = MockAuthRepository();
      container = ProviderContainer(
        overrides: [
          fileRepositoryProvider.overrideWithValue(mockFileRepository),
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('renders label correctly', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Dropzone(
                label: 'Upload Files',
                onFileUploaded: (downloadUrl, thumbnailUrl) {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Upload Files'), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('shows upload icon when not uploading', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Dropzone(
                label: 'Upload Files',
                onFileUploaded: (downloadUrl, thumbnailUrl) {},
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.upload_file), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });





    testWidgets('calls pickFiles on repository when TextButton is pressed', (tester) async {
      when(mockFileRepository.pickFiles(any, any)).thenAnswer((_) async => null);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Dropzone(
                label: 'Upload Files',
                onFileUploaded: (downloadUrl, thumbnailUrl) {},
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pump();

      verify(mockFileRepository.pickFiles(any, any)).called(1);
    });

    testWidgets('renders with custom width and height', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Dropzone(
                label: 'Upload Files',
                width: 300,
                height: 200,
                onFileUploaded: (downloadUrl, thumbnailUrl) {},
              ),
            ),
          ),
        ),
      );

      // Just verify the widget renders without error with custom dimensions
      expect(find.byType(Dropzone), findsOneWidget);
      expect(find.text('Upload Files'), findsOneWidget);
    });
  });
}