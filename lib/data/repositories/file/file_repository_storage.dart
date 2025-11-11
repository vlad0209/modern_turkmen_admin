import 'package:image_picker/image_picker.dart';

import '../../services/firebase_storage_service.dart';
import '../../services/image_picker_service.dart';
import 'file_repository.dart';

class FileRepositoryStorage implements FileRepository {
  final FirebaseStorageService _firebaseStorageService;
  final ImagePickerService _imagePickerService;

  FileRepositoryStorage(
      {required FirebaseStorageService firebaseStorageService,
      required ImagePickerService imagePickerService})
      : _firebaseStorageService = firebaseStorageService,
        _imagePickerService = imagePickerService;

  @override
  Future<void> uploadFile(localFileName, bytes, String userId,
      Function(String, String?) onFileUploaded) async {
    await _firebaseStorageService.uploadFile(
        localFileName, bytes, userId, onFileUploaded);
  }

  @override
  Future<List<XFile>?> pickFiles(List<String> mime, bool multiple) async {
    return await _imagePickerService.pickFile(mime, multiple);
  }
}