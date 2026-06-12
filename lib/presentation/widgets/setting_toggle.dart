import 'package:flutter/material.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';

/// کارت تنظیمات قابل تاگل — همان glow انتخاب کارت دسته
class SettingToggle extends StatelessWidget {
  const SettingToggle({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.icon,
    this.accentColor = AppColors.accentDefault,
    this.enabled = true,
    this.compact = false,
    this.compactTopInset = 0,
    this.expand = false,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData? icon;
  final Color accentColor;
  final bool enabled;
  /// چیدمان عمودی فشرده — برای کارت‌های کنار هم
  final bool compact;
  /// فضای بالای کارت فشرده برای آیکن‌های گوشه
  final double compactTopInset;
  /// پر کردن ارتفاع والد — برای کارت‌های نقش ویژه
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final isActive = value && enabled;

    final card = Opacity(
      opacity: enabled ? 1 : 0.72,
      child: AppCard(
        onTap: enabled ? () => onChanged(!value) : null,
        isSelected: isActive,
        selectedGlowColor: accentColor,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 16,
          vertical: compact ? 10 : 12,
        ),
        child: compact
            ? _buildCompactContent(context, isActive)
            : _buildRowContent(context, isActive),
      ),
    );

    if (!expand) return card;

    // پر کردن کامل محدوده والد — برای کارت‌های مربع نقش ویژه
    return SizedBox.expand(child: card);
  }

  Widget _buildCompactContent(BuildContext context, bool isActive) {
    return Padding(
      padding: EdgeInsets.only(top: compactTopInset),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: isActive
                  ? accentColor
                  : (enabled ? AppColors.textSecondary : AppColors.textMuted),
              size: 26,
            ),
            const SizedBox(height: 8),
          ],
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isActive ? AppColors.textPrimary : AppColors.textMuted,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  height: 1.2,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowContent(BuildContext context, bool isActive) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: isActive
                ? accentColor
                : (enabled ? AppColors.textSecondary : AppColors.textMuted),
            size: 22,
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isActive
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                      fontWeight:
                          isActive ? FontWeight.w700 : FontWeight.w500,
                    ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
