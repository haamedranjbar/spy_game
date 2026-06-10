import 'package:flutter/material.dart';
import 'package:spy_game/core/constants/app_colors.dart';

/// دکمه Add/Remove با outline
class OutlinedActionButton extends StatelessWidget {
  const OutlinedActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.color,
    this.icon,
    this.expanded = true,
    this.iconOnly = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final IconData? icon;
  final bool expanded;
  final bool iconOnly;

  @override
  Widget build(BuildContext context) {
    // دکمه فقط آیکون — هم‌ارتفاع با دکمه‌های اصلی
    if (iconOnly) {
      assert(icon != null, 'iconOnly requires an icon');
      return SizedBox(
        width: 52,
        height: 52,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            side: BorderSide(color: color),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Icon(icon, size: 22),
        ),
      );
    }

    final button = OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Row(
        mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );

    if (expanded) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}

/// دکمه Add با رنگ بنفش پیش‌فرض
class AddActionButton extends StatelessWidget {
  const AddActionButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedActionButton(
      label: label,
      onPressed: onPressed,
      color: AppColors.accentDefault,
      icon: Icons.add,
    );
  }
}

/// دکمه Remove با رنگ قرمز
class RemoveActionButton extends StatelessWidget {
  const RemoveActionButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedActionButton(
      label: label,
      onPressed: onPressed,
      color: AppColors.accentDanger,
      icon: Icons.remove,
    );
  }
}
