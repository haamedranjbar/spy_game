import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/core/router/router.dart';
import 'package:spy_game/data/models/word_category.dart';
import 'package:spy_game/presentation/providers/monetization_provider.dart';
import 'package:spy_game/presentation/widgets/app_snackbar.dart';
import 'package:spy_game/presentation/widgets/gradient_button.dart';
import 'package:spy_game/presentation/widgets/outlined_action_button.dart';

/// bottom sheet باز کردن دسته قفل — ویدیو یا خرید طلایی
Future<void> showPremiumUnlockSheet({
  required BuildContext context,
  required WidgetRef ref,
  required WordCategory category,
  VoidCallback? onUnlocked,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return _PremiumUnlockSheet(
        category: category,
        onUnlocked: onUnlocked,
      );
    },
  );
}

class _PremiumUnlockSheet extends ConsumerWidget {
  const _PremiumUnlockSheet({
    required this.category,
    this.onUnlocked,
  });

  final WordCategory category;
  final VoidCallback? onUnlocked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monetization = ref.watch(monetizationProvider);
    final notifier = ref.read(monetizationProvider.notifier);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Icon(
              category.isUnlockedByAd
                  ? Icons.play_circle_outline
                  : Icons.lock_outline,
              color: AppColors.accentPremium,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              category.isUnlockedByAd
                  ? 'iap.unlock_sheet_ad_title'.tr()
                  : 'iap.unlock_sheet_premium_title'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              category.isUnlockedByAd
                  ? 'iap.unlock_sheet_ad_hint'.tr()
                  : 'iap.unlock_sheet_premium_hint'.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (category.isUnlockedByAd) ...[
              GradientButton(
                label: 'iap.watch_video'.tr(),
                icon: Icons.play_arrow_rounded,
                gradientColors: AppColors.gradientGold,
                isLoading: monetization.isUnlockingCategory,
                onPressed: monetization.isUnlockingCategory
                    ? null
                    : () async {
                        final unlocked = await notifier.unlockCategoryWithVideo(
                          category.slug,
                        );
                        if (!context.mounted) return;
                        if (unlocked) {
                          Navigator.of(context).pop();
                          onUnlocked?.call();
                          AppSnackBar.success(
                            context,
                            'iap.category_unlocked'.tr(),
                          );
                        } else {
                          AppSnackBar.error(
                            context,
                            'iap.video_failed'.tr(),
                          );
                        }
                      },
              ),
              const SizedBox(height: 12),
            ],
            OutlinedActionButton(
              label: 'iap.buy_golden'.tr(),
              icon: Icons.workspace_premium_outlined,
              color: AppColors.accentPremium,
              onPressed: () {
                Navigator.of(context).pop();
                context.push(AppRoutes.iap);
              },
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('common.cancel'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
