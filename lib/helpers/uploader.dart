import 'dart:html' as html;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';

import '../controllers/file_dropzone_controller.dart';

class Uploader {
  static Future uploadFile(
      dynamic file,
      FileDropzoneController dropzoneController,
      Function onSuccess
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

    final imageRef = storageRef.child(file.name.replaceFirst(
        extension, '${Timestamp.now().millisecondsSinceEpoch}.$extension')
    );

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


    imageRef.putData(imageData!, SettableMetadata(contentType: mimeType))
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
            onSuccess(await taskSnapshot.ref.getDownloadURL());
          });

          break;
      }
    });

  }
}