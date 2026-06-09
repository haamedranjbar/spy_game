import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spy_game/presentation/providers/audio_provider.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';

part 'voting_provider.g.dart';

/// State محلی صفحه رای‌گیری
class VotingUiState {
  const VotingUiState({
    this.selectedPlayerName,
  });

  final String? selectedPlayerName;

  VotingUiState copyWith({String? selectedPlayerName, bool clearSelection = false}) {
    return VotingUiState(
      selectedPlayerName:
          clearSelection ? null : (selectedPlayerName ?? this.selectedPlayerName),
    );
  }
}

@riverpod
class VotingNotifier extends _$VotingNotifier {
  @override
  VotingUiState build() => const VotingUiState();

  void selectPlayer(String name) {
    state = state.copyWith(selectedPlayerName: name);
  }

  void clearSelection() {
    state = const VotingUiState();
  }

  /// ثبت رای و رفتن به رای‌دهنده بعدی
  void submitVote() {
    final selected = state.selectedPlayerName;
    if (selected == null) return;

    ref.read(audioServiceProvider).playVote();
    ref.read(audioServiceProvider).vibrateLight();
    ref.read(gameProvider.notifier).castVote(selected);
    state = const VotingUiState();
  }
}
