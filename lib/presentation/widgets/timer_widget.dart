import 'package:flutter/material.dart';
import 'package:spy_game/core/constants/app_colors.dart';

/// ویجت نمایش تایمر شمارش معکوس
class TimerWidget extends StatelessWidget {
  const TimerWidget({
    super.key,
    required this.remainingSeconds,
    this.totalSeconds,
    this.accentColor = AppColors.accentDefault,
    this.size = TimerSize.large,
  });

  final int remainingSeconds;
  final int? totalSeconds;
  final Color accentColor;
  final TimerSize size;

  @override
  Widget build(BuildContext context) {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    final timeText =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    final progress = totalSeconds != null && totalSeconds! > 0
        ? remainingSeconds / totalSeconds!
        : null;

    final fontSize = switch (size) {
      TimerSize.small => 28.0,
      TimerSize.medium => 42.0,
      TimerSize.large => 60.0,
    };

    final ringSize = switch (size) {
      TimerSize.small => 100.0,
      TimerSize.medium => 160.0,
      TimerSize.large => 220.0,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: ringSize,
          height: ringSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (progress != null)
                SizedBox(
                  width: ringSize,
                  height: ringSize,
                  child: CircularProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    strokeWidth: size == TimerSize.large ? 20 : 14,
                    strokeCap: StrokeCap.round,
                    backgroundColor: AppColors.surfaceLight,
                    color: _progressColor(progress),
                  ),
                ),
              Text(
                timeText,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// رنگ پیشرفت بر اساس زمان باقی‌مانده
  Color _progressColor(double progress) {
    if (progress > 0.5) return accentColor;
    if (progress > 0.2) return AppColors.accentPremium;
    return AppColors.accentDanger;
  }
}

enum TimerSize { small, medium, large }
