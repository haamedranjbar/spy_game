import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spy_game/core/constants/game_config.dart';
import 'package:spy_game/core/utils/app_logger.dart';
import 'package:spy_game/data/models/game_winner.dart';
import 'package:spy_game/data/models/player_role.dart';
import 'package:spy_game/data/models/word_category.dart';
import 'package:spy_game/data/repositories/game_repository.dart';
import 'package:spy_game/data/repositories/word_repository.dart';
import 'package:spy_game/presentation/providers/isar_provider.dart';

export 'package:spy_game/data/models/game_winner.dart' show GameWinner;

part 'game_provider.g.dart';

/// فاز جاری بازی
enum GamePhase {
  setup,
  wordReveal,
  timer,
  voting,
  result,
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
    this.showCategoryForSpy = false,
    this.spyHintEnabled = false,
    this.spiesKnowEachOther = false,
    this.showColorImages = false,
    this.roles = const [],
    this.secretWord = '',
    this.secretCategoryId = 0,
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
  final bool showCategoryForSpy;
  final bool spyHintEnabled;
  final bool spiesKnowEachOther;
  final bool showColorImages;
  final List<PlayerRole> roles;
  final String secretWord;
  final int secretCategoryId;
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
      spyCount <= GameConfig.maxSpiesForPlayerCount(playerNames.length);

  GameState copyWith({
    GamePhase? phase,
    CategoryType? gameMode,
    List<int>? selectedCategoryIds,
    List<String>? playerNames,
    int? spyCount,
    int? timerSeconds,
    bool? showCategoryForSpy,
    bool? spyHintEnabled,
    bool? spiesKnowEachOther,
    bool? showColorImages,
    List<PlayerRole>? roles,
    String? secretWord,
    int? secretCategoryId,
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
      showCategoryForSpy: showCategoryForSpy ?? this.showCategoryForSpy,
      spyHintEnabled: spyHintEnabled ?? this.spyHintEnabled,
      spiesKnowEachOther: spiesKnowEachOther ?? this.spiesKnowEachOther,
      showColorImages: showColorImages ?? this.showColorImages,
      roles: roles ?? this.roles,
      secretWord: secretWord ?? this.secretWord,
      secretCategoryId: secretCategoryId ?? this.secretCategoryId,
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
  late final GameRepository _gameRepository = GameRepository(_random);
  final WordRepository _wordRepository = const WordRepository();

  @override
  GameState build() => const GameState();

  /// تنظیم حالت بازی (کلاسیک / خانوادگی)
  void setGameMode(CategoryType mode) {
    state = state.copyWith(
      gameMode: mode,
      selectedCategoryIds: const [],
    );
  }

  /// همگام‌سازی تب بدون پاک کردن دسته‌های انتخاب‌شده
  void syncGameMode(CategoryType mode) {
    if (state.gameMode == mode) return;
    state = state.copyWith(gameMode: mode);
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

  /// حذف دسته از انتخاب‌ها پس از پاک شدن دسته سفارشی
  void removeCategoryFromSelection(int categoryId) {
    if (!state.selectedCategoryIds.contains(categoryId)) return;
    final ids = List<int>.from(state.selectedCategoryIds)..remove(categoryId);
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
    final maxSpies = GameConfig.maxSpiesForPlayerCount(trimmed.length);
    final adjustedSpyCount =
        state.spyCount.clamp(GameConfig.minSpies, maxSpies);
    state = state.copyWith(
      playerNames: trimmed,
      spyCount: adjustedSpyCount,
    );
  }

  /// تنظیم تعداد جاسوس
  void setSpyCount(int count) {
    if (state.playerNames.isEmpty) return;
    final maxSpies =
        GameConfig.maxSpiesForPlayerCount(state.playerNames.length);
    state = state.copyWith(
      spyCount: count.clamp(GameConfig.minSpies, maxSpies),
    );
  }

  /// تنظیم زمان تایمر بحث
  void setTimerSeconds(int seconds) {
    state = state.copyWith(
      timerSeconds: seconds.clamp(
        GameConfig.minTimerSeconds,
        GameConfig.maxTimerSeconds,
      ),
    );
  }

  /// نمایش دسته به جاسوس
  void setShowCategoryForSpy(bool value) {
    state = state.copyWith(showCategoryForSpy: value);
  }

  /// راهنمای کلمه برای جاسوس
  void setSpyHintEnabled(bool value) {
    state = state.copyWith(spyHintEnabled: value);
  }

  /// جاسوس‌ها همدیگر را بشناسند
  void setSpiesKnowEachOther(bool value) {
    state = state.copyWith(spiesKnowEachOther: value);
  }

  /// شروع بازی — انتخاب کلمه و تخصیص نقش
  Future<bool> startGame() async {
    if (!state.canStartGame) return false;

    try {
      final isar = await ref.read(isarProvider.future);
      final word = await _wordRepository.pickRandomWord(
        isar: isar,
        categoryIds: state.selectedCategoryIds,
        random: _random,
      );
      if (word == null) {
        appLogger.w('No word found for selected categories');
        return false;
      }

      final roles = _gameRepository.assignRoles(
        playerNames: state.playerNames,
        spyCount: state.spyCount,
        word: word.text,
      );

      state = state.copyWith(
        phase: GamePhase.wordReveal,
        secretWord: word.text,
        secretCategoryId: word.categoryId,
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

  /// پایان تایمر — ورود به صفحه بحث شفاهی
  void finishTimer() {
    if (state.phase != GamePhase.timer) return;
    state = state.copyWith(
      phase: GamePhase.voting,
      currentVotingIndex: 0,
      votes: const {},
    );
  }

  /// اتمام بازی — آماده افشای نقش‌ها
  void endGameReveal() {
    state = state.copyWith(
      isGameOver: true,
      clearEliminated: true,
      clearWinner: true,
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

  /// شروع دوباره — همان بازیکنان و تنظیمات، کلمه و نقش‌های جدید
  Future<bool> playAgain() async {
    if (state.playerNames.isEmpty || state.selectedCategoryIds.isEmpty) {
      return false;
    }

    try {
      final isar = await ref.read(isarProvider.future);
      final word = await _wordRepository.pickRandomWord(
        isar: isar,
        categoryIds: state.selectedCategoryIds,
        random: _random,
      );
      if (word == null) return false;

      final roles = _gameRepository.assignRoles(
        playerNames: state.playerNames,
        spyCount: state.spyCount,
        word: word.text,
      );

      state = state.copyWith(
        phase: GamePhase.wordReveal,
        secretWord: word.text,
        secretCategoryId: word.categoryId,
        roles: roles,
        currentRevealIndex: 0,
        isCurrentRevealed: false,
        remainingSeconds: state.timerSeconds,
        currentVotingIndex: 0,
        votes: const {},
        clearEliminated: true,
        clearWinner: true,
        roundNumber: state.roundNumber + 1,
        isGameOver: false,
      );
      return true;
    } catch (e, stackTrace) {
      appLogger.e('Failed to play again', e, stackTrace);
      return false;
    }
  }

  /// شروع دور بعدی — کلمه جدید، نقش‌ها بدون تغییر
  Future<bool> startNextRound() async {
    if (state.isGameOver) return false;

    try {
      final isar = await ref.read(isarProvider.future);
      final word = await _wordRepository.pickRandomWord(
        isar: isar,
        categoryIds: state.selectedCategoryIds,
        random: _random,
      );
      if (word == null) return false;

      final roles = _gameRepository.prepareNextRound(
        roles: state.roles,
        newWord: word.text,
      );

      state = state.copyWith(
        phase: GamePhase.wordReveal,
        secretWord: word.text,
        secretCategoryId: word.categoryId,
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

  /// محاسبه نتیجه رای‌گیری از طریق repository
  void _resolveVoting() {
    final result = _gameRepository.resolveVoting(
      roles: state.roles,
      votes: state.votes,
    );

    state = state.copyWith(
      phase: GamePhase.result,
      roles: result.roles,
      eliminatedPlayerName: result.eliminatedPlayerName,
      eliminatedRole: result.eliminatedRole,
      winner: result.winner,
      isGameOver: result.isGameOver,
    );
  }
}
