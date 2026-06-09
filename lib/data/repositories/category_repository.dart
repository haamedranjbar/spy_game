import 'package:isar_community/isar.dart';
import 'package:spy_game/core/constants/game_config.dart';
import 'package:spy_game/core/utils/app_logger.dart';
import 'package:spy_game/data/models/word.dart';
import 'package:spy_game/data/models/word_category.dart';

/// ایجاد و مدیریت دسته‌بندی‌های سفارشی کاربر
class CategoryRepository {
  const CategoryRepository();

  /// دریافت همه دسته‌های سفارشی (غیر پیش‌فرض)
  Future<List<WordCategory>> getCustomCategories({
    required Isar isar,
  }) async {
    try {
      final categories =
          await isar.wordCategorys.filter().isDefaultEqualTo(false).findAll();
      categories.sort((a, b) => b.id.compareTo(a.id));
      return categories;
    } catch (e, stackTrace) {
      appLogger.e('Failed to get custom categories', e, stackTrace);
      return const [];
    }
  }

  /// دریافت کلمات یک دسته
  Future<List<String>> getWordsForCategory({
    required Isar isar,
    required int categoryId,
  }) async {
    try {
      final words = await isar.words
          .filter()
          .categoryIdEqualTo(categoryId)
          .findAll();
      words.sort((a, b) => a.id.compareTo(b.id));
      return words.map((word) => word.text).toList();
    } catch (e, stackTrace) {
      appLogger.e('Failed to get category words', e, stackTrace);
      return const [];
    }
  }

  /// ساخت دسته سفارشی با کلمات
  Future<WordCategory?> createCustomCategory({
    required Isar isar,
    required String name,
    required CategoryType type,
    required List<String> words,
  }) async {
    final trimmedWords = _trimmedWords(words);
    if (trimmedWords.length < GameConfig.minCustomCategoryWords) {
      return null;
    }

    try {
      final slug = 'custom_${DateTime.now().millisecondsSinceEpoch}';
      final category = WordCategory()
        ..slug = slug
        ..name = name.trim()
        ..nameEn = name.trim()
        ..type = type
        ..isDefault = false
        ..isPremium = false
        ..isUnlockedByAd = false
        ..wordCount = trimmedWords.length
        ..iconName = 'category';

      await isar.writeTxn(() async {
        // شناسه دسته بعد از put برای اتصال کلمات لازم است
        final categoryId = await isar.wordCategorys.put(category);
        category.id = categoryId;

        for (final text in trimmedWords) {
          final word = Word()
            ..text = text
            ..categoryId = categoryId
            ..difficulty = WordDifficulty.medium;
          await isar.words.put(word);
        }
      });

      return category;
    } catch (e, stackTrace) {
      appLogger.e('Failed to create custom category', e, stackTrace);
      return null;
    }
  }

  /// به‌روزرسانی دسته سفارشی موجود
  Future<WordCategory?> updateCustomCategory({
    required Isar isar,
    required int categoryId,
    required String name,
    required CategoryType type,
    required List<String> words,
  }) async {
    final trimmedWords = _trimmedWords(words);
    if (trimmedWords.length < GameConfig.minCustomCategoryWords) {
      return null;
    }

    try {
      final existing = await isar.wordCategorys.get(categoryId);
      if (existing == null || existing.isDefault) return null;

      existing
        ..name = name.trim()
        ..nameEn = name.trim()
        ..type = type
        ..wordCount = trimmedWords.length;

      await isar.writeTxn(() async {
        await isar.wordCategorys.put(existing);

        final oldWords = await isar.words
            .filter()
            .categoryIdEqualTo(categoryId)
            .findAll();
        for (final word in oldWords) {
          await isar.words.delete(word.id);
        }

        for (final text in trimmedWords) {
          final word = Word()
            ..text = text
            ..categoryId = categoryId
            ..difficulty = WordDifficulty.medium;
          await isar.words.put(word);
        }
      });

      return existing;
    } catch (e, stackTrace) {
      appLogger.e('Failed to update custom category', e, stackTrace);
      return null;
    }
  }

  /// حذف دسته سفارشی و کلمات وابسته
  Future<bool> deleteCustomCategory({
    required Isar isar,
    required int categoryId,
  }) async {
    try {
      final existing = await isar.wordCategorys.get(categoryId);
      if (existing == null || existing.isDefault) return false;

      await isar.writeTxn(() async {
        final words = await isar.words
            .filter()
            .categoryIdEqualTo(categoryId)
            .findAll();
        for (final word in words) {
          await isar.words.delete(word.id);
        }
        await isar.wordCategorys.delete(categoryId);
      });

      return true;
    } catch (e, stackTrace) {
      appLogger.e('Failed to delete custom category', e, stackTrace);
      return false;
    }
  }

  List<String> _trimmedWords(List<String> words) {
    return words
        .map((word) => word.trim())
        .where((word) => word.isNotEmpty)
        .toList();
  }
}
