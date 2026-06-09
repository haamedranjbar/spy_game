import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';
import 'package:spy_game/presentation/widgets/pro_badge.dart';

/// کارت دسته‌بندی در grid دو ستونه
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.name,
    required this.wordCount,
    required this.onTap,
    this.isPremium = false,
    this.isUnlockedByAd = false,
    this.isCustom = false,
    this.isSelected = false,
    this.accentColor = AppColors.accentClassic,
    this.icon,
  });

  final String name;
  final int wordCount;
  final VoidCallback onTap;
  final bool isPremium;
  final bool isUnlockedByAd;
  final bool isCustom;
  final bool isSelected;
  final Color accentColor;
  final IconData? icon;

  static const Color _customAccent = AppColors.accentCustomCategory;

  @override
  Widget build(BuildContext context) {
    final effectiveAccent =
        isCustom ? _customAccent : accentColor;

    // قفل طلایی اولویت دارد؛ دسته شخصی فیروزه‌ای
    final borderColor = isPremium && !isUnlockedByAd
        ? AppColors.accentPremium
        : (isCustom ? _customAccent : null);

    final backgroundColor = isCustom
        ? Color.lerp(AppColors.surface, _customAccent, 0.1)
        : null;

    return AppCard(
      onTap: onTap,
      isSelected: isSelected,
      selectedGlowColor: effectiveAccent,
      borderColor: borderColor,
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null || isPremium) ...[
            // آیکن دسته و badge قفل در دو طرف — بدون هم‌پوشانی در RTL/LTR
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (icon != null)
                  Icon(icon, color: effectiveAccent, size: 28),
                const Spacer(),
                if (isPremium)
                  ProBadge(showPlayIcon: isUnlockedByAd, compact: true),
              ],
            ),
            const SizedBox(height: 8),
          ],
          Text(
            name,
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: effectiveAccent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'category.word_count'.tr(args: [wordCount.toString()]),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
