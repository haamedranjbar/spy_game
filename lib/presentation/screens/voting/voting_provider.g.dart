// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voting_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VotingNotifier)
final votingProvider = VotingNotifierProvider._();

final class VotingNotifierProvider
    extends $NotifierProvider<VotingNotifier, VotingUiState> {
  VotingNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'votingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$votingNotifierHash();

  @$internal
  @override
  VotingNotifier create() => VotingNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VotingUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VotingUiState>(value),
    );
  }
}

String _$votingNotifierHash() => r'024e319b1fb2bd0e113bb6a7b3471e657d157355';

abstract class _$VotingNotifier extends $Notifier<VotingUiState> {
  VotingUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<VotingUiState, VotingUiState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VotingUiState, VotingUiState>,
              VotingUiState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
