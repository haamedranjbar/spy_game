import 'dart:math';

import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spy_game/core/constants/game_config.dart';
import 'package:spy_game/core/utils/app_logger.dart';
import 'package:spy_game/data/models/player_role.dart';
import 'package:spy_game/data/models/word.dart';
import 'package:spy_game/data/models/word_category.dart';
import 'package:spy_game/presentation/providers/isar_provider.dart';

part 'game_provider.g.dart';

/// فاز جاری بازی
enum GamePhase {
  setup,
  wordReveal,
  timer,
  voting,
  result,
}

/// برنده دور یا بازی
enum GameWinner {
  citizens,
  spies,
}

/// State کامل بازی — منطق اصلی فاز ۱ (شهروند + جاسوس)
class GameState {
  const GameState({
    this.phase = GamePhase.setup,
    this.gameMode = CategoryType.classic,
    this.selectedCategoryIds = const [],
    this.playerNames = const [],
    this.spyCount = GameConfig.defaultSpyCount,
    this.timerSeconds = GameConfig.defaultTimerSeconds,
    this.showColorImages = false,
    this.roles = const [],
    this.secretWord = '',
    this.currentRevealIndex = 0,
    this.isCurrentRevealed = false,
    this.remainingSeconds = GameConfig.defaultTimerSeconds,
    this.currentVotingIndex = 0,
    this.votes = const {},
    this.eliminatedPlayerName,
    this.eliminatedRole,
    this.winner,
    this.roundNumber = 0,
    this.isGameOver = false,
  });

  final GamePhase phase;
  final CategoryType gameMode;
  final List<int> selectedCategoryIds;
  final List<String> playerNames;
  final int spyCount;
  final int timerSeconds;
  final bool showColorImages;
  final List<PlayerRole> roles;
  final String secretWord;
  final int currentRevealIndex;
  final bool isCurrentRevealed;
  final int remainingSeconds;
  final int currentVotingIndex;
  final Map<String, String> votes;
  final String? eliminatedPlayerName;
  final GameRole? eliminatedRole;
  final GameWinner? winner;
  final int roundNumber;
  final bool isGameOver;

  /// بازیکنان زنده
  List<PlayerRole> get aliveRoles =>
      roles.where((role) => !role.isEliminated).toList();

  /// بازیکن فعلی در نمایش کلمه
  PlayerRole? get currentRevealPlayer {
    final alive = aliveRoles;
    if (currentRevealIndex < 0 || currentRevealIndex >= alive.length) {
      return null;
    }
    return alive[currentRevealIndex];
  }

  /// بازیکن فعلی در رای‌گیری
  PlayerRole? get currentVotingPlayer {
    final alive = aliveRoles;
    if (currentVotingIndex < 0 || currentVotingIndex >= alive.length) {
      return null;
    }
    return alive[currentVotingIndex];
  }

  /// آیا می‌توان بازی را شروع کرد؟
  bool get canStartGame =>
      playerNames.length >= GameConfig.minPlayers &&
      selectedCategoryIds.isNotEmpty &&
      spyCount >= GameConfig.minSpies &&
      spyCount < playerNames.length;

  GameState copyWith({
    GamePhase? phase,
    CategoryType? gameMode,
    List<int>? selectedCategoryIds,
    List<String>? playerNames,
    int? spyCount,
    int? timerSeconds,
    bool? showColorImages,
    List<PlayerRole>? roles,
    String? secretWord,
    int? currentRevealIndex,
    bool? isCurrentRevealed,
    int? remainingSeconds,
    int? currentVotingIndex,
    Map<String, String>? votes,
    String? eliminatedPlayerName,
    GameRole? eliminatedRole,
    GameWinner? winner,
    int? roundNumber,
    bool? isGameOver,
    bool clearEliminated = false,
    bool clearWinner = false,
  }) {
    return GameState(
      phase: phase ?? this.phase,
      gameMode: gameMode ?? this.gameMode,
      selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
      playerNames: playerNames ?? this.playerNames,
      spyCount: spyCount ?? this.spyCount,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      showColorImages: showColorImages ?? this.showColorImages,
      roles: roles ?? this.roles,
      secretWord: secretWord ?? this.secretWord,
      currentRevealIndex: currentRevealIndex ?? this.currentRevealIndex,
      isCurrentRevealed: isCurrentRevealed ?? this.isCurrentRevealed,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      currentVotingIndex: currentVotingIndex ?? this.currentVotingIndex,
      votes: votes ?? this.votes,
      eliminatedPlayerName: clearEliminated
          ? null
          : (eliminatedPlayerName ?? this.eliminatedPlayerName),
      eliminatedRole:
          clearEliminated ? null : (eliminatedRole ?? this.eliminatedRole),
      winner: clearWinner ? null : (winner ?? this.winner),
      roundNumber: roundNumber ?? this.roundNumber,
      isGameOver: isGameOver ?? this.isGameOver,
    );
  }
}

@Riverpod(keepAlive: true)
class GameNotifier extends _$GameNotifier {
  final Random _random = Random();

  @override
  GameState build() => const GameState();

  /// تنظیم حالت بازی (کلاسیک / خانوادگی)
  void setGameMode(CategoryType mode) {
    state = state.copyWith(
      gameMode: mode,
      selectedCategoryIds: const [],
    );
  }

  /// انتخاب یا لغو انتخاب دسته
  void toggleCategory(int categoryId) {
    final ids = List<int>.from(state.selectedCategoryIds);
    if (ids.contains(categoryId)) {
      ids.remove(categoryId);
    } else {
      ids.add(categoryId);
    }
    state = state.copyWith(selectedCategoryIds: ids);
  }

  /// تنظیم toggle تصاویر رنگی (Family Mode)
  void setShowColorImages(bool value) {
    state = state.copyWith(showColorImages: value);
  }

  /// ذخیره اسامی بازیکنان قبل از شروع
  void setPlayerNames(List<String> names) {
    final trimmed = names
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .toList();
    final maxSpies = trimmed.length > 1 ? trimmed.length - 1 : 1;
    final adjustedSpyCount = state.spyCount.clamp(GameConfig.minSpies, maxSpies);
    state = state.copyWith(
      playerNames: trimmed,
      spyCount: adjustedSpyCount,
    );
  }

  /// تنظیم تعداد جاسوس
  void setSpyCount(int count) {
    if (state.playerNames.isEmpty) return;
    final maxSpies = state.playerNames.length - 1;
    state = state.copyWith(
      spyCount: count.clamp(GameConfig.minSpies, maxSpies),
    );
  }

  /// شروع بازی — انتخاب کلمه و تخصیص نقش
  Future<bool> startGame() async {
    if (!state.canStartGame) return false;

    try {
      final isar = await ref.read(isarProvider.future);
      final word = await _pickRandomWord(isar);
      if (word == null) {
        appLogger.w('No word found for selected categories');
        return false;
      }

      final roles = _assignRoles(word.text);
      state = state.copyWith(
        phase: GamePhase.wordReveal,
        secretWord: word.text,
        roles: roles,
        currentRevealIndex: 0,
        isCurrentRevealed: false,
        remainingSeconds: state.timerSeconds,
        currentVotingIndex: 0,
        votes: const {},
        clearEliminated: true,
        clearWinner: true,
        roundNumber: 1,
        isGameOver: false,
      );
      return true;
    } catch (e, stackTrace) {
      appLogger.e('Failed to start game', e, stackTrace);
      return false;
    }
  }

  /// نمایش نقش بازیکن فعلی
  void revealCurrentRole() {
    if (state.phase != GamePhase.wordReveal) return;
    state = state.copyWith(isCurrentRevealed: true);
  }

  /// رفتن به بازیکن بعدی یا شروع تایمر
  void advanceReveal() {
    if (state.phase != GamePhase.wordReveal || !state.isCurrentRevealed) {
      return;
    }

    final aliveCount = state.aliveRoles.length;
    if (state.currentRevealIndex < aliveCount - 1) {
      state = state.copyWith(
        currentRevealIndex: state.currentRevealIndex + 1,
        isCurrentRevealed: false,
      );
      return;
    }

    state = state.copyWith(
      phase: GamePhase.timer,
      remainingSeconds: state.timerSeconds,
    );
  }

  /// پایان تایمر — ورود به رای‌گیری
  void finishTimer() {
    if (state.phase != GamePhase.timer) return;
    state = state.copyWith(
      phase: GamePhase.voting,
      currentVotingIndex: 0,
      votes: const {},
    );
  }

  /// ثبت رای بازیکن فعلی
  void castVote(String votedForName) {
    if (state.phase != GamePhase.voting) return;
    final voter = state.currentVotingPlayer;
    if (voter == null || voter.playerName == votedForName) return;

    final updatedVotes = Map<String, String>.from(state.votes)
      ..[voter.playerName] = votedForName;

    final aliveCount = state.aliveRoles.length;
    if (state.currentVotingIndex < aliveCount - 1) {
      state = state.copyWith(
        votes: updatedVotes,
        currentVotingIndex: state.currentVotingIndex + 1,
      );
      return;
    }

    state = state.copyWith(votes: updatedVotes);
    _resolveVoting();
  }

  /// شروع دور بعدی با کلمه و نقش جدید
  Future<bool> startNextRound() async {
    if (state.isGameOver) return false;

    try {
      final isar = await ref.read(isarProvider.future);
      final word = await _pickRandomWord(isar);
      if (word == null) return false;

      final aliveNames =
          state.aliveRoles.map((role) => role.playerName).toList();
      final roles = _assignRolesForPlayers(word.text, aliveNames);

      state = state.copyWith(
        phase: GamePhase.wordReveal,
        secretWord: word.text,
        roles: roles,
        currentRevealIndex: 0,
        isCurrentRevealed: false,
        remainingSeconds: state.timerSeconds,
        currentVotingIndex: 0,
        votes: const {},
        clearEliminated: true,
        clearWinner: true,
        roundNumber: state.roundNumber + 1,
      );
      return true;
    } catch (e, stackTrace) {
      appLogger.e('Failed to start next round', e, stackTrace);
      return false;
    }
  }

  /// بازنشانی کامل برای بازگشت به خانه
  void resetGame() {
    state = const GameState();
  }

  /// انتخاب کلمه تصادفی از دسته‌های انتخاب‌شده
  Future<Word?> _pickRandomWord(Isar isar) async {
    final categoryIds = state.selectedCategoryIds;
    if (categoryIds.isEmpty) return null;

    final words = await isar.words
        .filter()
        .anyOf(categoryIds, (query, categoryId) => query.categoryIdEqualTo(categoryId))
        .findAll();

    if (words.isEmpty) return null;
    return words[_random.nextInt(words.length)];
  }

  /// تخصیص نقش به همه بازیکنان
  List<PlayerRole> _assignRoles(String word) {
    return _assignRolesForPlayers(word, state.playerNames);
  }

  /// تخصیص نقش جاسوس به تعداد مشخص
  List<PlayerRole> _assignRolesForPlayers(String word, List<String> names) {
    final shuffled = List<String>.from(names)..shuffle(_random);
    final spyNames = shuffled.take(state.spyCount).toSet();

    return names
        .map(
          (name) => PlayerRole(
            playerName: name,
            role: spyNames.contains(name) ? GameRole.spy : GameRole.citizen,
            word: spyNames.contains(name) ? null : word,
          ),
        )
        .toList();
  }

  /// محاسبه نتیجه رای‌گیری و بررسی شرط برد
  void _resolveVoting() {
    final voteCounts = <String, int>{};
    for (final target in state.votes.values) {
      voteCounts[target] = (voteCounts[target] ?? 0) + 1;
    }

    if (voteCounts.isEmpty) {
      state = state.copyWith(phase: GamePhase.result);
      return;
    }

    final maxVotes = voteCounts.values.reduce((a, b) => a > b ? a : b);
    final topVoted = voteCounts.entries
        .where((entry) => entry.value == maxVotes)
        .map((entry) => entry.key)
        .toList();

    final eliminatedName = topVoted.length == 1
        ? topVoted.first
        : topVoted[_random.nextInt(topVoted.length)];

    final updatedRoles = state.roles
        .map(
          (role) => role.playerName == eliminatedName
              ? role.copyWith(isEliminated: true)
              : role,
        )
        .toList();

    final eliminatedRole = updatedRoles
        .firstWhere((role) => role.playerName == eliminatedName)
        .role;

    final alive = updatedRoles.where((role) => !role.isEliminated).toList();
    final spyCount =
        alive.where((role) => role.role == GameRole.spy).length;
    final citizenCount =
        alive.where((role) => role.role == GameRole.citizen).length;

    GameWinner? winner;
    var isGameOver = false;

    if (spyCount == 0) {
      winner = GameWinner.citizens;
      isGameOver = true;
    } else if (spyCount >= citizenCount) {
      winner = GameWinner.spies;
      isGameOver = true;
    }

    state = state.copyWith(
      phase: GamePhase.result,
      roles: updatedRoles,
      eliminatedPlayerName: eliminatedName,
      eliminatedRole: eliminatedRole,
      winner: winner,
      isGameOver: isGameOver,
    );
  }
}
