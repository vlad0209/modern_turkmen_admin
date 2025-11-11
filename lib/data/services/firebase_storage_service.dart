import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage;
  FirebaseStorageService(this._storage);

  Future<void> uploadFile(String localFileName, Uint8List bytes, String userId,
      Function(String, String?) onFileUploaded) async {
    // Check file type
    final mimeType = lookupMimeType(localFileName);

    final ext = localFileName.split('.').last;
    var time = DateTime.now().millisecondsSinceEpoch.toString();
    final ref =
        _storage.ref().child('uploads').child(userId).child('$time.$ext');
    final uploadTask =
        ref.putData(bytes, SettableMetadata(contentType: mimeType));

    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    final thumbnailUrl = mimeType?.contains('image') == true
          ? downloadUrl.replaceFirst(time, 'thumb_$time')
          : null;

    if (thumbnailUrl != null) {
      while (await fileExists(_storage
              .ref()
              .child('uploads')
              .child(userId)
              .child('thumb_$time.$ext')
              .fullPath) ==
          false) {}
    }

    onFileUploaded(downloadUrl, thumbnailUrl);
  }

  Future<bool> fileExists(String file) async {
    var parts = file.split('/');
    var path = parts.sublist(0, parts.length - 1).join('/');
    var listResult = await _storage.ref().child(path).list();
    return listResult.items.any((element) => element.fullPath == file);
  }
}