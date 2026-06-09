import 'package:spy_game/data/models/word.dart';
import 'package:spy_game/data/models/word_category.dart';

/// ساختار seed برای یک دسته و کلماتش
class CategorySeed {
  const CategorySeed({
    required this.slug,
    required this.iconName,
    required this.nameFa,
    required this.nameEn,
    required this.words,
    this.type = CategoryType.classic,
    this.isDefault = true,
    this.isPremium = false,
    this.isUnlockedByAd = false,
    this.difficulty = WordDifficulty.medium,
  });

  /// شناسه ثابت دسته — برای sync و migration
  final String slug;

  final String iconName;
  final String nameFa;
  final String nameEn;
  final List<String> words;
  final CategoryType type;
  final bool isDefault;
  final bool isPremium;
  final bool isUnlockedByAd;
  final WordDifficulty difficulty;
}
