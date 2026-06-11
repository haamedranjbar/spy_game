// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iap_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IapNotifier)
final iapProvider = IapNotifierProvider._();

final class IapNotifierProvider
    extends $NotifierProvider<IapNotifier, IapUiState> {
  IapNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'iapProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$iapNotifierHash();

  @$internal
  @override
  IapNotifier create() => IapNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IapUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IapUiState>(value),
    );
  }
}

String _$iapNotifierHash() => r'063dbfb26d554d93139c94d820eb8537ff5a3f6c';

abstract class _$IapNotifier extends $Notifier<IapUiState> {
  IapUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<IapUiState, IapUiState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<IapUiState, IapUiState>,
              IapUiState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
