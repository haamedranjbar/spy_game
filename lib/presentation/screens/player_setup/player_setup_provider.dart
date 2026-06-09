import 'package:easy_localization/easy_localization.dart';
import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spy_game/core/constants/game_config.dart';
import 'package:spy_game/core/utils/app_logger.dart';
import 'package:spy_game/data/models/player_group.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';
import 'package:spy_game/presentation/providers/isar_provider.dart';
import 'package:spy_game/presentation/widgets/group_selector.dart';

part 'player_setup_provider.g.dart';

/// State صفحه ورود اسامی بازیکنان
class PlayerSetupState {
  const PlayerSetupState({
    this.playerNames = const [],
    this.selectedGroupId,
    this.isStarting = false,
    this.groups = const [],
  });

  final List<String> playerNames;
  final int? selectedGroupId;
  final bool isStarting;
  final List<GroupSelectorItem> groups;

  int get playerCount => playerNames.length;

  bool get canContinue =>
      playerCount >= GameConfig.minPlayers &&
      playerCount <= GameConfig.maxPlayers;

  PlayerSetupState copyWith({
    List<String>? playerNames,
    int? selectedGroupId,
    bool? isStarting,
    List<GroupSelectorItem>? groups,
    bool clearSelectedGroup = false,
  }) {
    return PlayerSetupState(
      playerNames: playerNames ?? this.playerNames,
      selectedGroupId: clearSelectedGroup
          ? null
          : (selectedGroupId ?? this.selectedGroupId),
      isStarting: isStarting ?? this.isStarting,
      groups: groups ?? this.groups,
    );
  }
}

@riverpod
class PlayerSetupNotifier extends _$PlayerSetupNotifier {
  @override
  PlayerSetupState build() {
    _loadGroups();
    final game = ref.read(gameProvider);
    if (game.playerNames.isNotEmpty) {
      return PlayerSetupState(playerNames: List<String>.from(game.playerNames));
    }
    return PlayerSetupState(
      playerNames: _defaultPlayerNames(),
    );
  }

  /// اسامی پیش‌فرض برای شروع سریع
  List<String> _defaultPlayerNames() {
    return List.generate(
      GameConfig.defaultPlayerCount,
      (index) => 'player_setup.default_name'.tr(
        args: [(index + 1).toString()],
      ),
    );
  }

  /// بارگذاری گروه‌های ذخیره‌شده از Isar
  Future<void> _loadGroups() async {
    try {
      final isar = await ref.read(isarProvider.future);
      final groups = await isar.playerGroups.where().findAll();
      final items = groups
          .map(
            (group) => GroupSelectorItem(
              id: group.id,
              name: group.name,
            ),
          )
          .toList();

      if (!ref.mounted) return;
      state = state.copyWith(groups: items);
    } catch (e, stackTrace) {
      appLogger.e('Failed to load player groups', e, stackTrace);
    }
  }

  void addPlayer() {
    if (state.playerCount >= GameConfig.maxPlayers) return;
    final nextIndex = state.playerCount + 1;
    final names = List<String>.from(state.playerNames)
      ..add(
        'player_setup.default_name'.tr(args: [nextIndex.toString()]),
      );
    state = state.copyWith(
      playerNames: names,
      clearSelectedGroup: true,
    );
  }

  void removePlayer() {
    if (state.playerCount <= GameConfig.minPlayers) return;
    final names = List<String>.from(state.playerNames)..removeLast();
    state = state.copyWith(
      playerNames: names,
      clearSelectedGroup: true,
    );
  }

  /// حذف بازیکن در ایندکس مشخص
  void removePlayerAt(int index) {
    if (state.playerCount <= GameConfig.minPlayers) return;
    if (index < 0 || index >= state.playerNames.length) return;
    final names = List<String>.from(state.playerNames)..removeAt(index);
    state = state.copyWith(
      playerNames: names,
      clearSelectedGroup: true,
    );
  }

  void updatePlayerName(int index, String name) {
    if (index < 0 || index >= state.playerNames.length) return;
    final names = List<String>.from(state.playerNames);
    names[index] = name;
    state = state.copyWith(
      playerNames: names,
      clearSelectedGroup: true,
    );
  }

  /// انتخاب گروه ذخیره‌شده
  Future<void> selectGroup(int? groupId) async {
    if (groupId == null) {
      state = state.copyWith(clearSelectedGroup: true);
      return;
    }

    try {
      final isar = await ref.read(isarProvider.future);
      final group = await isar.playerGroups.get(groupId);
      if (group == null || !ref.mounted) return;

      state = state.copyWith(
        selectedGroupId: groupId,
        playerNames: List<String>.from(group.playerNames),
      );
    } catch (e, stackTrace) {
      appLogger.e('Failed to select player group', e, stackTrace);
    }
  }

  void createNewGroup() {
    state = state.copyWith(
      clearSelectedGroup: true,
      playerNames: _defaultPlayerNames(),
    );
  }

  /// شروع بازی با اسامی فعلی
  Future<bool> startGame() async {
    state = state.copyWith(isStarting: true);
    ref.read(gameProvider.notifier).setPlayerNames(state.playerNames);
    final started = await ref.read(gameProvider.notifier).startGame();
    if (ref.mounted) {
      state = state.copyWith(isStarting: false);
    }
    return started;
  }
}

/// Provider گروه‌های بازیکن برای selector
@riverpod
Future<List<PlayerGroup>> savedPlayerGroups(Ref ref) async {
  try {
    final isar = await ref.watch(isarProvider.future);
    return isar.playerGroups.where().findAll();
  } catch (_) {
    return const [];
  }
}
