// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_category_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CustomCategoryNotifier)
final customCategoryProvider = CustomCategoryNotifierProvider._();

final class CustomCategoryNotifierProvider
    extends $NotifierProvider<CustomCategoryNotifier, CustomCategoryState> {
  CustomCategoryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customCategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customCategoryNotifierHash();

  @$internal
  @override
  CustomCategoryNotifier create() => CustomCategoryNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomCategoryState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomCategoryState>(value),
    );
  }
}

String _$customCategoryNotifierHash() =>
    r'e923d058f267b42478604fbe23d790bea0b930f1';

abstract class _$CustomCategoryNotifier extends $Notifier<CustomCategoryState> {
  CustomCategoryState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CustomCategoryState, CustomCategoryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CustomCategoryState, CustomCategoryState>,
              CustomCategoryState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
