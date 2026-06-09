import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';

/// کارت ساخت دسته‌بندی سفارشی — رنگ فیروزه‌ای متمایز از قفل طلایی
class CreateCustomCard extends StatelessWidget {
  const CreateCustomCard({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  static const Color _accent = AppColors.accentCustomCategory;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      borderColor: _accent,
      backgroundColor: Color.lerp(AppColors.surface, _accent, 0.1)!,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(color: _accent, width: 1.5),
            ),
            child: const Icon(
              Icons.add,
              color: _accent,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'category.create_custom'.tr(),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: _accent,
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'category.create_custom_hint'.tr(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
