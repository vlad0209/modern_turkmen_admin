import 'package:flutter/foundation.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:mime/mime.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../config/dependencies.dart';
import '../../../data/repositories/auth/auth_repository.dart';
import '../../../data/repositories/file/file_repository.dart';
import '../ui_state/dropzone_ui_state.dart';

part 'dropzone_view_model.g.dart';

@riverpod
class DropzoneViewModel extends _$DropzoneViewModel {
  late FileRepository _fileRepository;
  late DropzoneViewController _controller;
  late AuthRepository _authRepository;

  @override
  DropzoneUiState build(List<String> mime, bool multiple) {
    _fileRepository = ref.watch(fileRepositoryProvider);
    _authRepository = ref.watch(authRepositoryProvider);
    return DropzoneUiState();
  }

  Future<void> pickFile(Function(String, String?) onSuccess) async {
    if (!state.isUploading) {
      final files = await _fileRepository.pickFiles(mime, multiple);
      if (files != null) {
        state = state.copyWith(isUploading: true, isHighlighted: false, isError: false);
        
        for (var file in files) {
          await _uploadFile(file.name, await file.readAsBytes(), onSuccess);
        }
      }
    }
  }

  void setController(DropzoneViewController controller) {
    _controller = controller;
  }

  void setIsHighlighted(bool isHighlighted) {
    state = state.copyWith(isHighlighted: isHighlighted);
  }

  void setIsError(bool isError) {
    state = state.copyWith(isError: isError);
  }

  Future<void> acceptFile(dynamic event, Function(String, String?) onSuccess) async {
    state = state.copyWith(isUploading: true, isHighlighted: false, isError: false);
    final bytes = await _controller.getFileData(event);
    
    if (!_authRepository.isLoggedIn) {
      if (kDebugMode) {
        print('User not logged in');
      }
      state = state.copyWith(isUploading: false);
      
      return;
    }
    final fileName = await _controller.getFilename(event);

    // Firebase upload
   await _uploadFile(fileName, bytes, onSuccess);
  }

  Future<void> _uploadFile(localFileName, bytes, Function(String, String?) onSuccess) async {
    try {
      // Check file type
    final mimeType = lookupMimeType(localFileName);
    print('Detected mime type: $mimeType');
    if (!mime.contains(mimeType)) {
      state = state.copyWith(isUploading: false, isError: true);
    } else {
      await _fileRepository.uploadFile(localFileName, bytes, _authRepository.currentUserId!, onSuccess);
      state = state.copyWith(isUploading: false);
    }
    } catch(e) {
      state = state.copyWith(isUploading: false, isError: true);
      if (kDebugMode) {
          print(e);
        }
    }
    
  }
}