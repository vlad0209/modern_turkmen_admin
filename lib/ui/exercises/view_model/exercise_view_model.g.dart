// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExerciseViewModel)
const exerciseViewModelProvider = ExerciseViewModelFamily._();

final class ExerciseViewModelProvider
    extends $AsyncNotifierProvider<ExerciseViewModel, ExerciseUiState> {
  const ExerciseViewModelProvider._(
      {required ExerciseViewModelFamily super.from,
      required (
        String,
        String,
        String?,
      )
          super.argument})
      : super(
          retry: null,
          name: r'exerciseViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$exerciseViewModelHash();

  @override
  String toString() {
    return r'exerciseViewModelProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ExerciseViewModel create() => ExerciseViewModel();

  @override
  bool operator ==(Object other) {
    return other is ExerciseViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exerciseViewModelHash() => r'c42a24227916b56fe2977a3c5603a982c8aa7381';

final class ExerciseViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
            ExerciseViewModel,
            AsyncValue<ExerciseUiState>,
            ExerciseUiState,
            FutureOr<ExerciseUiState>,
            (
              String,
              String,
              String?,
            )> {
  const ExerciseViewModelFamily._()
      : super(
          retry: null,
          name: r'exerciseViewModelProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ExerciseViewModelProvider call(
    String tutorialId,
    String languageCode,
    String? exerciseId,
  ) =>
      ExerciseViewModelProvider._(argument: (
        tutorialId,
        languageCode,
        exerciseId,
      ), from: this);

  @override
  String toString() => r'exerciseViewModelProvider';
}

abstract class _$ExerciseViewModel extends $AsyncNotifier<ExerciseUiState> {
  late final _$args = ref.$arg as (
    String,
    String,
    String?,
  );
  String get tutorialId => _$args.$1;
  String get languageCode => _$args.$2;
  String? get exerciseId => _$args.$3;

  FutureOr<ExerciseUiState> build(
    String tutorialId,
    String languageCode,
    String? exerciseId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args.$1,
      _$args.$2,
      _$args.$3,
    );
    final ref = this.ref as $Ref<AsyncValue<ExerciseUiState>, ExerciseUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<ExerciseUiState>, ExerciseUiState>,
        AsyncValue<ExerciseUiState>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
