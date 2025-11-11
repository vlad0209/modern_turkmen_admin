// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_layout_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MainLayoutViewModel)
const mainLayoutViewModelProvider = MainLayoutViewModelProvider._();

final class MainLayoutViewModelProvider
    extends $NotifierProvider<MainLayoutViewModel, dynamic> {
  const MainLayoutViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'mainLayoutViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$mainLayoutViewModelHash();

  @$internal
  @override
  MainLayoutViewModel create() => MainLayoutViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(dynamic value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<dynamic>(value),
    );
  }
}

String _$mainLayoutViewModelHash() =>
    r'8fef50a5df5f3693998fc57ecd020233dbb1812e';

abstract class _$MainLayoutViewModel extends $Notifier<dynamic> {
  dynamic build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<dynamic, dynamic>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<dynamic, dynamic>, dynamic, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
