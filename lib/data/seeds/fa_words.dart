import 'package:spy_game/data/seeds/category_seed.dart';
import 'package:spy_game/data/seeds/fa_words_ad.dart';
import 'package:spy_game/data/seeds/fa_words_free.dart';
import 'package:spy_game/data/seeds/fa_words_premium.dart';
import 'package:spy_game/data/seeds/fa_words_premium_culture.dart';
import 'package:spy_game/data/seeds/fa_words_premium_life.dart';
import 'package:spy_game/data/seeds/fa_words_premium_more.dart';

export 'package:spy_game/data/seeds/category_seed.dart';

/// همه دسته‌های seed فارسی — رایگان، ویدیو، طلایی
final List<CategorySeed> allFaCategorySeeds = [
  ...faFreeCategorySeeds,
  ...faAdCategorySeeds,
  ...faPremiumCategorySeeds,
  ...faPremiumMoreCategorySeeds,
  ...faPremiumLifeCategorySeeds,
  ...faPremiumCultureCategorySeeds,
];

/// دسته‌های رایگان (سازگاری با کد قبلی)
final List<CategorySeed> faFreeCategorySeedsExport = faFreeCategorySeeds;
