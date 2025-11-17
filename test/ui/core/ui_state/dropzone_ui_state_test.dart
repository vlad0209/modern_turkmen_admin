import 'package:flutter_test/flutter_test.dart';
import 'package:modern_turkmen_admin/ui/core/ui_state/dropzone_ui_state.dart';

void main() {
  group('DropzoneUiState', () {
    test('should create instance with default values', () {
      final state = DropzoneUiState();
      
      expect(state.isUploading, false);
      expect(state.isHighlighted, false);
      expect(state.isError, false);
    });

    test('should create instance with custom values', () {
      final state = DropzoneUiState(
        isUploading: true,
        isHighlighted: true,
        isError: true,
      );
      
      expect(state.isUploading, true);
      expect(state.isHighlighted, true);
      expect(state.isError, true);
    });

    test('copyWith should return new instance with updated values', () {
      final originalState = DropzoneUiState(isUploading: true);
      final newState = originalState.copyWith(isHighlighted: true);
      
      expect(newState.isUploading, true);
      expect(newState.isHighlighted, true);
      expect(newState.isError, false);
    });

    test('copyWith should preserve original values when null is passed', () {
      final originalState = DropzoneUiState(
        isUploading: true,
        isHighlighted: true,
        isError: true,
      );
      final newState = originalState.copyWith();
      
      expect(newState.isUploading, true);
      expect(newState.isHighlighted, true);
      expect(newState.isError, true);
    });

    test('copyWith should update only specified values', () {
      final originalState = DropzoneUiState(
        isUploading: true,
        isHighlighted: true,
        isError: true,
      );
      final newState = originalState.copyWith(isError: false);
      
      expect(newState.isUploading, true);
      expect(newState.isHighlighted, true);
      expect(newState.isError, false);
    });
  });
}