import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modern_turkmen_admin/data/services/firestore/model/exercise/exercise_firestore_model.dart';
import 'package:modern_turkmen_admin/data/services/firestore/model/tutorial/tutorial_firestore_model.dart';

import '../../../domain/models/user/user.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  Future<User> getUser(String currentUserId) async {
    final doc =
        await _firestore.collection('users').doc(currentUserId).get();
    if (!doc.exists || doc.data() == null) {
      throw Exception('User not found');
    }
    return User.fromJson({
      'id': doc.id,
      ...doc.data()!});
  }

  Stream<List<TutorialFirestoreModel>> getTutorialsStream() {
    return _firestore.collection('tutorials').orderBy(
          'created_at',
          descending: true,
        )
    .snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TutorialFirestoreModel.fromJson({
          'id': doc.id,
          ...doc.data(),
        });
      }).toList();
    });
  }
  
  Stream<List<ExerciseFirestoreModel>> getExercisesStream(String tutorialId, String languageCode) {
    return _firestore
        .collection('tutorials/$tutorialId/exercises_$languageCode')
        .orderBy('order_number')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ExerciseFirestoreModel.fromJson({
          'id': doc.id,
          ...doc.data(),
        });
      }).toList();
    });
  }

  Future<ExerciseFirestoreModel?> getExercise(String tutorialId, String languageCode, String exerciseId) async {
    final doc = await _firestore
        .collection('tutorials/$tutorialId/exercises_$languageCode')
        .doc(exerciseId)
        .get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return ExerciseFirestoreModel.fromJson({
      'id': doc.id,
      ...doc.data()!,
    });
  }

  Future<TutorialFirestoreModel> getTutorial(String tutorialId) async {
    final doc = await _firestore
        .collection('tutorials')
        .doc(tutorialId)
        .get();
    if (!doc.exists || doc.data() == null) {
      throw Exception('Tutorial not found');
    }
    return TutorialFirestoreModel.fromJson({
      'id': doc.id,
      ...doc.data()!,
    });
  }

  Future<String> createExercise(String tutorialId, String languageCode, ExerciseFirestoreModel exercise,) async {
    final ref = await _firestore
        .collection('tutorials/$tutorialId/exercises_$languageCode')
        .add(exercise.toJson());
    return ref.id;
  }

  Future<void> updateExercise(String tutorialId, String languageCode, ExerciseFirestoreModel exercise) async {
    await _firestore
        .collection('tutorials/$tutorialId/exercises_$languageCode')
        .doc(exercise.id)
        .update(exercise.toJson());
  }

  Future<List<ExerciseFirestoreModel>> getExercises(String tutorialId, String languageCode) async {
    final querySnapshot = await _firestore
        .collection('tutorials/$tutorialId/exercises_$languageCode')
        .orderBy('order_number')
        .get();
    return querySnapshot.docs.map((doc) {
      return ExerciseFirestoreModel.fromJson({
        'id': doc.id,
        ...doc.data(),
      });
    }).toList();
  }

  Future<void> deleteExercise(String tutorialId, String languageCode, String exerciseId) async {
    return await _firestore
        .collection('tutorials/$tutorialId/exercises_$languageCode')
        .doc(exerciseId)
        .delete();
  }

  Future<String> addTutorial(TutorialFirestoreModel tutorial) async {
    final tutorialsCount = await _firestore.collection('tutorials').get().then((value) => value.size);
    final ref = await _firestore
        .collection('tutorials')
        .add({...tutorial.toJson(), 'created_at': FieldValue.serverTimestamp(), 'index': tutorialsCount + 1});
    return ref.id;
  }

  Future<void> updateTutorial(TutorialFirestoreModel tutorial) async {
    await _firestore
        .collection('tutorials')
        .doc(tutorial.id)
        .update({...tutorial.toJson(), 'updated_at': FieldValue.serverTimestamp()});
  }

  Future<void> deleteTutorial(String tutorialId) async {
    await _firestore
        .collection('tutorials')
        .doc(tutorialId)
        .delete();
  }
}