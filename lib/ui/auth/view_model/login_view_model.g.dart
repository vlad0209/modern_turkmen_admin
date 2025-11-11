// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoginViewModel)
const loginViewModelProvider = LoginViewModelProvider._();

final class LoginViewModelProvider
    extends $NotifierProvider<LoginViewModel, dynamic> {
  const LoginViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'loginViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$loginViewModelHash();

  @$internal
  @override
  LoginViewModel create() => LoginViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(dynamic value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<dynamic>(value),
    );
  }
}

String _$loginViewModelHash() => r'66c66b8ae89d60c724ea1a46dd30d409c73a4f91';

abstract class _$LoginViewModel extends $Notifier<dynamic> {
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
