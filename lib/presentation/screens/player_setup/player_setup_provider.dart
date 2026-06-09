import 'package:easy_localization/easy_localization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spy_game/core/constants/game_config.dart';
import 'package:spy_game/core/utils/app_logger.dart';
import 'package:spy_game/data/models/player_group.dart';
import 'package:spy_game/data/repositories/player_repository.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';
import 'package:spy_game/presentation/providers/isar_provider.dart';
import 'package:spy_game/presentation/widgets/group_selector.dart';

part 'player_setup_provider.g.dart';

/// State صفحه ورود اسامی بازیکنان
class PlayerSetupState {
  const PlayerSetupState({
    this.playerNames = const [],
    this.selectedGroupId,
    this.isSaving = false,
    this.groups = const [],
  });

  final List<String> playerNames;
  final int? selectedGroupId;
  final bool isSaving;
  final List<GroupSelectorItem> groups;

  int get playerCount => playerNames.length;

  bool get canContinue =>
      playerCount >= GameConfig.minPlayers &&
      playerCount <= GameConfig.maxPlayers;

  PlayerSetupState copyWith({
    List<String>? playerNames,
    int? selectedGroupId,
    bool? isSaving,
    List<GroupSelectorItem>? groups,
    bool clearSelectedGroup = false,
  }) {
    return PlayerSetupState(
      playerNames: playerNames ?? this.playerNames,
      selectedGroupId: clearSelectedGroup
          ? null
          : (selectedGroupId ?? this.selectedGroupId),
      isSaving: isSaving ?? this.isSaving,
      groups: groups ?? this.groups,
    );
  }
}

@riverpod
class PlayerSetupNotifier extends _$PlayerSetupNotifier {
  final PlayerRepository _repository = const PlayerRepository();

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
      final groups = await _repository.getAllGroups(isar: isar);
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

  /// ذخیره یا به‌روزرسانی گروه فعلی
  Future<bool> saveCurrentGroup(String name) async {
    if (name.trim().isEmpty) return false;

    state = state.copyWith(isSaving: true);
    try {
      final isar = await ref.read(isarProvider.future);
      final bool success;

      if (state.selectedGroupId != null) {
        success = await _repository.updateGroup(
          isar: isar,
          groupId: state.selectedGroupId!,
          name: name,
          playerNames: state.playerNames,
        );
      } else {
        final group = await _repository.saveGroup(
          isar: isar,
          name: name,
          playerNames: state.playerNames,
        );
        success = group != null;
        if (group != null && ref.mounted) {
          state = state.copyWith(selectedGroupId: group.id);
        }
      }

      if (success) {
        await _loadGroups();
      }
      return success;
    } catch (e, stackTrace) {
      appLogger.e('Failed to save player group', e, stackTrace);
      return false;
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isSaving: false);
      }
    }
  }

  /// حذف گروه انتخاب‌شده
  Future<bool> deleteSelectedGroup() async {
    final groupId = state.selectedGroupId;
    if (groupId == null) return false;

    try {
      final isar = await ref.read(isarProvider.future);
      final success = await _repository.deleteGroup(
        isar: isar,
        groupId: groupId,
      );

      if (success && ref.mounted) {
        state = state.copyWith(
          clearSelectedGroup: true,
          playerNames: _defaultPlayerNames(),
        );
        await _loadGroups();
      }
      return success;
    } catch (e, stackTrace) {
      appLogger.e('Failed to delete player group', e, stackTrace);
      return false;
    }
  }

  /// اگر هنوز اسامی در بازی ست نشده، پیش‌فرض را در game state می‌گذارد
  void syncDefaultsToGameIfEmpty() {
    final game = ref.read(gameProvider);
    if (game.playerNames.isNotEmpty) return;
    ref.read(gameProvider.notifier).setPlayerNames(_defaultPlayerNames());
  }

  /// همگام‌سازی state صفحه با اسامی فعلی بازی
  void syncFromGame() {
    final game = ref.read(gameProvider);
    final names = game.playerNames.isNotEmpty
        ? List<String>.from(game.playerNames)
        : _defaultPlayerNames();
    state = state.copyWith(
      playerNames: names,
      clearSelectedGroup: true,
    );
  }

  /// ذخیره اسامی در game state (بازگشت از صفحه اسامی)
  void applyToGame() {
    ref.read(gameProvider.notifier).setPlayerNames(state.playerNames);
  }
}

/// Provider گروه‌های بازیکن برای selector
@riverpod
Future<List<PlayerGroup>> savedPlayerGroups(Ref ref) async {
  try {
    final isar = await ref.watch(isarProvider.future);
    return const PlayerRepository().getAllGroups(isar: isar);
  } catch (_) {
    return const [];
  }
}
