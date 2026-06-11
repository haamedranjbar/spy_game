import 'package:spy_game/core/constants/app_market_config.dart';
import 'package:spy_game/core/iap/bazaar_iap_service.dart';
import 'package:spy_game/core/iap/google_iap_service.dart';
import 'package:spy_game/core/iap/iap_interface.dart';
import 'package:spy_game/core/iap/myket_iap_service.dart';
import 'package:spy_game/core/utils/app_flavor_bridge.dart';
import 'package:spy_game/core/utils/app_logger.dart';

/// ساخت سرویس IAP بر اساس flavor بیلد اندروید
abstract final class IapServiceFactory {
  static Future<IapService> create() async {
    final market = await AppFlavorBridge.resolveMarket();

    final service = switch (market) {
      AppMarket.bazaar => BazaarIapService(),
      AppMarket.myket => MyketIapService(),
      AppMarket.google => GoogleIapService(),
    };

    appLogger.i(
      'IAP service for ${_marketLabel(market)} (${market.name})',
    );
    return service;
  }

  static String _marketLabel(AppMarket market) => switch (market) {
        AppMarket.bazaar => 'Cafe Bazaar',
        AppMarket.myket => 'Myket',
        AppMarket.google => 'Google Play',
      };
}
