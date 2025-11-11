import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService(this._auth);

  String? get currentUserId => _auth.currentUser?.uid;

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No user found for that email.');
        case 'wrong-password':
          throw Exception('Wrong password provided for that user.');
        default:
          throw Exception('Failed to sign in: ${e.message}');
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
