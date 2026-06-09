import 'package:isar_community/isar.dart';
import 'package:spy_game/core/utils/app_logger.dart';
import 'package:spy_game/data/models/word.dart';
import 'package:spy_game/data/models/word_category.dart';

/// ایجاد و مدیریت دسته‌بندی‌های سفارشی کاربر
class CategoryRepository {
  const CategoryRepository();

  /// ساخت دسته سفارشی با کلمات
  Future<WordCategory?> createCustomCategory({
    required Isar isar,
    required String name,
    required CategoryType type,
    required List<String> words,
  }) async {
    final trimmedWords = words
        .map((w) => w.trim())
        .where((w) => w.isNotEmpty)
        .toList();

    if (trimmedWords.isEmpty) return null;

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
        await isar.wordCategorys.put(category);

        for (final text in trimmedWords) {
          final word = Word()
            ..text = text
            ..categoryId = category.id
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
}
