// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_reveal_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// بارگذاری دسته کلمه مخفی برای نمایش به جاسوس

@ProviderFor(secretWordCategory)
final secretWordCategoryProvider = SecretWordCategoryProvider._();

/// بارگذاری دسته کلمه مخفی برای نمایش به جاسوس

final class SecretWordCategoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<WordCategory?>,
          WordCategory?,
          FutureOr<WordCategory?>
        >
    with $FutureModifier<WordCategory?>, $FutureProvider<WordCategory?> {
  /// بارگذاری دسته کلمه مخفی برای نمایش به جاسوس
  SecretWordCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secretWordCategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secretWordCategoryHash();

  @$internal
  @override
  $FutureProviderElement<WordCategory?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WordCategory?> create(Ref ref) {
    return secretWordCategory(ref);
  }
}

String _$secretWordCategoryHash() =>
    r'2086de8d53c2fe925a2679ea37ad7073f6c4841c';

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
    r'a6f59604cc1b210eb0d3f50bcbca9719716bdece';

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
