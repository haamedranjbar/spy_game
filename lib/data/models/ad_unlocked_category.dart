import 'package:isar_community/isar.dart';

part 'ad_unlocked_category.g.dart';

/// دسته‌ای که با تماشای ویدیو باز شده
@collection
class AdUnlockedCategory {
  Id id = Isar.autoIncrement;

  /// شناسه ثابت دسته
  @Index(unique: true, replace: true)
  late String categorySlug;

  /// زمان باز شدن
  late DateTime unlockedAt;
}
