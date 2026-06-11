import 'package:isar_community/isar.dart';
import 'package:spy_game/core/constants/game_config.dart';
import 'package:spy_game/core/utils/app_logger.dart';
import 'package:spy_game/data/models/word.dart';
import 'package:spy_game/data/models/word_category.dart';
import 'package:spy_game/data/seeds/fa_words.dart';

/// بارگذاری و همگام‌سازی کلمات پیش‌فرض در Isar
class DefaultWordsSeeder {
  DefaultWordsSeeder._();

  /// همگام‌سازی دسته‌ها و کلمات بر اساس slug
  static Future<void> seedIfNeeded(Isar isar) async {
    try {
      var createdCategories = 0;
      var addedWords = 0;

      await isar.writeTxn(() async {
        for (final seed in allFaCategorySeeds) {
          final result = await _syncCategory(isar, seed);
          createdCategories += result.createdCategory ? 1 : 0;
          addedWords += result.addedWords;
        }
      });

      if (createdCategories > 0 || addedWords > 0) {
        appLogger.i(
          'Words synced: $createdCategories new categories, $addedWords new words '
          '(seed v${GameConfig.wordSeedVersion})',
        );
      }
    } catch (e, stackTrace) {
      appLogger.e('Failed to seed default words', e, stackTrace);
      rethrow;
    }
  }

  /// ایجاد یا به‌روزرسانی یک دسته و کلماتش
  static Future<({bool createdCategory, int addedWords})> _syncCategory(
    Isar isar,
    CategorySeed seed,
  ) async {
    var category = await isar.wordCategorys
        .filter()
        .slugEqualTo(seed.slug)
        .findFirst();

    var createdCategory = false;

    if (category == null) {
      category = WordCategory()
        ..slug = seed.slug
        ..name = seed.nameFa
        ..nameEn = seed.nameEn
        ..type = seed.type
        ..isDefault = seed.isDefault
        ..isPremium = seed.isPremium
        ..isUnlockedByAd = seed.isUnlockedByAd
        ..wordCount = 0
        ..iconName = seed.iconName;

      await isar.wordCategorys.put(category);
      createdCategory = true;
    } else {
      // به‌روزرسانی متادیتا در صورت تغییر seed
      category
        ..name = seed.nameFa
        ..nameEn = seed.nameEn
        ..type = seed.type
        ..isDefault = seed.isDefault
        ..isPremium = seed.isPremium
        ..isUnlockedByAd = seed.isUnlockedByAd
        ..iconName = seed.iconName;
      await isar.wordCategorys.put(category);
    }

    final existingWords = await isar.words
        .filter()
        .categoryIdEqualTo(category.id)
        .findAll();

    final existingByText = {
      for (final word in existingWords) word.text: word,
    };
    final newWords = <Word>[];
    var updatedHints = 0;

    for (final entry in seed.words) {
      final existing = existingByText[entry.text];
      if (existing != null) {
        // به‌روزرسانی hint در صورت تغییر seed
        if (entry.hint != null && existing.hint != entry.hint) {
          existing.hint = entry.hint;
          await isar.words.put(existing);
          updatedHints++;
        }
        continue;
      }

      newWords.add(
        Word()
          ..text = entry.text
          ..hint = entry.hint
          ..categoryId = category.id
          ..difficulty = seed.difficulty,
      );
    }

    if (newWords.isNotEmpty) {
      await isar.words.putAll(newWords);
    }

    if (updatedHints > 0) {
      appLogger.i(
        'Updated $updatedHints hints for category ${seed.slug}',
      );
    }

    final totalWords = existingWords.length + newWords.length;
    category.wordCount = totalWords;
    await isar.wordCategorys.put(category);

    return (createdCategory: createdCategory, addedWords: newWords.length);
  }
}
