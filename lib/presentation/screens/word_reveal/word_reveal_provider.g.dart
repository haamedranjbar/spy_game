// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_reveal_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WordRevealNotifier)
final wordRevealProvider = WordRevealNotifierProvider._();

final class WordRevealNotifierProvider
    extends $NotifierProvider<WordRevealNotifier, WordRevealUiState> {
  WordRevealNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wordRevealProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wordRevealNotifierHash();

  @$internal
  @override
  WordRevealNotifier create() => WordRevealNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WordRevealUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WordRevealUiState>(value),
    );
  }
}

String _$wordRevealNotifierHash() =>
    r'8ca828245c4d145816d49e51afe622efadc9f7ad';

abstract class _$WordRevealNotifier extends $Notifier<WordRevealUiState> {
  WordRevealUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<WordRevealUiState, WordRevealUiState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WordRevealUiState, WordRevealUiState>,
              WordRevealUiState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
