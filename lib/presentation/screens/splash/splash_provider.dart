import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spy_game/core/constants/game_config.dart';
import 'package:spy_game/data/datasources/isar_datasource.dart';

part 'splash_provider.g.dart';

/// وضعیت splash
enum SplashStatus {
  loading,
  ready,
  error,
}

/// State مدیریت splash — init دیتابیس و تایمر
class SplashState {
  const SplashState({
    required this.status,
    this.errorMessage,
  });

  final SplashStatus status;
  final String? errorMessage;

  SplashState copyWith({
    SplashStatus? status,
    String? errorMessage,
  }) {
    return SplashState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@riverpod
class SplashNotifier extends _$SplashNotifier {
  @override
  SplashState build() {
    _initialize();
    return const SplashState(status: SplashStatus.loading);
  }

  /// راه‌اندازی دیتابیس و انتظار برای انیمیشن splash
  Future<void> _initialize() async {
    try {
      await Future.wait([
        IsarDatasource.open(),
        Future<void>.delayed(GameConfig.splashDuration),
      ]);

      if (!ref.mounted) return;
      state = const SplashState(status: SplashStatus.ready);
    } catch (e) {
      if (!ref.mounted) return;
      state = SplashState(
        status: SplashStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  /// تلاش مجدد در صورت خطا
  Future<void> retry() async {
    state = const SplashState(status: SplashStatus.loading);
    await _initialize();
  }
}
