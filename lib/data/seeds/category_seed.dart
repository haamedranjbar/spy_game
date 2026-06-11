import 'package:spy_game/data/models/word.dart';
import 'package:spy_game/data/models/word_category.dart';

/// یک کلمه seed همراه راهنمای اختیاری جاسوس
class WordSeed {
  const WordSeed({
    required this.text,
    this.hint,
  });

  final String text;
  final String? hint;
}

/// تبدیل لیست متنی ساده به WordSeed بدون hint
List<WordSeed> seedWords(List<String> texts) {
  return texts.map((text) => WordSeed(text: text)).toList(growable: false);
}

/// ساختار seed برای یک دسته و کلماتش
class CategorySeed {
  CategorySeed({
    required this.slug,
    required this.iconName,
    required this.nameFa,
    required this.nameEn,
    List<String> wordTexts = const [],
    List<WordSeed>? wordSeeds,
    this.type = CategoryType.classic,
    this.isDefault = true,
    this.isPremium = false,
    this.isUnlockedByAd = false,
    this.difficulty = WordDifficulty.medium,
  }) : words = wordSeeds ??
            wordTexts.map((text) => WordSeed(text: text)).toList(growable: false);

  /// شناسه ثابت دسته — برای sync و migration
  final String slug;

  final String iconName;
  final String nameFa;
  final String nameEn;
  final List<WordSeed> words;
  final CategoryType type;
  final bool isDefault;
  final bool isPremium;
  final bool isUnlockedByAd;
  final WordDifficulty difficulty;
}
