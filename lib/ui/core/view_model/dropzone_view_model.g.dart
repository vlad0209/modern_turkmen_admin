// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dropzone_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DropzoneViewModel)
const dropzoneViewModelProvider = DropzoneViewModelFamily._();

final class DropzoneViewModelProvider
    extends $NotifierProvider<DropzoneViewModel, DropzoneUiState> {
  const DropzoneViewModelProvider._(
      {required DropzoneViewModelFamily super.from,
      required (
        List<String>,
        bool,
      )
          super.argument})
      : super(
          retry: null,
          name: r'dropzoneViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dropzoneViewModelHash();

  @override
  String toString() {
    return r'dropzoneViewModelProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  DropzoneViewModel create() => DropzoneViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DropzoneUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DropzoneUiState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DropzoneViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dropzoneViewModelHash() => r'657b8097945dc76c1b9a82b9bf334bd5c5e97e05';

final class DropzoneViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
            DropzoneViewModel,
            DropzoneUiState,
            DropzoneUiState,
            DropzoneUiState,
            (
              List<String>,
              bool,
            )> {
  const DropzoneViewModelFamily._()
      : super(
          retry: null,
          name: r'dropzoneViewModelProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  DropzoneViewModelProvider call(
    List<String> mime,
    bool multiple,
  ) =>
      DropzoneViewModelProvider._(argument: (
        mime,
        multiple,
      ), from: this);

  @override
  String toString() => r'dropzoneViewModelProvider';
}

abstract class _$DropzoneViewModel extends $Notifier<DropzoneUiState> {
  late final _$args = ref.$arg as (
    List<String>,
    bool,
  );
  List<String> get mime => _$args.$1;
  bool get multiple => _$args.$2;

  DropzoneUiState build(
    List<String> mime,
    bool multiple,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args.$1,
      _$args.$2,
    );
    final ref = this.ref as $Ref<DropzoneUiState, DropzoneUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<DropzoneUiState, DropzoneUiState>,
        DropzoneUiState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
