import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spy_game/data/models/player_role.dart';
import 'package:spy_game/presentation/providers/audio_provider.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';

part 'investigation_provider.g.dart';

/// State صفحه بازجویی کاراگاه
class InvestigationUiState {
  const InvestigationUiState({
    this.selectedTargetName,
  });

  final String? selectedTargetName;

  InvestigationUiState copyWith({String? selectedTargetName}) {
    return InvestigationUiState(
      selectedTargetName: selectedTargetName ?? this.selectedTargetName,
    );
  }
}

@riverpod
class InvestigationNotifier extends _$InvestigationNotifier {
  @override
  InvestigationUiState build() => const InvestigationUiState();

  /// بازیکنانی که کاراگاه می‌تواند بازجویی کند
  List<PlayerRole> get investigationTargets {
    final game = ref.read(gameProvider);
    final detective = game.aliveDetective;
    if (detective == null) return const [];

    return game.aliveRoles
        .where((role) => role.playerName != detective.playerName)
        .toList();
  }

  /// انتخاب هدف بازجویی و نمایش نتیجه
  void selectTarget(String playerName) {
    if (!ref.mounted) return;
    ref.read(audioServiceProvider).playTap();
    ref.read(gameProvider.notifier).completeInvestigation(playerName);
    state = state.copyWith(selectedTargetName: playerName);
  }

  /// ادامه به رای‌گیری پس از دیدن نتیجه
  void proceedToVoting() {
    if (!ref.mounted) return;
    ref.read(audioServiceProvider).playTap();
    ref.read(gameProvider.notifier).proceedToVoting();
  }
}
