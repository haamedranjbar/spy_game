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
    final effectiveBorderColor = isSelected
        ? (selectedGlowColor ?? AppColors.accentDefault)
        : (borderColor ?? AppColors.cardBorder);

    final card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: effectiveBorderColor,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: (selectedGlowColor ?? AppColors.accentDefault)
                      .withValues(alpha: 0.35),
                  blurRadius: 12,
                  spreadRadius: 1,
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
