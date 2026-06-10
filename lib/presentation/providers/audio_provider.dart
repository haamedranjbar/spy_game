import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spy_game/presentation/providers/settings_provider.dart';

part 'audio_provider.g.dart';

/// سرویس صدا و ویبره — احترام به تنظیمات کاربر
class AudioService {
  const AudioService(this._ref);

  final Ref _ref;

  AppSettings get _settings => _ref.read(settingsProvider);

  /// آیا موسیقی پس‌زمینه فعال است؟
  bool get isMusicEnabled => _settings.musicEnabled;

  /// بازخورد صوتی کلیک / اکشن
  void playTap() {
    if (!_settings.soundEnabled) return;
    SystemSound.play(SystemSoundType.click);
  }

  /// صدای پایان تایمر
  void playTimerEnd() {
    if (!_settings.soundEnabled) return;
    SystemSound.play(SystemSoundType.alert);
  }

  /// بازخورد ثبت رای
  void playVote() {
    if (!_settings.soundEnabled) return;
    SystemSound.play(SystemSoundType.click);
  }

  /// بازخورد نمایش نقش
  void playReveal() {
    if (!_settings.soundEnabled) return;
    SystemSound.play(SystemSoundType.click);
  }

  /// ویبره سبک
  void vibrateLight() {
    if (!_settings.vibrationEnabled) return;
    HapticFeedback.lightImpact();
  }

  /// ویبره متوسط — پایان تایمر
  void vibrateMedium() {
    if (!_settings.vibrationEnabled) return;
    HapticFeedback.mediumImpact();
  }

  /// ویبره سنگین — نتیجه بازی
  void vibrateHeavy() {
    if (!_settings.vibrationEnabled) return;
    HapticFeedback.heavyImpact();
  }
}

@Riverpod(keepAlive: true)
AudioService audioService(Ref ref) {
  return AudioService(ref);
}
