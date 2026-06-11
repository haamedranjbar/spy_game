/// نتیجه خرید درون‌برنامه‌ای
enum IapPurchaseResult {
  success,
  cancelled,
  pending,
  unavailable,
  error,
}

/// وضعیت محصول طلایی
class GoldenProductInfo {
  const GoldenProductInfo({
    required this.productId,
    required this.title,
    required this.price,
    required this.isAvailable,
  });

  final String productId;
  final String title;
  final String price;
  final bool isAvailable;
}

/// قرارداد مشترک IAP — همه فروشگاه‌ها از این interface استفاده می‌کنند
abstract interface class IapService {
  /// راه‌اندازی اتصال به فروشگاه
  Future<void> initialize();

  /// آیا خرید در این فروشگاه فعال است؟
  Future<bool> isAvailable();

  /// اطلاعات محصول طلایی
  Future<GoldenProductInfo?> getGoldenProduct();

  /// شروع خرید نسخه طلایی
  Future<IapPurchaseResult> purchaseGolden();

  /// بازیابی خریدهای قبلی
  Future<IapPurchaseResult> restorePurchases();

  /// آزادسازی منابع
  void dispose();
}
