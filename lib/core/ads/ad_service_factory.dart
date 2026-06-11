import 'package:spy_game/core/ads/ad_interface.dart';
import 'package:spy_game/core/ads/stub_ad_service.dart';

/// ساخت سرویس تبلیغات — فعلاً stub تا SDK فروشگاه‌ها اضافه شود
abstract final class AdServiceFactory {
  static Future<AdService> create() async {
    final service = StubAdService();
    await service.initialize();
    return service;
  }
}
