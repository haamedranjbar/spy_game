import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spy_game/core/constants/game_config.dart';
import 'package:spy_game/core/utils/app_logger.dart';
import 'package:spy_game/data/models/database_meta.dart';

/// نام instance دیتابیس Isar
const String kIsarInstanceName = 'spy_game';

/// راه‌اندازی و دسترسی به Isar — همه عملیات با try/catch
class IsarDatasource {
  IsarDatasource._();

  static Isar? _instance;

  /// instance فعال Isar
  static Isar? get instance => _instance;

  /// آیا دیتابیس باز شده؟
  static bool get isInitialized => _instance != null && _instance!.isOpen;

  /// باز کردن دیتابیس Isar
  static Future<Isar> open() async {
    if (_instance != null && _instance!.isOpen) {
      return _instance!;
    }

    try {
      final dir = await getApplicationDocumentsDirectory();

      _instance = await Isar.open(
        [DatabaseMetaSchema],
        directory: dir.path,
        name: kIsarInstanceName,
      );

      await _ensureDatabaseVersion(_instance!);

      appLogger.i('Isar database opened successfully');
      return _instance!;
    } catch (e, stackTrace) {
      appLogger.e('Failed to open Isar database', e, stackTrace);
      rethrow;
    }
  }

  /// ثبت نسخه دیتابیس در اولین اجرا
  static Future<void> _ensureDatabaseVersion(Isar isar) async {
    try {
      final existing = await isar.databaseMetas.where().findFirst();

      if (existing == null) {
        await isar.writeTxn(() async {
          await isar.databaseMetas.put(
            DatabaseMeta()..version = GameConfig.databaseVersion,
          );
        });
        appLogger.i('Database version initialized: ${GameConfig.databaseVersion}');
      }
    } catch (e, stackTrace) {
      appLogger.e('Failed to ensure database version', e, stackTrace);
      rethrow;
    }
  }

  /// بستن دیتابیس
  static Future<void> close() async {
    if (_instance == null) return;

    try {
      if (_instance!.isOpen) {
        await _instance!.close();
      }
      _instance = null;
      appLogger.i('Isar database closed');
    } catch (e, stackTrace) {
      appLogger.e('Failed to close Isar database', e, stackTrace);
      rethrow;
    }
  }
}
