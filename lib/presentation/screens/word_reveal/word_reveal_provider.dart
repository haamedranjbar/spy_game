import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spy_game/presentation/providers/audio_provider.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';

part 'word_reveal_provider.g.dart';

/// State محلی صفحه نمایش نقش — فقط برای UI
class WordRevealUiState {
  const WordRevealUiState({
    this.isPassingPhone = false,
  });

  final bool isPassingPhone;

  WordRevealUiState copyWith({bool? isPassingPhone}) {
    return WordRevealUiState(
      isPassingPhone: isPassingPhone ?? this.isPassingPhone,
    );
  }
}

@riverpod
class WordRevealNotifier extends _$WordRevealNotifier {
  @override
  WordRevealUiState build() => const WordRevealUiState();

  /// نمایش نقش بازیکن فعلی
  void reveal() {
    ref.read(audioServiceProvider).playReveal();
    ref.read(audioServiceProvider).vibrateLight();
    ref.read(gameProvider.notifier).revealCurrentRole();
  }

  /// رفتن به بازیکن بعدی
  void nextPlayer() {
    final game = ref.read(gameProvider);
    if (!game.isCurrentRevealed) return;

    state = state.copyWith(isPassingPhone: true);
    ref.read(gameProvider.notifier).advanceReveal();

    final updated = ref.read(gameProvider);
    if (updated.phase == GamePhase.timer) {
      state = const WordRevealUiState();
    } else {
      state = const WordRevealUiState(isPassingPhone: false);
    }
  }
}
