import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spy_game/core/constants/game_config.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';

part 'game_config_provider.g.dart';

/// State صفحه تنظیمات دور بازی
class GameConfigState {
  const GameConfigState({
    this.isStarting = false,
  });

  final bool isStarting;

  GameConfigState copyWith({bool? isStarting}) {
    return GameConfigState(isStarting: isStarting ?? this.isStarting);
  }
}

@riverpod
class GameConfigNotifier extends _$GameConfigNotifier {
  @override
  GameConfigState build() => const GameConfigState();

  int get playerCount => ref.read(gameProvider).playerNames.length;

  int get spyCount => ref.read(gameProvider).spyCount;

  int get timerSeconds => ref.read(gameProvider).timerSeconds;

  int get maxSpies {
    final count = playerCount;
    return count > 1 ? count - 1 : GameConfig.minSpies;
  }

  void incrementSpyCount() {
    ref.read(gameProvider.notifier).setSpyCount(spyCount + 1);
  }

  void decrementSpyCount() {
    ref.read(gameProvider.notifier).setSpyCount(spyCount - 1);
  }

  void incrementTimer() {
    final next = timerSeconds + 60;
    ref.read(gameProvider.notifier).setTimerSeconds(next);
  }

  void decrementTimer() {
    final next = timerSeconds - 60;
    ref.read(gameProvider.notifier).setTimerSeconds(next);
  }

  void setShowCategoryForSpy(bool value) {
    ref.read(gameProvider.notifier).setShowCategoryForSpy(value);
  }

  void setSpyHintEnabled(bool value) {
    ref.read(gameProvider.notifier).setSpyHintEnabled(value);
  }

  void setSpiesKnowEachOther(bool value) {
    ref.read(gameProvider.notifier).setSpiesKnowEachOther(value);
  }

  /// شروع بازی با تنظیمات فعلی
  Future<bool> startGame() async {
    state = state.copyWith(isStarting: true);
    final started = await ref.read(gameProvider.notifier).startGame();
    if (ref.mounted) {
      state = state.copyWith(isStarting: false);
    }
    return started;
  }
}
