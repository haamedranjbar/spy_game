import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';
import 'package:spy_game/presentation/screens/timer/timer_provider.dart';

part 'result_provider.g.dart';

/// State محلی صفحه نتیجه
class ResultUiState {
  const ResultUiState({
    this.isLoadingNext = false,
    this.isRestarting = false,
  });

  final bool isLoadingNext;
  final bool isRestarting;

  ResultUiState copyWith({
    bool? isLoadingNext,
    bool? isRestarting,
  }) {
    return ResultUiState(
      isLoadingNext: isLoadingNext ?? this.isLoadingNext,
      isRestarting: isRestarting ?? this.isRestarting,
    );
  }
}

@riverpod
class ResultNotifier extends _$ResultNotifier {
  @override
  ResultUiState build() => const ResultUiState();

  /// شروع دور بعدی
  Future<bool> continueGame() async {
    state = state.copyWith(isLoadingNext: true);
    final started = await ref.read(gameProvider.notifier).startNextRound();
    if (ref.mounted) {
      state = state.copyWith(isLoadingNext: false);
    }
    return started;
  }

  /// شروع دوباره — همان بازیکنان و تنظیمات
  Future<bool> playAgain() async {
    if (!ref.mounted) return false;
    state = state.copyWith(isRestarting: true);

    final started = await ref.read(gameProvider.notifier).playAgain();

    if (ref.mounted) {
      ref.invalidate(timerProvider);
      state = state.copyWith(isRestarting: false);
    }
    return started;
  }

  /// پایان بازی و بازگشت به خانه
  void endGame() {
    ref.read(gameProvider.notifier).resetGame();
  }
}
