import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spy_game/core/ads/ad_interface.dart';
import 'package:spy_game/core/ads/ad_service_factory.dart';
import 'package:spy_game/core/constants/app_market_config.dart';
import 'package:spy_game/core/constants/game_config.dart';
import 'package:spy_game/core/iap/iap_interface.dart';
import 'package:spy_game/core/iap/iap_service_factory.dart';
import 'package:spy_game/core/utils/app_flavor_bridge.dart';
import 'package:spy_game/core/utils/app_logger.dart';
import 'package:spy_game/core/utils/category_access.dart';
import 'package:spy_game/data/models/word_category.dart';
import 'package:spy_game/data/repositories/monetization_repository.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';
import 'package:spy_game/presentation/providers/isar_provider.dart';

part 'monetization_provider.g.dart';

/// وضعیت درآمدزایی اپ
class MonetizationState {
  const MonetizationState({
    this.isGoldenUser = false,
    this.adUnlockedSlugs = const {},
    this.productTitle = '',
    this.productPrice = '',
    this.activeMarket = AppMarket.google,
    this.isIapReady = false,
    this.isStoreAppInstalled = true,
    this.isProductAvailable = false,
    this.isLoading = true,
    this.isPurchasing = false,
    this.isRestoring = false,
    this.isShowingAd = false,
    this.isUnlockingCategory = false,
  });

  final bool isGoldenUser;
  final Set<String> adUnlockedSlugs;
  final String productTitle;
  final String productPrice;
  final AppMarket activeMarket;
  final bool isIapReady;
  final bool isStoreAppInstalled;
  final bool isProductAvailable;
  final bool isLoading;
  final bool isPurchasing;
  final bool isRestoring;
  final bool isShowingAd;
  final bool isUnlockingCategory;

  MonetizationState copyWith({
    bool? isGoldenUser,
    Set<String>? adUnlockedSlugs,
    String? productTitle,
    String? productPrice,
    AppMarket? activeMarket,
    bool? isIapReady,
    bool? isStoreAppInstalled,
    bool? isProductAvailable,
    bool? isLoading,
    bool? isPurchasing,
    bool? isRestoring,
    bool? isShowingAd,
    bool? isUnlockingCategory,
  }) {
    return MonetizationState(
      isGoldenUser: isGoldenUser ?? this.isGoldenUser,
      adUnlockedSlugs: adUnlockedSlugs ?? this.adUnlockedSlugs,
      productTitle: productTitle ?? this.productTitle,
      productPrice: productPrice ?? this.productPrice,
      activeMarket: activeMarket ?? this.activeMarket,
      isIapReady: isIapReady ?? this.isIapReady,
      isStoreAppInstalled: isStoreAppInstalled ?? this.isStoreAppInstalled,
      isProductAvailable: isProductAvailable ?? this.isProductAvailable,
      isLoading: isLoading ?? this.isLoading,
      isPurchasing: isPurchasing ?? this.isPurchasing,
      isRestoring: isRestoring ?? this.isRestoring,
      isShowingAd: isShowingAd ?? this.isShowingAd,
      isUnlockingCategory: isUnlockingCategory ?? this.isUnlockingCategory,
    );
  }
}

@Riverpod(keepAlive: true)
class MonetizationNotifier extends _$MonetizationNotifier {
  final MonetizationRepository _repository = const MonetizationRepository();
  IapService? _iapService;
  AdService? _adService;

  @override
  MonetizationState build() {
    ref.onDispose(() {
      _iapService?.dispose();
      _adService?.dispose();
    });

    _initialize();
    return const MonetizationState();
  }

  Future<void> _initialize() async {
    try {
      final market = await AppFlavorBridge.resolveMarket();
      final storeInstalled = await AppFlavorBridge.isStoreAppInstalled(market);

      _iapService = await IapServiceFactory.create();
      _adService = await AdServiceFactory.create();

      await _iapService!.initialize();

      final isar = await ref.read(isarProvider.future);
      final purchaseState = await _repository.getPurchaseState(isar: isar);
      // unlock ویدیو دیگر persist نمی‌شود — داده قدیمی را پاک کن
      await _repository.clearAdUnlockedCategories(isar: isar);
      final iapReady = await _iapService!.isAvailable();
      final product = await _iapService!.getGoldenProduct();
      final canPurchase = _canPurchase(
        market: market,
        iapReady: iapReady,
        storeInstalled: storeInstalled,
      );

      if (ref.mounted) {
        state = state.copyWith(
          isGoldenUser: purchaseState.isGoldenUser,
          adUnlockedSlugs: const {},
          productTitle: product?.title ?? '',
          productPrice: product?.price ?? '',
          activeMarket: market,
          isIapReady: iapReady,
          isStoreAppInstalled: storeInstalled,
          isProductAvailable: canPurchase,
          isLoading: false,
        );
      }

      if (!storeInstalled && market != AppMarket.google) {
        appLogger.w('Store app not installed for $market');
      } else if (!iapReady) {
        appLogger.w('IAP billing not ready — check store app install/login');
      } else if (product == null) {
        appLogger.w(
          'IAP ready but product details missing — purchase may still work',
        );
      }

      // بازیابی خودکار اگر محلی طلایی نیست
      if (!purchaseState.isGoldenUser) {
        await _trySilentRestore();
      }
    } catch (e, stackTrace) {
      appLogger.e('Monetization init failed', e, stackTrace);
      if (ref.mounted) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  /// آیا دکمه خرید باید فعال باشد؟
  bool _canPurchase({
    required AppMarket market,
    required bool iapReady,
    required bool storeInstalled,
  }) {
    return switch (market) {
      // مایکت: اجازه تلاش خرید حتی بدون قیمت — intent از سمت مایکت باز می‌شود
      AppMarket.myket => storeInstalled,
      AppMarket.bazaar => iapReady && storeInstalled,
      AppMarket.google => iapReady,
    };
  }

  /// آیا دسته قفل است؟
  bool isCategoryLocked(WordCategory category) {
    return CategoryAccess.isLocked(
      category: category,
      isGoldenUser: state.isGoldenUser,
      adUnlockedSlugs: state.adUnlockedSlugs,
    );
  }

  /// آیا دسته با ویدیو باز شده؟
  bool isCategoryUnlockedByVideo(WordCategory category) {
    return CategoryAccess.isUnlockedByVideo(
      category: category,
      isGoldenUser: state.isGoldenUser,
      adUnlockedSlugs: state.adUnlockedSlugs,
    );
  }

  /// خرید نسخه طلایی
  Future<IapPurchaseResult> purchaseGolden() async {
    final iap = _iapService;
    if (iap == null) return IapPurchaseResult.unavailable;

    state = state.copyWith(isPurchasing: true);
    try {
      final result = await iap.purchaseGolden();
      if (result == IapPurchaseResult.success) {
        await _activateGolden();
      }
      return result;
    } catch (e, stackTrace) {
      appLogger.e('Purchase golden failed', e, stackTrace);
      return IapPurchaseResult.error;
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isPurchasing: false);
      }
    }
  }

  /// بازیابی خرید
  Future<IapPurchaseResult> restorePurchases() async {
    final iap = _iapService;
    if (iap == null) return IapPurchaseResult.unavailable;

    state = state.copyWith(isRestoring: true);
    try {
      final result = await iap.restorePurchases();
      if (result == IapPurchaseResult.success) {
        await _activateGolden();
      }
      return result;
    } catch (e, stackTrace) {
      appLogger.e('Restore purchases failed', e, stackTrace);
      return IapPurchaseResult.error;
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isRestoring: false);
      }
    }
  }

  /// بازیابی بی‌صدا در شروع — بدون نمایش لودینگ
  Future<void> _trySilentRestore() async {
    final iap = _iapService;
    if (iap == null) return;

    try {
      final result = await iap.restorePurchases();
      if (result == IapPurchaseResult.success) {
        await _activateGolden();
      }
    } catch (e, stackTrace) {
      appLogger.w('Silent restore failed', e, stackTrace);
    }
  }

  Future<void> _activateGolden() async {
    try {
      final isar = await ref.read(isarProvider.future);
      await _repository.setGoldenUser(isar: isar);
      if (ref.mounted) {
        state = state.copyWith(isGoldenUser: true);
      }
    } catch (e, stackTrace) {
      appLogger.e('Activate golden failed', e, stackTrace);
    }
  }

  /// باز کردن دسته با تماشای ویدیو — فقط تا پایان دور جاری
  Future<bool> unlockCategoryWithVideo(String categorySlug) async {
    if (!GameConfig.videoUnlockCategorySlugs.contains(categorySlug)) {
      return false;
    }

    final ad = _adService;
    if (ad == null) return false;

    state = state.copyWith(isUnlockingCategory: true);
    try {
      final result = await ad.showRewarded();
      if (result != AdShowResult.completed) return false;

      if (ref.mounted) {
        state = state.copyWith(
          adUnlockedSlugs: {...state.adUnlockedSlugs, categorySlug},
        );
      }
      return true;
    } catch (e, stackTrace) {
      appLogger.e('Unlock category with video failed', e, stackTrace);
      return false;
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isUnlockingCategory: false);
      }
    }
  }

  /// پایان دور — قفل مجدد دسته‌های باز شده با ویدیو
  void resetVideoUnlocksAfterRound() {
    if (state.isGoldenUser || state.adUnlockedSlugs.isEmpty) return;

    state = state.copyWith(adUnlockedSlugs: const {});

    final game = ref.read(gameProvider);
    // فقط قبل از شروع بازی — دسته‌های قفل‌شده را از انتخاب حذف کن
    if (game.phase == GamePhase.setup) {
      Future.microtask(pruneLockedCategoriesFromSelection);
    }
  }

  /// حذف دسته‌های قفل از انتخاب — هنگام بازگشت به صفحه دسته‌بندی‌ها
  Future<void> pruneLockedCategoriesFromSelection() async {
    if (state.isGoldenUser) return;

    final game = ref.read(gameProvider);
    if (game.selectedCategoryIds.isEmpty) return;

    try {
      final isar = await ref.read(isarProvider.future);
      final gameNotifier = ref.read(gameProvider.notifier);

      for (final id in List<int>.from(game.selectedCategoryIds)) {
        final category = await isar.wordCategorys.get(id);
        if (category != null && isCategoryLocked(category)) {
          gameNotifier.removeCategoryFromSelection(id);
        }
      }
    } catch (e, stackTrace) {
      appLogger.e('Prune locked categories failed', e, stackTrace);
    }
  }

  /// نمایش تبلیغ بین‌دوری — فقط برای کاربران غیرطلایی
  Future<void> showInterstitialIfNeeded() async {
    if (state.isGoldenUser) return;

    final ad = _adService;
    if (ad == null || !ad.isInterstitialReady) return;

    state = state.copyWith(isShowingAd: true);
    try {
      await ad.showInterstitial();
    } catch (e, stackTrace) {
      appLogger.e('Show interstitial failed', e, stackTrace);
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isShowingAd: false);
      }
    }
  }
}
