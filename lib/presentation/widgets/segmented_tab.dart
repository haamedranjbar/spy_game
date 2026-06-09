import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spy_game/core/constants/app_colors.dart';

/// تب Classic / Family Mode
class SegmentedTab extends StatelessWidget {
  const SegmentedTab({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    this.classicLabelKey = 'mode.classic',
    this.familyLabelKey = 'mode.family',
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final String classicLabelKey;
  final String familyLabelKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentItem(
              label: classicLabelKey.tr(),
              isSelected: selectedIndex == 0,
              accentColor: AppColors.accentClassic,
              onTap: () => onChanged(0),
            ),
          ),
          Expanded(
            child: _SegmentItem(
              label: familyLabelKey.tr(),
              isSelected: selectedIndex == 1,
              accentColor: AppColors.accentFamily,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentItem extends StatelessWidget {
  const _SegmentItem({
    required this.label,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: accentColor, width: 1.5)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: isSelected ? accentColor : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
        ),
      ),
    );
  }
}
