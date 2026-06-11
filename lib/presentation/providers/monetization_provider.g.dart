// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monetization_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MonetizationNotifier)
final monetizationProvider = MonetizationNotifierProvider._();

final class MonetizationNotifierProvider
    extends $NotifierProvider<MonetizationNotifier, MonetizationState> {
  MonetizationNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monetizationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monetizationNotifierHash();

  @$internal
  @override
  MonetizationNotifier create() => MonetizationNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MonetizationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MonetizationState>(value),
    );
  }
}

String _$monetizationNotifierHash() =>
    r'0366050c606e878b6000aefa5403b853dc90a71b';

abstract class _$MonetizationNotifier extends $Notifier<MonetizationState> {
  MonetizationState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MonetizationState, MonetizationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MonetizationState, MonetizationState>,
              MonetizationState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
