import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modern_turkmen_admin/config/dependencies.dart';
import 'package:modern_turkmen_admin/data/repositories/auth/auth_repository.dart';
import 'package:modern_turkmen_admin/ui/core/view_model/main_layout_view_model.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

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

  group('MainLayoutViewModel', () {
    test('should initialize with auth repository', () {
      final viewModel = container.read(mainLayoutViewModelProvider.notifier);
      
      expect(viewModel, isA<MainLayoutViewModel>());
    });

    test('should call signOut on auth repository', () async {
      when(() => mockAuthRepository.signOut()).thenAnswer((_) async {});
      
      final viewModel = container.read(mainLayoutViewModelProvider.notifier);
      
      await viewModel.signOut();
      
      verify(() => mockAuthRepository.signOut()).called(1);
    });

    test('should handle signOut errors', () async {
      when(() => mockAuthRepository.signOut()).thenThrow(Exception('Sign out failed'));
      
      final viewModel = container.read(mainLayoutViewModelProvider.notifier);
      
      expect(() => viewModel.signOut(), throwsException);
    });
  });
}