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
    this.minValue,
    this.maxValue,
  });

  final String title;
  final int value;
  final IconData icon;
  final Color accentColor;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final int? minValue;
  final int? maxValue;

  @override
  Widget build(BuildContext context) {
    final canDecrement = onDecrement != null &&
        (minValue == null || value > minValue!);
    final canIncrement = onIncrement != null &&
        (maxValue == null || value < maxValue!);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (onDecrement != null)
                _CounterButton(
                  icon: Icons.remove,
                  onTap: canDecrement ? onDecrement : null,
                  color: accentColor,
                )
              else
                const SizedBox(width: 36),
              Text(
                '$value',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              if (onIncrement != null)
                _CounterButton(
                  icon: Icons.add,
                  onTap: canIncrement ? onIncrement : null,
                  color: accentColor,
                )
              else
                const SizedBox(width: 36),
            ],
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
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
