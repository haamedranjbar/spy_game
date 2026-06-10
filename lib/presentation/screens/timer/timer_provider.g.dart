// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TimerNotifier)
final timerProvider = TimerNotifierProvider._();

final class TimerNotifierProvider
    extends $NotifierProvider<TimerNotifier, TimerScreenState> {
  TimerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timerNotifierHash();

  @$internal
  @override
  TimerNotifier create() => TimerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimerScreenState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimerScreenState>(value),
    );
  }
}

String _$timerNotifierHash() => r'982bb1cd5c192c2c957316ec474e5014bb01e91f';

abstract class _$TimerNotifier extends $Notifier<TimerScreenState> {
  TimerScreenState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TimerScreenState, TimerScreenState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TimerScreenState, TimerScreenState>,
              TimerScreenState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
