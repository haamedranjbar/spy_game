import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spy_game/data/models/player_role.dart';
import 'package:spy_game/presentation/providers/audio_provider.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';
import 'package:spy_game/presentation/screens/timer/timer_provider.dart';

part 'voting_provider.g.dart';

/// State صفحه پایان بحث — رای شفاهی + افشای نقش‌ها
class VotingUiState {
  const VotingUiState({
    this.rolesRevealed = false,
    this.isRestarting = false,
    this.revealedSecretWord = '',
    this.revealedSpies = const [],
    this.revealedInfiltrators = const [],
  });

  final bool rolesRevealed;
  final bool isRestarting;
  /// اسنپ‌شات کلمه و نقش‌ها — جلوگیری از نمایش کلمه دور بعد روی کارت نتیجه
  final String revealedSecretWord;
  final List<String> revealedSpies;
  final List<String> revealedInfiltrators;

  VotingUiState copyWith({
    bool? rolesRevealed,
    bool? isRestarting,
    String? revealedSecretWord,
    List<String>? revealedSpies,
    List<String>? revealedInfiltrators,
  }) {
    return VotingUiState(
      rolesRevealed: rolesRevealed ?? this.rolesRevealed,
      isRestarting: isRestarting ?? this.isRestarting,
      revealedSecretWord: revealedSecretWord ?? this.revealedSecretWord,
      revealedSpies: revealedSpies ?? this.revealedSpies,
      revealedInfiltrators: revealedInfiltrators ?? this.revealedInfiltrators,
    );
  }
}

@riverpod
class VotingNotifier extends _$VotingNotifier {
  @override
  VotingUiState build() => const VotingUiState();

  /// اتمام بازی — افشای جاسوس‌ها و نفوذی‌ها
  void endGameAndReveal() {
    if (!ref.mounted) return;
    final game = ref.read(gameProvider);

    ref.read(audioServiceProvider).playTimerEnd();
    ref.read(audioServiceProvider).vibrateHeavy();
    ref.read(gameProvider.notifier).endGameReveal();

    // ذخیره نتیجه این دور — مستقل از state بازی دور بعد
    state = state.copyWith(
      rolesRevealed: true,
      revealedSecretWord: game.secretWord,
      revealedSpies: game.roles
          .where((role) => role.role == GameRole.spy)
          .map((role) => role.playerName)
          .toList(),
      revealedInfiltrators: game.roles
          .where((role) => role.role == GameRole.infiltrator)
          .map((role) => role.playerName)
          .toList(),
    );
  }

  /// شروع دوباره — بدون بازگشت به تنظیمات
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

  /// پایان و بازگشت به خانه
  void endGame() {
    if (!ref.mounted) return;
    ref.read(gameProvider.notifier).resetGame();
  }
}
