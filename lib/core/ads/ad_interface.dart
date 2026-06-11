/// نتیجه نمایش تبلیغ
enum AdShowResult {
  completed,
  skipped,
  unavailable,
  error,
}

/// قرارداد مشترک تبلیغات — بین‌دوری و پاداش‌دار
abstract interface class AdService {
  /// راه‌اندازی SDK تبلیغات
  Future<void> initialize();

  /// آیا تبلیغ بین‌دوری آماده است؟
  bool get isInterstitialReady;

  /// آیا ویدیو پاداش‌دار آماده است؟
  bool get isRewardedReady;

  /// نمایش تبلیغ بین‌دوری (بعد از هر دور)
  Future<AdShowResult> showInterstitial();

  /// نمایش ویدیو پاداش‌دار (باز کردن دسته)
  Future<AdShowResult> showRewarded();

  /// آزادسازی منابع
  void dispose();
}
