import '../../services/auth_service.dart';
import '../../services/firestore/firestore_service.dart';
import 'auth_repository.dart';

class AuthRepositoryFirebase implements AuthRepository {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  AuthRepositoryFirebase(
      {required AuthService authService,
      required FirestoreService firestoreService})
      : _authService = authService,
        _firestoreService = firestoreService;
  @override
  Future<void> login({required String email, required String password}) async {
    await _authService.signInWithEmailAndPassword(
        email: email, password: password);
    final user = await _firestoreService.getUser(_authService.currentUserId!);
    if (!user.admin) {
      throw Exception('User does not have admin permissions');
    }
  }
  
  @override
  bool get isLoggedIn => _authService.currentUserId != null;
  
  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }
  
  @override
  String? get currentUserId => _authService.currentUserId;
}
