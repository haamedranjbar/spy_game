import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/presentation/providers/settings_provider.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';

/// صفحه تنظیمات — زبان، صدا، تایمر و تعداد بازیکن پیش‌فرض
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const List<int> _timerPresets = [180, 300, 420, 600, 900];
  static const List<int> _playerCountPresets = [3, 4, 5, 6, 8];

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
                  Text(
                    'settings.audio_section'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _AudioSettingCard(
                          title: 'settings.sound_effects'.tr(),
                          icon: Icons.graphic_eq_rounded,
                          accentColor: AppColors.accentDefault,
                          isEnabled: settings.soundEnabled,
                          onTap: () => notifier.setSoundEnabled(
                            !settings.soundEnabled,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _AudioSettingCard(
                          title: 'settings.music'.tr(),
                          icon: Icons.music_note_outlined,
                          accentColor: AppColors.accentClassic,
                          isEnabled: settings.musicEnabled,
                          onTap: () => notifier.setMusicEnabled(
                            !settings.musicEnabled,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _AudioSettingCard(
                          title: 'settings.vibration'.tr(),
                          icon: Icons.vibration,
                          accentColor: AppColors.accentPremium,
                          isEnabled: settings.vibrationEnabled,
                          onTap: () => notifier.setVibrationEnabled(
                            !settings.vibrationEnabled,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'settings.default_timer'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  _SquarePresetRow(
                    itemCount: _timerPresets.length,
                    itemBuilder: (index) {
                      final seconds = _timerPresets[index];
                      final minutes = seconds ~/ 60;
                      return _SquarePresetCard(
                        isSelected: settings.defaultTimerSeconds == seconds,
                        onTap: () => notifier.setDefaultTimerSeconds(seconds),
                        value: minutes.toString(),
                        label: 'settings.minutes_short'.tr(),
                        accentColor: AppColors.accentDefault,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'settings.default_player_count'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  _SquarePresetRow(
                    itemCount: _playerCountPresets.length,
                    itemBuilder: (index) {
                      final count = _playerCountPresets[index];
                      return _SquarePresetCard(
                        isSelected: settings.defaultPlayerCount == count,
                        onTap: () => notifier.setDefaultPlayerCount(count),
                        value: count.toString(),
                        label: 'settings.players_short'.tr(),
                        accentColor: AppColors.accentClassic,
                      );
                    },
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

  static String _flagForLanguage(String languageCode) => switch (languageCode) {
        'fa' => '🇮🇷',
        'en' => '🇬🇧',
        'ar' => '🇮🇶',
        _ => '🌐',
      };

  @override
  Widget build(BuildContext context) {
    const locales = [
      (Locale('fa'), 'فارسی'),
      (Locale('en'), 'English'),
      (Locale('ar'), 'العربية'),
    ];

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // پرچم با فونت سیستمی — Vazirmatn ایموجی را خراب می‌کند
                    Text(
                      _flagForLanguage(locales[i].$1.languageCode),
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        locales[i].$2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
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
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// کارت روشن/خاموش تنظیمات صوتی — شبیه کارت دسته
class _AudioSettingCard extends StatelessWidget {
  const _AudioSettingCard({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.isEnabled,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color accentColor;
  final bool isEnabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: AppCard(
        onTap: onTap,
        isSelected: isEnabled,
        selectedGlowColor: accentColor,
        backgroundColor: isEnabled
            ? null
            : AppColors.surface,
        borderColor: isEnabled ? accentColor : AppColors.cardBorder,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isEnabled ? accentColor : AppColors.textMuted,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isEnabled
                        ? AppColors.textPrimary
                        : AppColors.textMuted,
                    fontWeight:
                        isEnabled ? FontWeight.w700 : FontWeight.w500,
                    height: 1.25,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ردیف پنج‌تایی کادرهای مربعی
class _SquarePresetRow extends StatelessWidget {
  const _SquarePresetRow({
    required this.itemCount,
    required this.itemBuilder,
  });

  final int itemCount;
  final Widget Function(int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < itemCount; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(child: itemBuilder(i)),
        ],
      ],
    );
  }
}

/// کادر مربعی انتخاب مقدار — تایمر یا تعداد بازیکن
class _SquarePresetCard extends StatelessWidget {
  const _SquarePresetCard({
    required this.isSelected,
    required this.onTap,
    required this.value,
    required this.label,
    required this.accentColor,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final String value;
  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: AppCard(
        onTap: onTap,
        isSelected: isSelected,
        selectedGlowColor: accentColor,
        borderColor: isSelected ? accentColor : AppColors.cardBorder,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isSelected
                            ? accentColor
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isSelected
                            ? AppColors.textPrimary
                            : AppColors.textMuted,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        height: 1.1,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
