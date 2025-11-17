import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modern_turkmen_admin/config/dependencies.dart';
import 'package:modern_turkmen_admin/data/repositories/auth/auth_repository.dart';
import 'package:modern_turkmen_admin/ui/auth/view_model/login_view_model.dart';

import 'login_view_model_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockAuthRepository;
  late ProviderContainer container;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('LoginViewModel', () {
    test('should initialize correctly', () {
      final viewModel = container.read(loginViewModelProvider.notifier);
      expect(viewModel, isA<LoginViewModel>());
    });

    test('should call AuthRepository login method with correct parameters', () async {
      const email = 'test@example.com';
      const password = 'password123';

      when(mockAuthRepository.login(email: email, password: password))
          .thenAnswer((_) async => {});

      final viewModel = container.read(loginViewModelProvider.notifier);
      await viewModel.login(email: email, password: password);

      verify(mockAuthRepository.login(email: email, password: password)).called(1);
    });

    test('should propagate exception when login fails', () async {
      const email = 'test@example.com';
      const password = 'wrongpassword';
      final exception = Exception('Login failed');

      when(mockAuthRepository.login(email: email, password: password))
          .thenThrow(exception);

      final viewModel = container.read(loginViewModelProvider.notifier);

      expect(
        () => viewModel.login(email: email, password: password),
        throwsA(exception),
      );
    });
  });
}