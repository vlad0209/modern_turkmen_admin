import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../config/dependencies.dart';
import '../../../data/repositories/auth/auth_repository.dart';

part 'main_layout_view_model.g.dart';

@riverpod
class MainLayoutViewModel extends _$MainLayoutViewModel {
  late AuthRepository _authRepository;
  @override
   build() {
    _authRepository = ref.watch(authRepositoryProvider);
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}