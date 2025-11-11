import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../config/dependencies.dart';
import '../../../data/repositories/auth/auth_repository.dart';

part 'login_view_model.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel {
  late AuthRepository _authRepository;
  @override
   build() {
    _authRepository = ref.watch(authRepositoryProvider);
  }

  Future<void> login({required String email, required String password}) async {
    await _authRepository.login(email: email, password: password);
  }
}