import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:myket_iap/myket_iap.dart';
import 'package:myket_iap/util/constants.dart';
import 'package:myket_iap/util/iab_result.dart';
import 'package:myket_iap/util/inventory.dart';
import 'package:myket_iap/util/purchase.dart';
import 'package:myket_iap/util/sku_details.dart';
import 'package:spy_game/core/constants/game_config.dart';
import 'package:spy_game/core/constants/monetization_config.dart';
import 'package:spy_game/core/iap/iap_interface.dart';
import 'package:spy_game/core/utils/app_logger.dart';

/// پیاده‌سازی IAP مایکت — پکیج رسمی myket_iap
class MyketIapService implements IapService {
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    try {
      final result = await MyketIAP.init(
        rsaKey: MonetizationConfig.myketRsaPublicKey,
        enableDebugLogging: kDebugMode,
      );
      _initialized = result?.isSuccess() ?? false;
      if (_initialized) {
        appLogger.i('Myket IAP initialized');
      } else {
        appLogger.w('Myket IAP init failed: $result');
      }
    } catch (e, stackTrace) {
      appLogger.e('Myket IAP initialize error', e, stackTrace);
      _initialized = false;
    }
  }

  @override
  Future<bool> isAvailable() async => _initialized;

  @override
  Future<GoldenProductInfo?> getGoldenProduct() async {
    if (!_initialized) return null;

    try {
      final response = await MyketIAP.queryInventory(
        querySkuDetails: true,
        skus: [GameConfig.goldenProductIdMyket],
      );

      final iabResult = response[MyketIAP.RESULT] as IabResult?;
      final inventory = response[MyketIAP.INVENTORY] as Inventory?;

      if (iabResult == null || iabResult.isFailure()) {
        appLogger.w('Myket product query failed: $iabResult');
        return null;
      }

      final SkuDetails? sku =
          inventory?.mSkuMap[GameConfig.goldenProductIdMyket];
      if (sku == null) return null;

      return GoldenProductInfo(
        productId: sku.mSku,
        title: sku.mTitle,
        price: sku.mPrice,
        isAvailable: true,
      );
    } catch (e, stackTrace) {
      appLogger.e('Myket getGoldenProduct failed', e, stackTrace);
      return null;
    }
  }

  @override
  Future<IapPurchaseResult> purchaseGolden() async {
    // تلاش مجدد برای init — گاهی اولین بار بعد از نصب شکست می‌خورد
    if (!_initialized) {
      await initialize();
    }
    if (!_initialized) {
      appLogger.w('Myket purchase skipped: IAP not initialized');
      return IapPurchaseResult.unavailable;
    }

    try {
      appLogger.i(
        'Myket launchPurchaseFlow sku=${GameConfig.goldenProductIdMyket}',
      );

      final response = await MyketIAP.launchPurchaseFlow(
        sku: GameConfig.goldenProductIdMyket,
        payload: 'golden_edition',
      ).timeout(
        const Duration(minutes: 2),
        onTimeout: () {
          appLogger.w('Myket purchase flow timed out');
          throw TimeoutException('Myket purchase flow timed out');
        },
      );

      final iabResult = response[MyketIAP.RESULT] as IabResult?;
      final purchase = response[MyketIAP.PURCHASE] as Purchase?;

      appLogger.i('Myket purchase result: $iabResult, purchase: $purchase');

      return _mapPurchaseResult(iabResult, purchase);
    } on TimeoutException {
      return IapPurchaseResult.error;
    } catch (e, stackTrace) {
      appLogger.e('Myket purchase failed', e, stackTrace);
      return IapPurchaseResult.error;
    }
  }

  @override
  Future<IapPurchaseResult> restorePurchases() async {
    if (!_initialized) return IapPurchaseResult.unavailable;

    try {
      final owned = await _hasGoldenPurchase();
      return owned ? IapPurchaseResult.success : IapPurchaseResult.error;
    } catch (e, stackTrace) {
      appLogger.e('Myket restore failed', e, stackTrace);
      return IapPurchaseResult.error;
    }
  }

  /// بررسی مالکیت محصول طلایی — بدون consume
  Future<bool> _hasGoldenPurchase() async {
    final direct = await MyketIAP.getPurchase(
      sku: GameConfig.goldenProductIdMyket,
      querySkuDetails: false,
    );

    final directResult = direct[MyketIAP.RESULT] as IabResult?;
    final directPurchase = direct[MyketIAP.PURCHASE] as Purchase?;

    if (directResult?.isSuccess() == true && directPurchase != null) {
      return true;
    }

    final inventoryResponse = await MyketIAP.queryInventory(
      querySkuDetails: false,
      skus: [GameConfig.goldenProductIdMyket],
    );

    final inventoryResult =
        inventoryResponse[MyketIAP.RESULT] as IabResult?;
    final inventory =
        inventoryResponse[MyketIAP.INVENTORY] as Inventory?;

    if (inventoryResult?.isSuccess() != true || inventory == null) {
      return false;
    }

    return inventory.mPurchaseMap.containsKey(
      GameConfig.goldenProductIdMyket,
    );
  }

  IapPurchaseResult _mapPurchaseResult(
    IabResult? result,
    Purchase? purchase,
  ) {
    if (result == null) return IapPurchaseResult.error;

    if (result.isSuccess() && purchase != null) {
      return IapPurchaseResult.success;
    }

    if (result.mResponse == Constants.IABHELPER_SEND_INTENT_FAILED) {
      appLogger.w(
        'Myket SEND_INTENT_FAILED — مایکت نصب/لاگین نیست یا APK در پنل ثبت نشده',
      );
    }

    return switch (result.mResponse) {
      Constants.BILLING_RESPONSE_RESULT_USER_CANCELED ||
      Constants.IABHELPER_USER_CANCELLED =>
        IapPurchaseResult.cancelled,
      Constants.BILLING_RESPONSE_RESULT_BILLING_UNAVAILABLE ||
      Constants.BILLING_RESPONSE_RESULT_ITEM_UNAVAILABLE ||
      Constants.IABHELPER_SEND_INTENT_FAILED =>
        IapPurchaseResult.unavailable,
      Constants.BILLING_RESPONSE_RESULT_ITEM_ALREADY_OWNED =>
        IapPurchaseResult.success,
      _ => IapPurchaseResult.error,
    };
  }

  @override
  Future<void> dispose() async {
    try {
      await MyketIAP.dispose();
    } catch (e, stackTrace) {
      appLogger.w('Myket IAP dispose failed', e, stackTrace);
    }
    _initialized = false;
  }
}
