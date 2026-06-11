import 'package:spy_game/data/models/word_category.dart';

/// منطق دسترسی به دسته — رایگان، ویدیو، طلایی
abstract final class CategoryAccess {
  /// آیا دسته قفل است؟
  static bool isLocked({
    required WordCategory category,
    required bool isGoldenUser,
    required Set<String> adUnlockedSlugs,
  }) {
    if (isGoldenUser) return false;
    if (!category.isPremium && !category.isUnlockedByAd) return false;
    if (category.isUnlockedByAd && adUnlockedSlugs.contains(category.slug)) {
      return false;
    }
    return category.isPremium || category.isUnlockedByAd;
  }

  /// آیا دسته با ویدیو باز شده (بدون طلایی)؟
  static bool isUnlockedByVideo({
    required WordCategory category,
    required bool isGoldenUser,
    required Set<String> adUnlockedSlugs,
  }) {
    return !isGoldenUser &&
        category.isUnlockedByAd &&
        adUnlockedSlugs.contains(category.slug);
  }

  /// آیا می‌توان دسته را انتخاب کرد؟
  static bool canSelect({
    required WordCategory category,
    required bool isGoldenUser,
    required Set<String> adUnlockedSlugs,
  }) {
    return !isLocked(
      category: category,
      isGoldenUser: isGoldenUser,
      adUnlockedSlugs: adUnlockedSlugs,
    );
  }
}
