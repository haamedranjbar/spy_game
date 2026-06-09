import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spy_game/core/constants/game_config.dart';
import 'package:spy_game/core/utils/app_logger.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';

part 'settings_provider.g.dart';

/// کلیدهای ذخیره تنظیمات در SharedPreferences
abstract final class SettingsKeys {
  static const String soundEnabled = 'settings_sound_enabled';
  static const String vibrationEnabled = 'settings_vibration_enabled';
  static const String defaultTimerSeconds = 'settings_default_timer_seconds';
}

/// تنظیمات اپلیکیشن — صدا، ویبره، تایمر پیش‌فرض
class AppSettings {
  const AppSettings({
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.defaultTimerSeconds = GameConfig.defaultTimerSeconds,
    this.isLoaded = false,
  });

  final bool soundEnabled;
  final bool vibrationEnabled;
  final int defaultTimerSeconds;
  final bool isLoaded;

  AppSettings copyWith({
    bool? soundEnabled,
    bool? vibrationEnabled,
    int? defaultTimerSeconds,
    bool? isLoaded,
  }) {
    return AppSettings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      defaultTimerSeconds: defaultTimerSeconds ?? this.defaultTimerSeconds,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  @override
  AppSettings build() {
    _loadSettings();
    return const AppSettings();
  }

  /// بارگذاری تنظیمات از SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timer = prefs.getInt(SettingsKeys.defaultTimerSeconds) ??
          GameConfig.defaultTimerSeconds;

      if (!ref.mounted) return;
      state = AppSettings(
        soundEnabled: prefs.getBool(SettingsKeys.soundEnabled) ?? true,
        vibrationEnabled: prefs.getBool(SettingsKeys.vibrationEnabled) ?? true,
        defaultTimerSeconds: timer.clamp(
          GameConfig.minTimerSeconds,
          GameConfig.maxTimerSeconds,
        ),
        isLoaded: true,
      );

      // اعمال تایمر پیش‌فرض روی بازی در فاز setup
      final game = ref.read(gameProvider);
      if (game.phase == GamePhase.setup) {
        ref.read(gameProvider.notifier).setTimerSeconds(state.defaultTimerSeconds);
      }
    } catch (e, stackTrace) {
      appLogger.e('Failed to load settings', e, stackTrace);
      if (ref.mounted) {
        state = state.copyWith(isLoaded: true);
      }
    }
  }

  Future<void> _saveBool(String key, bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);
    } catch (e, stackTrace) {
      appLogger.e('Failed to save setting $key', e, stackTrace);
    }
  }

  Future<void> _saveInt(String key, int value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(key, value);
    } catch (e, stackTrace) {
      appLogger.e('Failed to save setting $key', e, stackTrace);
    }
  }

  /// تغییر وضعیت صدا
  Future<void> setSoundEnabled(bool value) async {
    state = state.copyWith(soundEnabled: value);
    await _saveBool(SettingsKeys.soundEnabled, value);
  }

  /// تغییر وضعیت ویبره
  Future<void> setVibrationEnabled(bool value) async {
    state = state.copyWith(vibrationEnabled: value);
    await _saveBool(SettingsKeys.vibrationEnabled, value);
  }

  /// تغییر تایمر پیش‌فرض (ثانیه)
  Future<void> setDefaultTimerSeconds(int seconds) async {
    final clamped = seconds.clamp(
      GameConfig.minTimerSeconds,
      GameConfig.maxTimerSeconds,
    );
    state = state.copyWith(defaultTimerSeconds: clamped);
    await _saveInt(SettingsKeys.defaultTimerSeconds, clamped);

    final game = ref.read(gameProvider);
    if (game.phase == GamePhase.setup) {
      ref.read(gameProvider.notifier).setTimerSeconds(clamped);
    }
  }
}
