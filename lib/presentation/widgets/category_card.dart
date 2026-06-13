import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';
import 'package:spy_game/presentation/widgets/pro_badge.dart';

/// کارت دسته‌بندی در grid سه ستونه
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.name,
    required this.wordCount,
    required this.onTap,
    this.isPremium = false,
    this.isLocked = false,
    this.showPlayIcon = false,
    this.isCustom = false,
    this.isSelected = false,
    this.accentColor = AppColors.accentClassic,
    this.icon,
  });

  final String name;
  final int wordCount;
  final VoidCallback onTap;
  final bool isPremium;
  final bool isLocked;
  final bool showPlayIcon;
  final bool isCustom;
  final bool isSelected;
  final Color accentColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      isSelected: isSelected,
      selectedGlowColor: accentColor,
      borderColor: isLocked ? AppColors.accentPremium : null,
      backgroundColor:
          isLocked ? AppColors.premiumLockedBackground() : null,
      accentTint: isLocked ? null : accentColor,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCustom || icon != null || isPremium) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isCustom)
                  const Icon(
                    Icons.folder_special_outlined,
                    color: AppColors.accentCustomCategory,
                    size: 22,
                  )
                else if (icon != null)
                  Icon(icon, color: accentColor, size: 22),
                const Spacer(),
                if (isPremium)
                  ProBadge(showPlayIcon: showPlayIcon, compact: true),
              ],
            ),
            const SizedBox(height: 8),
          ],
          Text(
            name,
            style: Theme.of(context).textTheme.titleSmall,
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
                  color: accentColor,
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
