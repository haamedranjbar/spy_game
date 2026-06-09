import 'package:flutter/material.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';

/// کارت شمارنده (بازیکن / جاسوس) با آیکون + عنوان + عدد
class CounterCard extends StatelessWidget {
  const CounterCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.accentColor = AppColors.accentDefault,
    this.onIncrement,
    this.onDecrement,
    this.onTap,
    this.actionHint,
    this.minValue,
    this.maxValue,
  });

  final String title;
  final int value;
  final IconData icon;
  final Color accentColor;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onTap;
  final String? actionHint;
  final int? minValue;
  final int? maxValue;

  @override
  Widget build(BuildContext context) {
    final canDecrement = onDecrement != null &&
        (minValue == null || value > minValue!);
    final canIncrement = onIncrement != null &&
        (maxValue == null || value < maxValue!);

    return AppCard(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onTap != null)
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textMuted,
                  size: 22,
                ),
            ],
          ),
          const SizedBox(height: 12),
          // چینش ثابت: منها چپ، مثبت راست — مستقل از RTL
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CounterButton(
                  icon: Icons.remove,
                  onTap: canDecrement ? onDecrement : null,
                  color: accentColor,
                  visible: onDecrement != null,
                ),
                Text(
                  '$value',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                _CounterButton(
                  icon: Icons.add,
                  onTap: canIncrement ? onIncrement : null,
                  color: accentColor,
                  visible: onIncrement != null,
                ),
              ],
            ),
          ),
          if (actionHint != null) ...[
            const Spacer(),
            Text(
              actionHint!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
        ),
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.icon,
    required this.onTap,
    required this.color,
    this.visible = true,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox(width: 36, height: 36);
    }

    return Material(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            icon,
            color: onTap != null ? color : AppColors.textMuted,
            size: 20,
          ),
        ),
      ),
    );
  }
}
