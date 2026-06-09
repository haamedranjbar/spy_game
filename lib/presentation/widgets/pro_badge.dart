import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spy_game/core/constants/app_colors.dart';

/// badge قفل + متن PRO برای دسته‌های پولی
class ProBadge extends StatelessWidget {
  const ProBadge({
    super.key,
    this.showPlayIcon = false,
    this.compact = false,
  });

  /// نمایش آیکون play برای دسته‌های باز شده با ویدیو
  final bool showPlayIcon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentPremium.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.accentPremium),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            showPlayIcon ? Icons.play_circle_outline : Icons.lock_outline,
            size: compact ? 12 : 14,
            color: AppColors.accentPremium,
          ),
          if (!compact) ...[
            const SizedBox(width: 4),
            Text(
              'badge.pro'.tr(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.accentPremium,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
