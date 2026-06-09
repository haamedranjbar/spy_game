/// تنظیمات پیش‌فرض بازی — مقادیر ثابت قابل تغییر از settings
abstract final class GameConfig {
  // محدوده بازیکنان
  static const int minPlayers = 3;
  static const int maxPlayers = 100;
  static const int defaultPlayerCount = 5;

  // جاسوس
  static const int minSpies = 1;
  static const int defaultSpyCount = 1;

  /// حداکثر تعداد جاسوس: یکی کمتر از نصف بازیکنان
  static int maxSpiesForPlayerCount(int playerCount) {
    if (playerCount <= 1) return minSpies;
    final halfFloor = playerCount ~/ 2;
    return (halfFloor - 1).clamp(minSpies, playerCount - 1);
  }

  // تایمر بحث (ثانیه)
  static const int defaultTimerSeconds = 300;
  static const int minTimerSeconds = 60;
  static const int maxTimerSeconds = 1800;

  // انیمیشن splash
  static const Duration splashDuration = Duration(seconds: 2);

  // نسخه دیتابیس برای migration
  static const int databaseVersion = 2;

  // تعداد دسته‌های رایگان
  static const int freeCategoryCount = 4;

  // حداقل کلمات برای دسته سفارشی
  static const int minCustomCategoryWords = 3;

  // نسخه بسته کلمات seed — با هر آپدیت محتوا افزایش یابد
  static const int wordSeedVersion = 1;
}
