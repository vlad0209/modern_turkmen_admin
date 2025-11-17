import 'dart:typed_data';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:modern_turkmen_admin/config/dependencies.dart';
import 'package:modern_turkmen_admin/data/repositories/auth/auth_repository.dart';
import 'package:modern_turkmen_admin/data/repositories/file/file_repository.dart';
import 'package:modern_turkmen_admin/ui/core/ui_state/dropzone_ui_state.dart';
import 'package:modern_turkmen_admin/ui/core/view_model/dropzone_view_model.dart';

import 'dropzone_view_model_test.mocks.dart';

@GenerateMocks([FileRepository, AuthRepository, DropzoneViewController])
void main() {
  late MockFileRepository mockFileRepository;
  late MockAuthRepository mockAuthRepository;
  late MockDropzoneViewController mockController;
  late ProviderContainer container;

  setUp(() {
    mockFileRepository = MockFileRepository();
    mockAuthRepository = MockAuthRepository();
    mockController = MockDropzoneViewController();

    container = ProviderContainer(
      overrides: [
        fileRepositoryProvider.overrideWithValue(mockFileRepository),
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('DropzoneViewModel', () {
    test('build returns initial state', () {
      final allowedMimeTypes = ['image/png'];
      const isMultiple = false;
      final provider = dropzoneViewModelProvider(allowedMimeTypes, isMultiple);

      container.read(provider.notifier);
      final state = container.read(provider);

      expect(state, isA<DropzoneUiState>());
      expect(state.isUploading, false);
      expect(state.isHighlighted, false);
      expect(state.isError, false);
    });

    test('setController sets controller', () {
      final allowedMimeTypes = ['image/png'];
      const isMultiple = false;
      final provider = dropzoneViewModelProvider(allowedMimeTypes, isMultiple);
      final viewModel = container.read(provider.notifier);

      viewModel.setController(mockController);

      // Controller is set internally, no direct way to verify but method should not throw
      expect(() => viewModel.setController(mockController), returnsNormally);
    });

    test('setIsHighlighted updates state', () {
      final allowedMimeTypes = ['image/png'];
      const isMultiple = false;
      final provider = dropzoneViewModelProvider(allowedMimeTypes, isMultiple);
      final viewModel = container.read(provider.notifier);

      viewModel.setIsHighlighted(true);

      final state = container.read(provider);
      expect(state.isHighlighted, true);
    });

    test('setIsError updates state', () {
      final allowedMimeTypes = ['image/png'];
      const isMultiple = false;
      final provider = dropzoneViewModelProvider(allowedMimeTypes, isMultiple);
      final viewModel = container.read(provider.notifier);

      viewModel.setIsError(true);

      final state = container.read(provider);
      expect(state.isError, true);
    });

    test('pickFile does nothing when already uploading', () async {
      final allowedMimeTypes = ['image/png'];
      const isMultiple = false;
      final provider = dropzoneViewModelProvider(allowedMimeTypes, isMultiple);
      final viewModel = container.read(provider.notifier);
      viewModel.state = viewModel.state.copyWith(isUploading: true);

      await viewModel.pickFile((url, name) {});

      verifyNever(mockFileRepository.pickFiles(any, any));
    });

    test('pickFile uploads files when not uploading', () async {
      final mockFile = MockPlatformFile();
      when(mockFileRepository.pickFiles(any, any))
          .thenAnswer((_) async => [mockFile]);
      when(mockAuthRepository.isLoggedIn).thenReturn(true);
      when(mockAuthRepository.currentUserId).thenReturn('user123');
      when(mockFileRepository.uploadFile(any, any, any, any))
          .thenAnswer((_) async {});

      final allowedMimeTypes = ['image/png'];
      const isMultiple = false;
      final provider = dropzoneViewModelProvider(allowedMimeTypes, isMultiple);
      final viewModel = container.read(provider.notifier);

      await viewModel.pickFile((url, name) {});

      verify(mockFileRepository.pickFiles(['image/png'], false)).called(1);
    });

    test('acceptFile returns early when user not logged in', () async {
      when(mockAuthRepository.isLoggedIn).thenReturn(false);
      when(mockController.getFileData(any))
          .thenAnswer((_) async => Uint8List.fromList([1, 2, 3]));

      final allowedMimeTypes = ['image/png'];
      const isMultiple = false;
      final provider = dropzoneViewModelProvider(allowedMimeTypes, isMultiple);
      final viewModel = container.read(provider.notifier);
      viewModel.setController(mockController);

      await viewModel.acceptFile('event', (url, name) {});

      final state = container.read(provider);
      expect(state.isUploading, false);
      verifyNever(mockController.getFilename(any));
    });

    test('acceptFile uploads file when user logged in', () async {
      when(mockAuthRepository.isLoggedIn).thenReturn(true);
      when(mockAuthRepository.currentUserId).thenReturn('user123');
      when(mockController.getFileData(any))
          .thenAnswer((_) async => Uint8List.fromList([1, 2, 3]));
      when(mockController.getFilename(any)).thenAnswer((_) async => 'test.png');
      when(mockFileRepository.uploadFile(any, any, any, any))
          .thenAnswer((_) async {});

      final allowedMimeTypes = ['image/png'];
      const isMultiple = false;
      final provider = dropzoneViewModelProvider(allowedMimeTypes, isMultiple);
      final viewModel = container.read(provider.notifier);
      viewModel.setController(mockController);

      await viewModel.acceptFile('event', (url, name) {});

      verify(mockController.getFileData('event')).called(1);
      verify(mockController.getFilename('event')).called(1);
      verify(mockFileRepository.uploadFile(
              'test.png', [1, 2, 3], 'user123', any))
          .called(1);
    });

    test('_uploadFile sets error when mime type not allowed', () async {
      when(mockAuthRepository.isLoggedIn).thenReturn(true);
      when(mockAuthRepository.currentUserId).thenReturn('user123');
      when(mockController.getFileData(any))
          .thenAnswer((_) async => Uint8List.fromList([1, 2, 3]));
      when(mockController.getFilename(any)).thenAnswer((_) async => 'test.txt'); // Wrong mime type

      final allowedMimeTypes = ['image/png']; // Only allows PNG, but file is .txt
      const isMultiple = false;
      final provider = dropzoneViewModelProvider(allowedMimeTypes, isMultiple);
      final viewModel = container.read(provider.notifier);
      viewModel.setController(mockController);

      await viewModel.acceptFile('event', (url, name) {});

      final state = container.read(provider);
      expect(state.isError, true);
      expect(state.isUploading, false);
    });

    test('_uploadFile handles exceptions', () async {
      when(mockAuthRepository.isLoggedIn).thenReturn(true);
      when(mockAuthRepository.currentUserId).thenReturn('user123');
      when(mockController.getFileData(any))
          .thenAnswer((_) async => Uint8List.fromList([1, 2, 3]));
      when(mockController.getFilename(any)).thenAnswer((_) async => 'test.png');
      when(mockFileRepository.uploadFile(any, any, any, any))
          .thenThrow(Exception('Upload failed'));

      final allowedMimeTypes = ['image/png'];
      const isMultiple = false;
      final provider = dropzoneViewModelProvider(allowedMimeTypes, isMultiple);
      final viewModel = container.read(provider.notifier);
      viewModel.setController(mockController);

      await viewModel.acceptFile('event', (url, name) {});

      final state = container.read(provider);
      expect(state.isUploading, false);
      expect(state.isError, true);
    });
  });
}

class MockPlatformFile extends Mock implements XFile {
  @override
  String get name => 'test.png';
  
  @override
  Future<Uint8List> readAsBytes() async => Uint8List.fromList([1, 2, 3]);
}
