import 'package:isar_community/isar.dart';
import 'package:spy_game/core/utils/app_logger.dart';
import 'package:spy_game/data/models/player_group.dart';

/// ذخیره و بازیابی گروه‌های بازیکن از Isar
class PlayerRepository {
  const PlayerRepository();

  /// دریافت همه گروه‌ها
  Future<List<PlayerGroup>> getAllGroups({required Isar isar}) async {
    try {
      final groups = await isar.playerGroups.where().anyId().findAll();
      groups.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return groups;
    } catch (e, stackTrace) {
      appLogger.e('Failed to get player groups', e, stackTrace);
      return const [];
    }
  }

  /// ذخیره گروه جدید
  Future<PlayerGroup?> saveGroup({
    required Isar isar,
    required String name,
    required List<String> playerNames,
  }) async {
    try {
      final group = PlayerGroup()
        ..name = name.trim()
        ..playerNames = playerNames
            .map((n) => n.trim())
            .where((n) => n.isNotEmpty)
            .toList()
        ..createdAt = DateTime.now();

      await isar.writeTxn(() async {
        await isar.playerGroups.put(group);
      });
      return group;
    } catch (e, stackTrace) {
      appLogger.e('Failed to save player group', e, stackTrace);
      return null;
    }
  }

  /// به‌روزرسانی گروه موجود
  Future<bool> updateGroup({
    required Isar isar,
    required int groupId,
    required String name,
    required List<String> playerNames,
  }) async {
    try {
      final existing = await isar.playerGroups.get(groupId);
      if (existing == null) return false;

      existing.name = name.trim();
      existing.playerNames = playerNames
          .map((n) => n.trim())
          .where((n) => n.isNotEmpty)
          .toList();

      await isar.writeTxn(() async {
        await isar.playerGroups.put(existing);
      });
      return true;
    } catch (e, stackTrace) {
      appLogger.e('Failed to update player group', e, stackTrace);
      return false;
    }
  }

  /// حذف گروه
  Future<bool> deleteGroup({
    required Isar isar,
    required int groupId,
  }) async {
    try {
      await isar.writeTxn(() async {
        await isar.playerGroups.delete(groupId);
      });
      return true;
    } catch (e, stackTrace) {
      appLogger.e('Failed to delete player group', e, stackTrace);
      return false;
    }
  }
}
