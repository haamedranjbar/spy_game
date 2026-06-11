import 'package:flutter/services.dart';
import 'package:spy_game/core/constants/game_config.dart';
import 'package:spy_game/core/iap/iap_interface.dart';
import 'package:spy_game/core/utils/app_logger.dart';

/// پیاده‌سازی IAP برای کافه‌بازار — از MethodChannel استفاده می‌کند
class BazaarIapService implements IapService {
  static const _channel = MethodChannel('ir.hamed.spygame/bazaar_iap');

  @override
  Future<void> initialize() async {
    try {
      await _channel.invokeMethod<void>('initialize');
    } catch (e, stackTrace) {
      appLogger.w('Bazaar IAP initialize failed (stub OK in dev)', e, stackTrace);
    }
  }

  @override
  Future<bool> isAvailable() async {
    try {
      final available = await _channel.invokeMethod<bool>('isAvailable');
      return available ?? false;
    } catch (e, stackTrace) {
      appLogger.w('Bazaar IAP availability check failed', e, stackTrace);
      return false;
    }
  }

  @override
  Future<GoldenProductInfo?> getGoldenProduct() async {
    try {
      if (!await isAvailable()) return null;

      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'getProduct',
        {'productId': GameConfig.goldenProductIdBazaar},
      );
      if (result == null) return null;

      return GoldenProductInfo(
        productId: result['productId'] as String? ?? GameConfig.goldenProductIdBazaar,
        title: result['title'] as String? ?? '',
        price: result['price'] as String? ?? '',
        isAvailable: result['isAvailable'] as bool? ?? false,
      );
    } catch (e, stackTrace) {
      appLogger.w('Bazaar IAP product query failed', e, stackTrace);
      return null;
    }
  }

  @override
  Future<IapPurchaseResult> purchaseGolden() async {
    try {
      if (!await isAvailable()) return IapPurchaseResult.unavailable;

      final result = await _channel.invokeMethod<String>(
        'purchase',
        {'productId': GameConfig.goldenProductIdBazaar},
      );

      return _mapResult(result);
    } catch (e, stackTrace) {
      appLogger.e('Bazaar IAP purchase failed', e, stackTrace);
      return IapPurchaseResult.error;
    }
  }

  @override
  Future<IapPurchaseResult> restorePurchases() async {
    try {
      if (!await isAvailable()) return IapPurchaseResult.unavailable;

      final result = await _channel.invokeMethod<String>('restore');
      return _mapResult(result);
    } catch (e, stackTrace) {
      appLogger.e('Bazaar IAP restore failed', e, stackTrace);
      return IapPurchaseResult.error;
    }
  }

  IapPurchaseResult _mapResult(String? value) {
    return switch (value) {
      'success' => IapPurchaseResult.success,
      'cancelled' => IapPurchaseResult.cancelled,
      'pending' => IapPurchaseResult.pending,
      'unavailable' => IapPurchaseResult.unavailable,
      _ => IapPurchaseResult.error,
    };
  }

  @override
  void dispose() {}
}
