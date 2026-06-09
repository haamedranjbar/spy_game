import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/presentation/providers/settings_provider.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';
import 'package:spy_game/presentation/widgets/setting_toggle.dart';

/// صفحه تنظیمات — زبان، صدا، ویبره، تایمر پیش‌فرض
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const List<int> _timerPresets = [180, 300, 420, 600];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('settings.title'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: settings.isLoaded
            ? ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    'settings.language'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  _LanguageSelector(
                    currentLocale: context.locale,
                    onChanged: (locale) => context.setLocale(locale),
                  ),
                  const SizedBox(height: 24),
                  SettingToggle(
                    title: 'settings.sound'.tr(),
                    icon: Icons.volume_up_outlined,
                    value: settings.soundEnabled,
                    onChanged: notifier.setSoundEnabled,
                  ),
                  const SizedBox(height: 12),
                  SettingToggle(
                    title: 'settings.vibration'.tr(),
                    icon: Icons.vibration,
                    value: settings.vibrationEnabled,
                    onChanged: notifier.setVibrationEnabled,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'settings.default_timer'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ..._timerPresets.map(
                    (seconds) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _TimerPresetCard(
                        seconds: seconds,
                        isSelected: settings.defaultTimerSeconds == seconds,
                        onTap: () => notifier.setDefaultTimerSeconds(seconds),
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: AppColors.accentDefault,
                ),
              ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({
    required this.currentLocale,
    required this.onChanged,
  });

  final Locale currentLocale;
  final ValueChanged<Locale> onChanged;

  @override
  Widget build(BuildContext context) {
    // عناوین زبان همیشه ثابت — وابسته به locale فعلی نیستند
    const locales = [
      (Locale('fa'), 'فارسی'),
      (Locale('en'), 'English'),
      (Locale('ar'), 'العربية'),
    ];

    // چینش فیزیکی ثابت از راست: فارسی | English | العربية
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Row(
        children: [
          for (var i = 0; i < locales.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(
              child: AppCard(
                onTap: () => onChanged(locales[i].$1),
                borderColor: currentLocale.languageCode ==
                        locales[i].$1.languageCode
                    ? AppColors.accentDefault
                    : null,
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  locales[i].$2,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: currentLocale.languageCode ==
                                locales[i].$1.languageCode
                            ? AppColors.accentDefault
                            : AppColors.textPrimary,
                        fontWeight: currentLocale.languageCode ==
                                locales[i].$1.languageCode
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TimerPresetCard extends StatelessWidget {
  const _TimerPresetCard({
    required this.seconds,
    required this.isSelected,
    required this.onTap,
  });

  final int seconds;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final minutes = seconds ~/ 60;
    return AppCard(
      onTap: onTap,
      borderColor: isSelected ? AppColors.accentDefault : null,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(
            Icons.timer_outlined,
            color: isSelected
                ? AppColors.accentDefault
                : AppColors.textSecondary,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'settings.timer_minutes'.tr(args: [minutes.toString()]),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isSelected
                        ? AppColors.accentDefault
                        : AppColors.textPrimary,
                  ),
            ),
          ),
          if (isSelected)
            const Icon(
              Icons.check_circle,
              color: AppColors.accentDefault,
              size: 22,
            ),
        ],
      ),
    );
  }
}
