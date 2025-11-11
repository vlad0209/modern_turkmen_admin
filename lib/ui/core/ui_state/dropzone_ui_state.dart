class DropzoneUiState {
  final bool isUploading;
  final bool isHighlighted;
  final bool isError;

  DropzoneUiState({this.isUploading = false, this.isHighlighted = false, this.isError = false});

  DropzoneUiState copyWith({bool? isUploading, bool? isHighlighted, bool? isError}) {
    return DropzoneUiState(
      isUploading: isUploading ?? this.isUploading,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      isError: isError ?? this.isError,
    );
  }
}