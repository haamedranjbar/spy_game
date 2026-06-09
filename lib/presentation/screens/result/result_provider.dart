import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';

part 'result_provider.g.dart';

/// State محلی صفحه نتیجه
class ResultUiState {
  const ResultUiState({
    this.isLoadingNext = false,
  });

  final bool isLoadingNext;

  ResultUiState copyWith({bool? isLoadingNext}) {
    return ResultUiState(isLoadingNext: isLoadingNext ?? this.isLoadingNext);
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

  /// پایان بازی و بازگشت به خانه
  void endGame() {
    ref.read(gameProvider.notifier).resetGame();
  }
}
