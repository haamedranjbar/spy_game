import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/presentation/widgets/setting_toggle.dart';

/// بنر صورتی Family Mode با toggle تصاویر رنگی
class FamilyModeBanner extends StatelessWidget {
  const FamilyModeBanner({
    super.key,
    required this.showColorImages,
    required this.onShowColorImagesChanged,
  });

  final bool showColorImages;
  final ValueChanged<bool> onShowColorImagesChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.gradientFamily
              .map((c) => c.withValues(alpha: 0.25))
              .toList(),
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accentFamily.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.family_restroom,
                color: AppColors.accentFamily,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'mode.family_title'.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.accentFamily,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'mode.family_description'.tr(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          SettingToggle(
            title: 'mode.show_color_images'.tr(),
            value: showColorImages,
            onChanged: onShowColorImagesChanged,
            accentColor: AppColors.accentFamily,
            icon: Icons.palette_outlined,
          ),
        ],
      ),
    );
  }
}
