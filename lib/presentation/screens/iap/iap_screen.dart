import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/core/iap/iap_interface.dart';
import 'package:spy_game/presentation/providers/monetization_provider.dart';
import 'package:spy_game/presentation/screens/iap/iap_provider.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';
import 'package:spy_game/presentation/widgets/app_snackbar.dart';
import 'package:spy_game/presentation/widgets/gradient_button.dart';
import 'package:spy_game/presentation/widgets/outlined_action_button.dart';
import 'package:spy_game/presentation/widgets/pro_badge.dart';

/// صفحه خرید نسخه طلایی
class IapScreen extends ConsumerWidget {
  const IapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monetization = ref.watch(monetizationProvider);
    final iapNotifier = ref.read(iapProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('iap.title'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: monetization.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.accentPremium),
              )
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    AppCard(
                      borderColor: AppColors.accentPremium,
                      child: Column(
                        children: [
                          const Icon(
                            Icons.workspace_premium,
                            color: AppColors.accentPremium,
                            size: 64,
                          ),
                          const SizedBox(height: 12),
                          const ProBadge(),
                          const SizedBox(height: 16),
                          Text(
                            'iap.golden_title'.tr(),
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            monetization.isGoldenUser
                                ? 'iap.already_golden'.tr()
                                : 'iap.golden_description'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                          if (!monetization.isGoldenUser &&
                              monetization.productPrice.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              monetization.productPrice,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: AppColors.accentPremium),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        children: [
                          _FeatureRow(
                            icon: Icons.category_outlined,
                            text: 'iap.feature_categories'.tr(),
                          ),
                          _FeatureRow(
                            icon: Icons.search_outlined,
                            text: 'iap.feature_detective'.tr(),
                          ),
                          _FeatureRow(
                            icon: Icons.theater_comedy_outlined,
                            text: 'iap.feature_infiltrator'.tr(),
                          ),
                          _FeatureRow(
                            icon: Icons.block_outlined,
                            text: 'iap.feature_no_ads'.tr(),
                          ),
                        ],
                      ),
                    ),
                    if (!monetization.isGoldenUser) ...[
                      GradientButton(
                        label: monetization.isProductAvailable
                            ? 'iap.buy_now'.tr()
                            : 'iap.buy_unavailable'.tr(),
                        icon: Icons.shopping_bag_outlined,
                        gradientColors: AppColors.gradientGold,
                        enabled: monetization.isProductAvailable,
                        isLoading: monetization.isPurchasing,
                        onPressed: monetization.isProductAvailable
                            ? () => _handlePurchase(
                                  context,
                                  ref,
                                  iapNotifier,
                                )
                            : null,
                      ),
                      const SizedBox(height: 12),
                      OutlinedActionButton(
                        label: monetization.isRestoring
                            ? 'iap.restoring'.tr()
                            : 'iap.restore'.tr(),
                        icon: Icons.restore,
                        color: AppColors.accentPremium,
                        onPressed: monetization.isRestoring
                            ? null
                            : () => _handleRestore(context, ref, iapNotifier),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _handlePurchase(
    BuildContext context,
    WidgetRef ref,
    IapNotifier notifier,
  ) async {
    final result = await notifier.purchase();
    if (!context.mounted) return;
    _showResultSnackBar(context, result);
  }

  Future<void> _handleRestore(
    BuildContext context,
    WidgetRef ref,
    IapNotifier notifier,
  ) async {
    final result = await notifier.restore();
    if (!context.mounted) return;
    _showResultSnackBar(context, result);
  }

  void _showResultSnackBar(BuildContext context, IapPurchaseResult result) {
    final message = switch (result) {
      IapPurchaseResult.success => 'iap.purchase_success'.tr(),
      IapPurchaseResult.cancelled => 'iap.purchase_cancelled'.tr(),
      IapPurchaseResult.pending => 'iap.purchase_pending'.tr(),
      IapPurchaseResult.unavailable => 'iap.purchase_unavailable'.tr(),
      IapPurchaseResult.error => 'iap.purchase_error'.tr(),
    };

    if (result == IapPurchaseResult.success) {
      AppSnackBar.success(context, message);
    } else if (result == IapPurchaseResult.cancelled) {
      AppSnackBar.info(context, message);
    } else {
      AppSnackBar.error(context, message);
    }
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accentPremium, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
