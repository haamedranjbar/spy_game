// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GameConfigNotifier)
final gameConfigProvider = GameConfigNotifierProvider._();

final class GameConfigNotifierProvider
    extends $NotifierProvider<GameConfigNotifier, GameConfigState> {
  GameConfigNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameConfigProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameConfigNotifierHash();

  @$internal
  @override
  GameConfigNotifier create() => GameConfigNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameConfigState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameConfigState>(value),
    );
  }
}

String _$gameConfigNotifierHash() =>
    r'3cf4667b734c5da40e8d9d55fa43e6e001ca0ca8';

abstract class _$GameConfigNotifier extends $Notifier<GameConfigState> {
  GameConfigState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<GameConfigState, GameConfigState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GameConfigState, GameConfigState>,
              GameConfigState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
