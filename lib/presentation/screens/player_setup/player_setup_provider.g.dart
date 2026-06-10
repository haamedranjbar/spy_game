// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_setup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlayerSetupNotifier)
final playerSetupProvider = PlayerSetupNotifierProvider._();

final class PlayerSetupNotifierProvider
    extends $NotifierProvider<PlayerSetupNotifier, PlayerSetupState> {
  PlayerSetupNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerSetupProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerSetupNotifierHash();

  @$internal
  @override
  PlayerSetupNotifier create() => PlayerSetupNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlayerSetupState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlayerSetupState>(value),
    );
  }
}

String _$playerSetupNotifierHash() =>
    r'edf745b5e339661f9455957d905eceb0f1a2fa60';

abstract class _$PlayerSetupNotifier extends $Notifier<PlayerSetupState> {
  PlayerSetupState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PlayerSetupState, PlayerSetupState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlayerSetupState, PlayerSetupState>,
              PlayerSetupState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider گروه‌های بازیکن برای selector

@ProviderFor(savedPlayerGroups)
final savedPlayerGroupsProvider = SavedPlayerGroupsProvider._();

/// Provider گروه‌های بازیکن برای selector

final class SavedPlayerGroupsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PlayerGroup>>,
          List<PlayerGroup>,
          FutureOr<List<PlayerGroup>>
        >
    with
        $FutureModifier<List<PlayerGroup>>,
        $FutureProvider<List<PlayerGroup>> {
  /// Provider گروه‌های بازیکن برای selector
  SavedPlayerGroupsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedPlayerGroupsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedPlayerGroupsHash();

  @$internal
  @override
  $FutureProviderElement<List<PlayerGroup>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PlayerGroup>> create(Ref ref) {
    return savedPlayerGroups(ref);
  }
}

String _$savedPlayerGroupsHash() => r'cbd696b6030f1806cdb33b9c00ef3433c7c1dd6f';
