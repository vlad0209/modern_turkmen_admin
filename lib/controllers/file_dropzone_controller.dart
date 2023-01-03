import 'package:modern_turkmen_admin/widgets/file_dropzone.dart';
import 'package:flutter/cupertino.dart';

class FileDropzoneController extends ChangeNotifier {
  double? _progress = 0;
  String? filename = '';
  String? _uploadStatus = 'idle';
  Function? onStatusChanged;
  FileDropzone? widget;


  void reset() {
    _progress = 0;
    filename = '';
    _uploadStatus = 'idle';
  }

  @override
  void dispose() {
    filename = null;
    _uploadStatus = null;
    onStatusChanged = null;
    _progress = null;
    super.dispose();
  }

  double get progress => _progress!;
  set progress(double value) {
    _progress = value;
    notifyListeners();
  }

  String get uploadStatus => _uploadStatus!;
  set uploadStatus(String value) {
    bool changed = false;
    if(_uploadStatus != value) {
      changed = true;
    }
    _uploadStatus = value;

    notifyListeners();
    if(changed) {
      onStatusChanged!();
    }
  }


}