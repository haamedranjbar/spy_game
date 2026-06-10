import 'package:flutter/material.dart';
import 'package:spy_game/core/constants/app_colors.dart';

/// دکمه تمام‌عرض با گرادیان بنفش (یا سفارشی)
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.gradientColors = AppColors.gradientPurple,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
    this.height = 52,
  });

  final String label;
  final VoidCallback? onPressed;
  final List<Color> gradientColors;
  final IconData? icon;
  final bool isLoading;
  final bool enabled;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isActive = enabled && !isLoading && onPressed != null;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isActive
                ? gradientColors
                : gradientColors.map((c) => c.withValues(alpha: 0.4)).toList(),
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: gradientColors.first.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isActive ? onPressed : null,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.textPrimary,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: AppColors.textPrimary, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          label,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
