// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutorial_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TutorialViewModel)
const tutorialViewModelProvider = TutorialViewModelFamily._();

final class TutorialViewModelProvider
    extends $AsyncNotifierProvider<TutorialViewModel, Tutorial?> {
  const TutorialViewModelProvider._(
      {required TutorialViewModelFamily super.from,
      required String? super.argument})
      : super(
          retry: null,
          name: r'tutorialViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$tutorialViewModelHash();

  @override
  String toString() {
    return r'tutorialViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TutorialViewModel create() => TutorialViewModel();

  @override
  bool operator ==(Object other) {
    return other is TutorialViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tutorialViewModelHash() => r'f1d1cb218a7e43555eb0b435762e2f31890d3700';

final class TutorialViewModelFamily extends $Family
    with
        $ClassFamilyOverride<TutorialViewModel, AsyncValue<Tutorial?>,
            Tutorial?, FutureOr<Tutorial?>, String?> {
  const TutorialViewModelFamily._()
      : super(
          retry: null,
          name: r'tutorialViewModelProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  TutorialViewModelProvider call(
    String? tutorialId,
  ) =>
      TutorialViewModelProvider._(argument: tutorialId, from: this);

  @override
  String toString() => r'tutorialViewModelProvider';
}

abstract class _$TutorialViewModel extends $AsyncNotifier<Tutorial?> {
  late final _$args = ref.$arg as String?;
  String? get tutorialId => _$args;

  FutureOr<Tutorial?> build(
    String? tutorialId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<Tutorial?>, Tutorial?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Tutorial?>, Tutorial?>,
        AsyncValue<Tutorial?>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
