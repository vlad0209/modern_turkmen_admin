import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_turkmen_admin/config/dependencies.dart';
import 'package:modern_turkmen_admin/data/repositories/audio/audio_repository_remote.dart';
import 'package:modern_turkmen_admin/data/repositories/auth/auth_repository_firebase.dart';
import 'package:modern_turkmen_admin/data/repositories/exercise/exercise_repository_firestore.dart';
import 'package:modern_turkmen_admin/data/repositories/file/file_repository_storage.dart';
import 'package:modern_turkmen_admin/data/repositories/tutorial/tutorial_repository_firestore.dart';
import 'package:modern_turkmen_admin/data/services/audio_player_service.dart';
import 'package:modern_turkmen_admin/data/services/auth_service.dart';
import 'package:modern_turkmen_admin/data/services/firebase_storage_service.dart';
import 'package:modern_turkmen_admin/data/services/firestore/firestore_service.dart';
import 'package:modern_turkmen_admin/data/services/image_picker_service.dart';

void main() {
  group('Dependencies', () {
    late ProviderContainer container;

    setUpAll(() async {
      // Initialize Flutter binding for tests
      TestWidgetsFlutterBinding.ensureInitialized();
      
      // Setup method channel mock for AudioPlayer
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('xyz.luan/audioplayers'),
        (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'create':
              return {'playerId': 'test_player_id'};
            case 'setGlobalAudioContext':
              return null;
            default:
              return null;
          }
        },
      );
      
      // Setup method channel mock for GlobalAudioScope
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('xyz.luan/audioplayers.global'),
        (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'setGlobalAudioContext':
              return null;
            default:
              return null;
          }
        },
      );
    });

    tearDownAll(() async {
      // Clean up method channel mocks
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('xyz.luan/audioplayers'),
        null,
      );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('xyz.luan/audioplayers.global'),
        null,
      );
    });

    setUp(() {
      // Create mock instances
      final mockAuth = MockFirebaseAuth();
      final mockFirestore = FakeFirebaseFirestore();
      final mockStorage = MockFirebaseStorage();

      // Create container with overrides for Firebase services
      container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
          firebaseFirestoreProvider.overrideWithValue(mockFirestore),
          firebaseStorageProvider.overrideWithValue(mockStorage),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('firebaseAuth provider returns FirebaseAuth instance', () {
      final auth = container.read(firebaseAuthProvider);
      expect(auth, isA<FirebaseAuth>());
    });

    test('firebaseFirestore provider returns FirebaseFirestore instance', () {
      final firestore = container.read(firebaseFirestoreProvider);
      expect(firestore, isA<FirebaseFirestore>());
    });

    test('firebaseStorage provider returns FirebaseStorage instance', () {
      final storage = container.read(firebaseStorageProvider);
      expect(storage, isA<FirebaseStorage>());
    });

    test('audioPlayer provider returns AudioPlayer instance', () {
      final player = container.read(audioPlayerProvider);
      expect(player, isA<AudioPlayer>());
    });

    test('authService provider returns AuthService instance', () {
      final service = container.read(authServiceProvider);
      expect(service, isA<AuthService>());
    });

    test('firestoreService provider returns FirestoreService instance', () {
      final service = container.read(firestoreServiceProvider);
      expect(service, isA<FirestoreService>());
    });

    test('firebaseStorageService provider returns FirebaseStorageService instance', () {
      final service = container.read(firebaseStorageServiceProvider);
      expect(service, isA<FirebaseStorageService>());
    });

    test('imagePickerService provider returns ImagePickerService instance', () {
      final service = container.read(imagePickerServiceProvider);
      expect(service, isA<ImagePickerService>());
    });

    test('audioPlayerService provider returns AudioPlayerService instance', () {
      final service = container.read(audioPlayerServiceProvider);
      expect(service, isA<AudioPlayerService>());
    });

    test('authRepository provider returns AuthRepositoryFirebase instance', () {
      final repository = container.read(authRepositoryProvider);
      expect(repository, isA<AuthRepositoryFirebase>());
    });

    test('fileRepository provider returns FileRepositoryStorage instance', () {
      final repository = container.read(fileRepositoryProvider);
      expect(repository, isA<FileRepositoryStorage>());
    });

    test('exerciseRepository provider returns ExerciseRepositoryFirestore instance', () {
      final repository = container.read(exerciseRepositoryProvider);
      expect(repository, isA<ExerciseRepositoryFirestore>());
    });

    test('tutorialRepository provider returns TutorialRepositoryFirestore instance', () {
      final repository = container.read(tutorialRepositoryProvider);
      expect(repository, isA<TutorialRepositoryFirestore>());
    });

    test('audioRepository provider returns AudioRepositoryRemote instance', () {
      final repository = container.read(audioRepositoryProvider);
      expect(repository, isA<AudioRepositoryRemote>());
    });
  });
}