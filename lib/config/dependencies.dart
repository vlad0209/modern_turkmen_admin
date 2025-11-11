import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modern_turkmen_admin/data/repositories/audio/audio_repository_remote.dart';
import 'package:modern_turkmen_admin/data/repositories/file/file_repository_storage.dart';
import 'package:modern_turkmen_admin/data/services/image_picker_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repositories/audio/audio_repository.dart';
import '../data/repositories/auth/auth_repository.dart';
import '../data/repositories/auth/auth_repository_firebase.dart';
import '../data/repositories/exercise/exercise_repository.dart';
import '../data/repositories/exercise/exercise_repository_firestore.dart';
import '../data/repositories/file/file_repository.dart';
import '../data/repositories/tutorial/tutorial_repository.dart';
import '../data/repositories/tutorial/tutorial_repository_firestore.dart';
import '../data/services/audio_player_service.dart';
import '../data/services/auth_service.dart';
import '../data/services/firebase_storage_service.dart';
import '../data/services/firestore/firestore_service.dart';

part 'dependencies.g.dart';

@riverpod
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

@riverpod
FirebaseFirestore firebaseFirestore(Ref ref) {
  return FirebaseFirestore.instance;
}

@riverpod
FirebaseStorage firebaseStorage(Ref ref) {
  return FirebaseStorage.instance;
}

@riverpod
AudioPlayer audioPlayer(Ref ref) {
  return AudioPlayer();
}

@riverpod
AuthService authService(Ref ref) {
  return AuthService(ref.watch(firebaseAuthProvider));
}

@riverpod
FirestoreService firestoreService(Ref ref) {
  return FirestoreService(ref.watch(firebaseFirestoreProvider));
}

@riverpod
FirebaseStorageService firebaseStorageService(Ref ref) {
  return FirebaseStorageService(ref.watch(firebaseStorageProvider));
}

@riverpod
ImagePickerService imagePickerService(Ref ref) {
  return ImagePickerService();
}

@riverpod
AudioPlayerService audioPlayerService(Ref ref) {
  return AudioPlayerService(ref.watch(audioPlayerProvider));
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryFirebase(
      authService: ref.watch(authServiceProvider),
      firestoreService: ref.watch(firestoreServiceProvider));
}

@riverpod
FileRepository fileRepository(Ref ref) {
  return FileRepositoryStorage(
      firebaseStorageService: ref.watch(firebaseStorageServiceProvider),
      imagePickerService: ref.watch(imagePickerServiceProvider));
}

@riverpod
ExerciseRepository exerciseRepository(Ref ref) {
  return ExerciseRepositoryFirestore(
      firestoreService: ref.watch(firestoreServiceProvider));
}

@riverpod
TutorialRepository tutorialRepository(Ref ref) {
  return TutorialRepositoryFirestore(
      firestoreService: ref.watch(firestoreServiceProvider));
}

@riverpod
AudioRepository audioRepository(Ref ref) {
  return AudioRepositoryRemote(
      audioPlayerService: ref.watch(audioPlayerServiceProvider));
}