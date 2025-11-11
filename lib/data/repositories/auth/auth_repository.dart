abstract class AuthRepository {
  bool get isLoggedIn;

  String? get currentUserId;

  Future<void> login({required String email, required String password});

  Future<void> signOut();
}