import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';

part 'timer_provider.g.dart';

/// State تایمر بحث
class TimerScreenState {
  const TimerScreenState({
    this.remainingSeconds = 0,
    this.totalSeconds = 0,
    this.isRunning = false,
    this.isStarted = false,
  });

  final int remainingSeconds;
  final int totalSeconds;
  final bool isRunning;
  final bool isStarted;

  TimerScreenState copyWith({
    int? remainingSeconds,
    int? totalSeconds,
    bool? isRunning,
    bool? isStarted,
  }) {
    return TimerScreenState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      isRunning: isRunning ?? this.isRunning,
      isStarted: isStarted ?? this.isStarted,
    );
  }
}

@riverpod
class TimerNotifier extends _$TimerNotifier {
  Timer? _timer;

  @override
  TimerScreenState build() {
    ref.onDispose(_cancelTimer);
    return const TimerScreenState();
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// شروع شمارش معکوس — یک بار per ورود به صفحه
  void startIfNeeded(int seconds) {
    if (state.isStarted) return;

    _cancelTimer();
    state = TimerScreenState(
      remainingSeconds: seconds,
      totalSeconds: seconds,
      isRunning: true,
      isStarted: true,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remainingSeconds <= 1) {
        _finish();
        return;
      }
      state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
    });
  }

  /// پایان زودهنگام تایمر
  void endEarly() {
    if (!state.isStarted) return;
    _finish();
  }

  void _finish() {
    _cancelTimer();
    state = state.copyWith(remainingSeconds: 0, isRunning: false);
    ref.read(gameProvider.notifier).finishTimer();
  }
}
