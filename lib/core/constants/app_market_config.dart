/// فروشگاه‌های پشتیبانی‌شده — هر بیلد فقط یکی را فعال می‌کند
enum AppMarket {
  google,
  bazaar,
  myket,
}

/// تشخیص فروشگاه از زمان کامپایل — با flavor و dart-define
///
/// بیلد:
/// - `flutter build apk --flavor bazaar --dart-define=APP_MARKET=bazaar`
/// - `flutter build apk --flavor myket --dart-define=APP_MARKET=myket`
/// - `flutter build apk --flavor google --dart-define=APP_MARKET=google`
abstract final class AppMarketConfig {
  static const String _raw = String.fromEnvironment(
    'APP_MARKET',
    defaultValue: 'google',
  );

  /// فروشگاه این بیلد
  static AppMarket get market => switch (_raw) {
        'bazaar' => AppMarket.bazaar,
        'myket' => AppMarket.myket,
        _ => AppMarket.google,
      };

  /// نام نمایشی برای لاگ و دیباگ
  static String get marketLabel => switch (market) {
        AppMarket.bazaar => 'Cafe Bazaar',
        AppMarket.myket => 'Myket',
        AppMarket.google => 'Google Play',
      };
}
