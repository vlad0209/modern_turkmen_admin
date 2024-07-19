import 'package:universal_html/html.dart' as html;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';

import '../controllers/file_dropzone_controller.dart';

class Uploader {
  static Future uploadFile(
      dynamic file,
      FileDropzoneController dropzoneController,
      void Function(Reference) onSuccess,
      {String filename = ''}
      ) async {
    String? mimeType;
    if(file is html.File) {
      mimeType = file.type;
    }
    if(file is PlatformFile) {
      mimeType = lookupMimeType(file.name);
    }


    if(!mimeType!.contains(dropzoneController.widget!.fileType)) {
      dropzoneController.uploadStatus = 'not_valid';
      Future.delayed(const Duration(seconds: 2), () {
        dropzoneController.uploadStatus = 'idle';
      });
      return null;
    }
    dropzoneController.filename = file.name;
    dropzoneController.uploadStatus = 'running';
    final storageRef = FirebaseStorage.instance.ref();
    String extension = file.name.substring(file.name.lastIndexOf('.'));

    final fileRef = storageRef.child('${filename.isNotEmpty ? filename : file
        .name.toString().replaceFirst(extension, '')}$extension');

    Uint8List? imageData;
    if(file is html.File) {
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      await reader.onLoad.first;

      imageData = reader.result as Uint8List;
    }
    if(file is PlatformFile) {
      imageData = file.bytes;
    }


    fileRef.putData(imageData!, SettableMetadata(contentType: mimeType))
        .snapshotEvents.listen((taskSnapshot) {
      switch(taskSnapshot.state) {
        case TaskState.running:
          dropzoneController.progress = 100.0 * (taskSnapshot.bytesTransferred /
              taskSnapshot.totalBytes);
          break;
        case TaskState.success:
          dropzoneController.progress = 100;
          Future.delayed(const Duration(seconds: 1), () async {
            dropzoneController.uploadStatus = 'success';
            onSuccess(taskSnapshot.ref);
          });

          break;
        default:
      }
    });

  }
}