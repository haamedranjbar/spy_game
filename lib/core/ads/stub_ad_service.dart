import 'package:spy_game/core/ads/ad_interface.dart';
import 'package:spy_game/core/utils/app_logger.dart';

/// پیاده‌سازی تستی تبلیغات — تا اتصال SDK واقعی فروشگاه‌ها
class StubAdService implements AdService {
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    _initialized = true;
    appLogger.i('Stub ad service initialized');
  }

  @override
  bool get isInterstitialReady => _initialized;

  @override
  bool get isRewardedReady => _initialized;

  @override
  Future<AdShowResult> showInterstitial() async {
    if (!_initialized) return AdShowResult.unavailable;

    // شبیه‌سازی نمایش تبلیغ بین‌دوری
    await Future<void>.delayed(const Duration(seconds: 1));
    appLogger.i('Stub interstitial ad completed');
    return AdShowResult.completed;
  }

  @override
  Future<AdShowResult> showRewarded() async {
    if (!_initialized) return AdShowResult.unavailable;

    // شبیه‌سازی تماشای ویدیو پاداش‌دار
    await Future<void>.delayed(const Duration(seconds: 2));
    appLogger.i('Stub rewarded ad completed');
    return AdShowResult.completed;
  }

  @override
  void dispose() {
    _initialized = false;
  }
}
