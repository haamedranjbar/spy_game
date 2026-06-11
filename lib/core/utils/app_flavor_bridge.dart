import 'package:flutter/services.dart';
import 'package:spy_game/core/constants/app_market_config.dart';
import 'package:spy_game/core/utils/app_logger.dart';

/// خواندن flavor اندروید — جلوگیری از ناهماهنگی با dart-define
abstract final class AppFlavorBridge {
  static const _channel = MethodChannel('ir.hamed.spygame/app');

  static AppMarket? _cached;

  /// فروشگاه واقعی این APK — اولویت با BuildConfig.FLAVOR
  static Future<AppMarket> resolveMarket() async {
    if (_cached != null) return _cached!;

    try {
      final flavor = await _channel.invokeMethod<String>('getFlavor');
      if (flavor != null && flavor.isNotEmpty) {
        _cached = switch (flavor) {
          'myket' => AppMarket.myket,
          'bazaar' => AppMarket.bazaar,
          'google' => AppMarket.google,
          _ => AppMarketConfig.marketFromDartDefine,
        };
        appLogger.i('Market from Android flavor: $flavor → $_cached');
        return _cached!;
      }
    } catch (e, stackTrace) {
      appLogger.w('Flavor bridge failed, using dart-define', e, stackTrace);
    }

    _cached = AppMarketConfig.marketFromDartDefine;
    return _cached!;
  }

  /// آیا اپ فروشگاه مربوط به این بیلد روی دستگاه نصب است؟
  static Future<bool> isStoreAppInstalled(AppMarket market) async {
    final method = switch (market) {
      AppMarket.myket => 'isMyketInstalled',
      AppMarket.bazaar => 'isBazaarInstalled',
      AppMarket.google => null,
    };
    if (method == null) return true;

    try {
      final installed = await _channel.invokeMethod<bool>(method);
      return installed ?? false;
    } catch (e, stackTrace) {
      appLogger.w('Store install check failed for $market', e, stackTrace);
      return false;
    }
  }
}
