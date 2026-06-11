import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spy_game/core/ads/ad_interface.dart';
import 'package:spy_game/core/ads/ad_service_factory.dart';
import 'package:spy_game/core/iap/iap_interface.dart';
import 'package:spy_game/core/iap/iap_service_factory.dart';
import 'package:spy_game/core/utils/app_logger.dart';
import 'package:spy_game/core/utils/category_access.dart';
import 'package:spy_game/data/models/word_category.dart';
import 'package:spy_game/data/repositories/monetization_repository.dart';
import 'package:spy_game/presentation/providers/isar_provider.dart';

part 'monetization_provider.g.dart';

/// وضعیت درآمدزایی اپ
class MonetizationState {
  const MonetizationState({
    this.isGoldenUser = false,
    this.adUnlockedSlugs = const {},
    this.productTitle = '',
    this.productPrice = '',
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
      _iapService = await IapServiceFactory.create();
      _adService = await AdServiceFactory.create();

      await _iapService!.initialize();

      final isar = await ref.read(isarProvider.future);
      final purchaseState = await _repository.getPurchaseState(isar: isar);
      final adUnlocked = await _repository.getAdUnlockedSlugs(isar: isar);
      final product = await _iapService!.getGoldenProduct();

      if (ref.mounted) {
        state = state.copyWith(
          isGoldenUser: purchaseState.isGoldenUser,
          adUnlockedSlugs: adUnlocked,
          productTitle: product?.title ?? '',
          productPrice: product?.price ?? '',
          isProductAvailable: product?.isAvailable ?? false,
          isLoading: false,
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

  /// باز کردن دسته با تماشای ویدیو
  Future<bool> unlockCategoryWithVideo(String categorySlug) async {
    final ad = _adService;
    if (ad == null) return false;

    state = state.copyWith(isUnlockingCategory: true);
    try {
      final result = await ad.showRewarded();
      if (result != AdShowResult.completed) return false;

      final isar = await ref.read(isarProvider.future);
      final saved = await _repository.unlockCategoryByAd(
        isar: isar,
        categorySlug: categorySlug,
      );

      if (saved && ref.mounted) {
        state = state.copyWith(
          adUnlockedSlugs: {...state.adUnlockedSlugs, categorySlug},
        );
      }
      return saved;
    } catch (e, stackTrace) {
      appLogger.e('Unlock category with video failed', e, stackTrace);
      return false;
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isUnlockingCategory: false);
      }
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
