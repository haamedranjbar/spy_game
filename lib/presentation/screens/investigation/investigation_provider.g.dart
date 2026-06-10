// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investigation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InvestigationNotifier)
final investigationProvider = InvestigationNotifierProvider._();

final class InvestigationNotifierProvider
    extends $NotifierProvider<InvestigationNotifier, InvestigationUiState> {
  InvestigationNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'investigationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$investigationNotifierHash();

  @$internal
  @override
  InvestigationNotifier create() => InvestigationNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InvestigationUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InvestigationUiState>(value),
    );
  }
}

String _$investigationNotifierHash() =>
    r'd94b39148403ffcae75deb4ad67af0137a7f8e83';

abstract class _$InvestigationNotifier extends $Notifier<InvestigationUiState> {
  InvestigationUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<InvestigationUiState, InvestigationUiState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InvestigationUiState, InvestigationUiState>,
              InvestigationUiState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
