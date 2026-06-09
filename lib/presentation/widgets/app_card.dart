import 'package:flutter/material.dart';
import 'package:spy_game/core/constants/app_colors.dart';

/// کارت تیره با border و radius — پایه Design System
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderColor,
    this.backgroundColor,
    this.borderRadius = 16,
    this.onTap,
    this.isSelected = false,
    this.selectedGlowColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final Color? backgroundColor;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool isSelected;
  final Color? selectedGlowColor;

  @override
  Widget build(BuildContext context) {
    final glowColor = selectedGlowColor ?? AppColors.accentDefault;
    final baseBackground = backgroundColor ?? AppColors.surface;

    final effectiveBorderColor = isSelected
        ? glowColor
        : (borderColor ?? AppColors.cardBorder);

    // پس‌زمینه کمرنگ هنگام انتخاب — ترکیب subtle با رنگ accent همان تب
    final effectiveBackground = isSelected
        ? Color.lerp(baseBackground, glowColor, 0.11)!
        : baseBackground;

    final card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveBackground,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: effectiveBorderColor,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.28),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: card,
        ),
      );
    }

    return card;
  }
}
