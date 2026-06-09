import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spy_game/data/models/word_category.dart';
import 'package:spy_game/presentation/providers/audio_provider.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';
import 'package:spy_game/presentation/providers/isar_provider.dart';

part 'word_reveal_provider.g.dart';

/// بارگذاری دسته کلمه مخفی برای نمایش به جاسوس
@riverpod
Future<WordCategory?> secretWordCategory(Ref ref) async {
  final categoryId = ref.watch(gameProvider).secretCategoryId;
  if (categoryId <= 0) return null;

  try {
    final isar = await ref.watch(isarProvider.future);
    return isar.wordCategorys.get(categoryId);
  } catch (_) {
    return null;
  }
}

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
    if (!ref.mounted) return;
    ref.read(audioServiceProvider).playReveal();
    ref.read(audioServiceProvider).vibrateLight();
    ref.read(gameProvider.notifier).revealCurrentRole();
  }

  /// رفتن به بازیکن بعدی
  void nextPlayer() {
    if (!ref.mounted) return;
    final game = ref.read(gameProvider);
    if (!game.isCurrentRevealed) return;

    state = state.copyWith(isPassingPhone: true);
    ref.read(gameProvider.notifier).advanceReveal();

    if (!ref.mounted) return;
    final updated = ref.read(gameProvider);
    if (updated.phase == GamePhase.timer) {
      state = const WordRevealUiState();
    } else {
      state = const WordRevealUiState(isPassingPhone: false);
    }
  }
}
