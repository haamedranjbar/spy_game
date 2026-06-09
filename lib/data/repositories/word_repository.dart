import 'dart:math';

import 'package:isar_community/isar.dart';
import 'package:spy_game/core/utils/app_logger.dart';
import 'package:spy_game/data/models/word.dart';

/// دسترسی به کلمات Isar — انتخاب کلمه تصادفی از دسته‌های انتخاب‌شده
class WordRepository {
  const WordRepository();

  /// انتخاب یک کلمه تصادفی از دسته‌های داده‌شده
  Future<Word?> pickRandomWord({
    required Isar isar,
    required List<int> categoryIds,
    required Random random,
  }) async {
    if (categoryIds.isEmpty) return null;

    try {
      final words = await isar.words
          .filter()
          .anyOf(
            categoryIds,
            (query, categoryId) => query.categoryIdEqualTo(categoryId),
          )
          .findAll();

      if (words.isEmpty) return null;
      return words[random.nextInt(words.length)];
    } catch (e, stackTrace) {
      appLogger.e('Failed to pick random word', e, stackTrace);
      return null;
    }
  }
}
