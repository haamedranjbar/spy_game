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
    this.isSelected = false,
    this.accentColor = AppColors.accentClassic,
    this.icon,
  });

  final String name;
  final int wordCount;
  final VoidCallback onTap;
  final bool isPremium;
  final bool isUnlockedByAd;
  final bool isSelected;
  final Color accentColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final borderColor = isPremium && !isUnlockedByAd
        ? AppColors.accentPremium
        : null;

    return AppCard(
      onTap: onTap,
      isSelected: isSelected,
      selectedGlowColor: accentColor,
      borderColor: borderColor,
      padding: const EdgeInsets.all(14),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Icon(icon, color: accentColor, size: 28),
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
          if (isPremium)
            Positioned(
              top: 0,
              right: 0,
              child: ProBadge(showPlayIcon: isUnlockedByAd, compact: true),
            ),
        ],
      ),
    );
  }
}
