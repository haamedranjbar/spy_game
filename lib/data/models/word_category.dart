import 'package:isar_community/isar.dart';

part 'word_category.g.dart';

/// نوع دسته‌بندی — کلاسیک یا خانوادگی
enum CategoryType {
  classic,
  family,
}

/// دسته‌بندی کلمات بازی
@collection
class WordCategory {
  Id id = Isar.autoIncrement;

  /// شناسه ثابت برای seed و آپدیت‌های بعدی
  @Index(unique: true, replace: true)
  late String slug;

  /// نام فارسی دسته
  late String name;

  /// نام انگلیسی دسته
  late String nameEn;

  /// حالت کلاسیک یا خانوادگی
  @enumerated
  late CategoryType type;

  /// دسته پیش‌فرض اپ (غیرقابل حذف)
  late bool isDefault;

  /// فقط برای کاربران طلایی
  late bool isPremium;

  /// قابل باز شدن با تماشای ویدیو
  late bool isUnlockedByAd;

  /// تعداد کلمات ذخیره‌شده در این دسته
  late int wordCount;

  /// نام آیکون (Material Icons)
  late String iconName;
}
