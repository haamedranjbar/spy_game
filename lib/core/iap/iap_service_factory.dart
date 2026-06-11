import 'package:spy_game/core/constants/app_market_config.dart';
import 'package:spy_game/core/iap/bazaar_iap_service.dart';
import 'package:spy_game/core/iap/google_iap_service.dart';
import 'package:spy_game/core/iap/iap_interface.dart';
import 'package:spy_game/core/iap/myket_iap_service.dart';
import 'package:spy_game/core/utils/app_logger.dart';

/// ساخت سرویس IAP بر اساس flavor بیلد — بدون تشخیص runtime
abstract final class IapServiceFactory {
  static Future<IapService> create() async {
    final service = switch (AppMarketConfig.market) {
      AppMarket.bazaar => BazaarIapService(),
      AppMarket.myket => MyketIapService(),
      AppMarket.google => GoogleIapService(),
    };

    appLogger.i(
      'IAP service for ${AppMarketConfig.marketLabel} (${AppMarketConfig.market.name})',
    );
    return service;
  }
}
