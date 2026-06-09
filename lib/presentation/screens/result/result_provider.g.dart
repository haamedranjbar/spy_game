// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ResultNotifier)
final resultProvider = ResultNotifierProvider._();

final class ResultNotifierProvider
    extends $NotifierProvider<ResultNotifier, ResultUiState> {
  ResultNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resultProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resultNotifierHash();

  @$internal
  @override
  ResultNotifier create() => ResultNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResultUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResultUiState>(value),
    );
  }
}

String _$resultNotifierHash() => r'71134400a4460b4d210d14ac8a397c27d794e155';

abstract class _$ResultNotifier extends $Notifier<ResultUiState> {
  ResultUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ResultUiState, ResultUiState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ResultUiState, ResultUiState>,
              ResultUiState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
