import 'package:isar_community/isar.dart';
import 'package:spy_game/core/utils/app_logger.dart';
import 'package:spy_game/data/models/ad_unlocked_category.dart';
import 'package:spy_game/data/models/purchase_state.dart';

/// ذخیره وضعیت طلایی و دسته‌های باز شده با ویدیو
class MonetizationRepository {
  const MonetizationRepository();

  /// خواندن وضعیت خرید
  Future<PurchaseState> getPurchaseState({required Isar isar}) async {
    try {
      final existing = await isar.purchaseStates.where().findFirst();
      if (existing != null) return existing;

      final initial = PurchaseState()..isGoldenUser = false;
      await isar.writeTxn(() async {
        await isar.purchaseStates.put(initial);
      });
      return initial;
    } catch (e, stackTrace) {
      appLogger.e('Failed to get purchase state', e, stackTrace);
      return PurchaseState()..isGoldenUser = false;
    }
  }

  /// فعال‌سازی نسخه طلایی
  Future<bool> setGoldenUser({
    required Isar isar,
    String? purchaseToken,
  }) async {
    try {
      final state = await getPurchaseState(isar: isar);
      state
        ..isGoldenUser = true
        ..purchaseToken = purchaseToken
        ..purchaseDate = DateTime.now();

      await isar.writeTxn(() async {
        await isar.purchaseStates.put(state);
      });
      return true;
    } catch (e, stackTrace) {
      appLogger.e('Failed to set golden user', e, stackTrace);
      return false;
    }
  }

  /// لیست slug دسته‌های باز شده با ویدیو
  Future<Set<String>> getAdUnlockedSlugs({required Isar isar}) async {
    try {
      final unlocked = await isar.adUnlockedCategorys.where().findAll();
      return unlocked.map((item) => item.categorySlug).toSet();
    } catch (e, stackTrace) {
      appLogger.e('Failed to get ad unlocked categories', e, stackTrace);
      return {};
    }
  }

  /// باز کردن دسته با تماشای ویدیو
  Future<bool> unlockCategoryByAd({
    required Isar isar,
    required String categorySlug,
  }) async {
    try {
      final entry = AdUnlockedCategory()
        ..categorySlug = categorySlug
        ..unlockedAt = DateTime.now();

      await isar.writeTxn(() async {
        await isar.adUnlockedCategorys.put(entry);
      });
      return true;
    } catch (e, stackTrace) {
      appLogger.e('Failed to unlock category by ad', e, stackTrace);
      return false;
    }
  }
}
