// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutorials_list_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TutorialsListViewModel)
const tutorialsListViewModelProvider = TutorialsListViewModelProvider._();

final class TutorialsListViewModelProvider
    extends $StreamNotifierProvider<TutorialsListViewModel, List<Tutorial>> {
  const TutorialsListViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'tutorialsListViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$tutorialsListViewModelHash();

  @$internal
  @override
  TutorialsListViewModel create() => TutorialsListViewModel();
}

String _$tutorialsListViewModelHash() =>
    r'd4a9a2977105ce11adaffd382f774e12f594d3fa';

abstract class _$TutorialsListViewModel
    extends $StreamNotifier<List<Tutorial>> {
  Stream<List<Tutorial>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Tutorial>>, List<Tutorial>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Tutorial>>, List<Tutorial>>,
        AsyncValue<List<Tutorial>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
