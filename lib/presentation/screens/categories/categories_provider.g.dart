// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CategoriesNotifier)
final categoriesProvider = CategoriesNotifierProvider._();

final class CategoriesNotifierProvider
    extends $NotifierProvider<CategoriesNotifier, CategoriesUiState> {
  CategoriesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesNotifierHash();

  @$internal
  @override
  CategoriesNotifier create() => CategoriesNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoriesUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoriesUiState>(value),
    );
  }
}

String _$categoriesNotifierHash() =>
    r'6a196e949db46ca9c8618a487e4a10917f89ad51';

abstract class _$CategoriesNotifier extends $Notifier<CategoriesUiState> {
  CategoriesUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CategoriesUiState, CategoriesUiState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CategoriesUiState, CategoriesUiState>,
              CategoriesUiState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
