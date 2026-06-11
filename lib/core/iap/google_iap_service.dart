import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:spy_game/core/constants/game_config.dart';
import 'package:spy_game/core/iap/iap_interface.dart';
import 'package:spy_game/core/utils/app_logger.dart';

/// پیاده‌سازی IAP برای Google Play
class GoogleIapService implements IapService {
  GoogleIapService() : _iap = InAppPurchase.instance;

  final InAppPurchase _iap;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  Completer<IapPurchaseResult>? _purchaseCompleter;

  @override
  Future<void> initialize() async {
    try {
      _subscription ??= _iap.purchaseStream.listen(
        _onPurchaseUpdate,
        onError: (Object error, StackTrace stackTrace) {
          appLogger.e('Google IAP purchase stream error', error, stackTrace);
          _completePurchase(IapPurchaseResult.error);
        },
      );
    } catch (e, stackTrace) {
      appLogger.e('Failed to initialize Google IAP', e, stackTrace);
    }
  }

  @override
  Future<bool> isAvailable() async {
    try {
      return await _iap.isAvailable();
    } catch (e, stackTrace) {
      appLogger.e('Google IAP availability check failed', e, stackTrace);
      return false;
    }
  }

  @override
  Future<GoldenProductInfo?> getGoldenProduct() async {
    try {
      if (!await isAvailable()) return null;

      final response = await _iap.queryProductDetails(
        {GameConfig.goldenProductIdGoogle},
      );

      if (response.error != null) {
        appLogger.w('Google IAP product query error: ${response.error}');
        return null;
      }

      if (response.productDetails.isEmpty) return null;

      final product = response.productDetails.first;
      return GoldenProductInfo(
        productId: product.id,
        title: product.title,
        price: product.price,
        isAvailable: true,
      );
    } catch (e, stackTrace) {
      appLogger.e('Failed to query Google IAP product', e, stackTrace);
      return null;
    }
  }

  @override
  Future<IapPurchaseResult> purchaseGolden() async {
    try {
      if (!await isAvailable()) return IapPurchaseResult.unavailable;

      final product = await getGoldenProduct();
      if (product == null) return IapPurchaseResult.unavailable;

      _purchaseCompleter = Completer<IapPurchaseResult>();

      final response = await _iap.queryProductDetails(
        {GameConfig.goldenProductIdGoogle},
      );
      if (response.productDetails.isEmpty) {
        return IapPurchaseResult.unavailable;
      }

      final purchaseParam = PurchaseParam(
        productDetails: response.productDetails.first,
      );
      final started = await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      if (!started) {
        _purchaseCompleter = null;
        return IapPurchaseResult.error;
      }

      return _purchaseCompleter!.future.timeout(
        const Duration(minutes: 2),
        onTimeout: () {
          _purchaseCompleter = null;
          return IapPurchaseResult.error;
        },
      );
    } catch (e, stackTrace) {
      appLogger.e('Google IAP purchase failed', e, stackTrace);
      _purchaseCompleter = null;
      return IapPurchaseResult.error;
    }
  }

  @override
  Future<IapPurchaseResult> restorePurchases() async {
    try {
      if (!await isAvailable()) return IapPurchaseResult.unavailable;

      _purchaseCompleter = Completer<IapPurchaseResult>();
      await _iap.restorePurchases();

      return _purchaseCompleter!.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          _purchaseCompleter = null;
          return IapPurchaseResult.error;
        },
      );
    } catch (e, stackTrace) {
      appLogger.e('Google IAP restore failed', e, stackTrace);
      _purchaseCompleter = null;
      return IapPurchaseResult.error;
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.productID != GameConfig.goldenProductIdGoogle) continue;

      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _completePurchase(IapPurchaseResult.success);
          if (purchase.pendingCompletePurchase) {
            _iap.completePurchase(purchase);
          }
        case PurchaseStatus.pending:
          _completePurchase(IapPurchaseResult.pending);
        case PurchaseStatus.error:
          appLogger.w('Google IAP purchase error: ${purchase.error}');
          _completePurchase(IapPurchaseResult.error);
        case PurchaseStatus.canceled:
          _completePurchase(IapPurchaseResult.cancelled);
      }
    }
  }

  void _completePurchase(IapPurchaseResult result) {
    final completer = _purchaseCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.complete(result);
    }
    _purchaseCompleter = null;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _purchaseCompleter = null;
  }
}
