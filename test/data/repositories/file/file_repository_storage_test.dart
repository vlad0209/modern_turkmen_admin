import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:modern_turkmen_admin/data/repositories/file/file_repository_storage.dart';
import 'package:modern_turkmen_admin/data/services/firebase_storage_service.dart';
import 'package:modern_turkmen_admin/data/services/image_picker_service.dart';

@GenerateMocks([FirebaseStorageService, ImagePickerService])
import 'file_repository_storage_test.mocks.dart';

void main() {
  late FileRepositoryStorage fileRepository;
  late MockFirebaseStorageService mockFirebaseStorageService;
  late MockImagePickerService mockImagePickerService;

  setUp(() {
    mockFirebaseStorageService = MockFirebaseStorageService();
    mockImagePickerService = MockImagePickerService();
    fileRepository = FileRepositoryStorage(
      firebaseStorageService: mockFirebaseStorageService,
      imagePickerService: mockImagePickerService,
    );
  });

  group('FileRepositoryStorage', () {
    test('uploadFile calls FirebaseStorageService.uploadFile with correct parameters', () async {
      // Arrange
      const localFileName = 'test.jpg';
      final bytes = Uint8List.fromList([1, 2, 3]);
      const userId = 'user123';
      void onFileUploaded(String url, String? error) {}

      when(mockFirebaseStorageService.uploadFile(any, any, any, any))
          .thenAnswer((_) async => {});

      // Act
      await fileRepository.uploadFile(localFileName, bytes, userId, onFileUploaded);

      // Assert
      verify(mockFirebaseStorageService.uploadFile(
        localFileName,
        bytes,
        userId,
        onFileUploaded,
      )).called(1);
    });

    test('pickFiles calls ImagePickerService.pickFile with correct parameters', () async {
      // Arrange
      final mime = ['image/jpeg', 'image/png'];
      const multiple = true;
      final expectedFiles = [XFile('path1'), XFile('path2')];

      when(mockImagePickerService.pickFile(any, any))
          .thenAnswer((_) async => expectedFiles);

      // Act
      final result = await fileRepository.pickFiles(mime, multiple);

      // Assert
      verify(mockImagePickerService.pickFile(mime, multiple)).called(1);
      expect(result, equals(expectedFiles));
    });

    test('pickFiles returns null when ImagePickerService returns null', () async {
      // Arrange
      final mime = ['image/jpeg'];
      const multiple = false;

      when(mockImagePickerService.pickFile(any, any))
          .thenAnswer((_) async => null);

      // Act
      final result = await fileRepository.pickFiles(mime, multiple);

      // Assert
      verify(mockImagePickerService.pickFile(mime, multiple)).called(1);
      expect(result, isNull);
    });
  });
}