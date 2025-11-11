// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercises_list_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExercisesListViewModel)
const exercisesListViewModelProvider = ExercisesListViewModelFamily._();

final class ExercisesListViewModelProvider extends $AsyncNotifierProvider<
    ExercisesListViewModel, ExercisesListUiState> {
  const ExercisesListViewModelProvider._(
      {required ExercisesListViewModelFamily super.from,
      required (
        String,
        String,
      )
          super.argument})
      : super(
          retry: null,
          name: r'exercisesListViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$exercisesListViewModelHash();

  @override
  String toString() {
    return r'exercisesListViewModelProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ExercisesListViewModel create() => ExercisesListViewModel();

  @override
  bool operator ==(Object other) {
    return other is ExercisesListViewModelProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exercisesListViewModelHash() =>
    r'd0451e4231d1c2614d97c8d55b51aeb940d02d87';

final class ExercisesListViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
            ExercisesListViewModel,
            AsyncValue<ExercisesListUiState>,
            ExercisesListUiState,
            FutureOr<ExercisesListUiState>,
            (
              String,
              String,
            )> {
  const ExercisesListViewModelFamily._()
      : super(
          retry: null,
          name: r'exercisesListViewModelProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ExercisesListViewModelProvider call(
    String tutorialId,
    String languageCode,
  ) =>
      ExercisesListViewModelProvider._(argument: (
        tutorialId,
        languageCode,
      ), from: this);

  @override
  String toString() => r'exercisesListViewModelProvider';
}

abstract class _$ExercisesListViewModel
    extends $AsyncNotifier<ExercisesListUiState> {
  late final _$args = ref.$arg as (
    String,
    String,
  );
  String get tutorialId => _$args.$1;
  String get languageCode => _$args.$2;

  FutureOr<ExercisesListUiState> build(
    String tutorialId,
    String languageCode,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args.$1,
      _$args.$2,
    );
    final ref = this.ref
        as $Ref<AsyncValue<ExercisesListUiState>, ExercisesListUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<ExercisesListUiState>, ExercisesListUiState>,
        AsyncValue<ExercisesListUiState>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
