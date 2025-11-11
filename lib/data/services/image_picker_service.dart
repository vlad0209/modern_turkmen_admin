import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  Future<List<XFile>?> pickFile(List<String> mime, bool multiple) async {
    final ImagePicker picker = ImagePicker();
    final canBeImage = mime.any((type) => type.contains('image'));
    final canBeVideo = mime.any((type) => type.contains('video'));

    List<XFile>? files;

    if (canBeImage && canBeVideo) {
      if (multiple) {
        files = await picker.pickMultipleMedia();
      } else {
        final file = await picker.pickMedia();
        if (file != null) {
          files = [file];
        }
      }
    } else if (canBeImage) {
      if (multiple) {
        files = await picker.pickMultiImage();
      } else {
        final file = await picker.pickImage(source: ImageSource.gallery);
        if (file != null) {
          files = [file];
        }
      }
    } else if (canBeVideo) {
      final file = await picker.pickVideo(source: ImageSource.gallery);
      if (file != null) {
        files = [file];
      }
    }
    return files;
  }
}