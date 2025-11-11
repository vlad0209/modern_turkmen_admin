import 'package:image_picker/image_picker.dart';

abstract class FileRepository {
  Future<void> uploadFile(localFileName, bytes, String userId, Function(String, String?) onFileUploaded);

  Future<List<XFile>?> pickFiles(List<String> mime, bool multiple);
}