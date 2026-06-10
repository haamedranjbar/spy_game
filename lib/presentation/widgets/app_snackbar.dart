import 'package:flutter/material.dart';
import 'package:spy_game/core/constants/app_colors.dart';

/// نوع پیام — رنگ و آیکون متناسب با UX
enum AppSnackBarType {
  info,
  success,
  warning,
  error,
}

/// نوتیف جمع‌وجور، عرض متناسب محتوا و رنگ‌بندی بر اساس نوع پیام
abstract final class AppSnackBar {
  static const Duration _duration = Duration(milliseconds: 2400);
  static const double _horizontalPadding = 32;
  static const double _iconSize = 16;
  static const double _iconGap = 8;
  static const double _screenSideMargin = 48;

  static void show(
    BuildContext context,
    String message, {
    AppSnackBarType type = AppSnackBarType.info,
  }) {
    final theme = Theme.of(context);
    final palette = _palette(type);
    final textStyle = theme.snackBarTheme.contentTextStyle?.copyWith(
      color: palette.text,
      fontWeight: FontWeight.w600,
    );
    final screenWidth = MediaQuery.sizeOf(context).width;
    final maxTextWidth = screenWidth -
        _screenSideMargin -
        _horizontalPadding -
        _iconSize -
        _iconGap;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          margin: const EdgeInsets.only(bottom: 20),
          clipBehavior: Clip.none,
          shape: const RoundedRectangleBorder(),
          duration: _duration,
          content: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: palette.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: palette.border),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      palette.icon,
                      size: _iconSize,
                      color: palette.iconColor,
                    ),
                    const SizedBox(width: _iconGap),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxTextWidth),
                      child: Text(
                        message,
                        style: textStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }

  static void info(BuildContext context, String message) =>
      show(context, message, type: AppSnackBarType.info);

  static void success(BuildContext context, String message) =>
      show(context, message, type: AppSnackBarType.success);

  static void warning(BuildContext context, String message) =>
      show(context, message, type: AppSnackBarType.warning);

  static void error(BuildContext context, String message) =>
      show(context, message, type: AppSnackBarType.error);

  static _SnackPalette _palette(AppSnackBarType type) => switch (type) {
        AppSnackBarType.info => _SnackPalette(
              background:
                  Color.lerp(AppColors.surface, AppColors.accentDefault, 0.1)!,
              border: AppColors.accentDefault.withValues(alpha: 0.4),
              iconColor: AppColors.accentDefault,
              text: AppColors.textPrimary,
              icon: Icons.info_outline_rounded,
            ),
        AppSnackBarType.success => _SnackPalette(
              background: Color.lerp(
                AppColors.surface,
                AppColors.accentCustomCategory,
                0.12,
              )!,
              border: AppColors.accentCustomCategory.withValues(alpha: 0.4),
              iconColor: AppColors.accentCustomCategory,
              text: AppColors.textPrimary,
              icon: Icons.check_circle_outline_rounded,
            ),
        AppSnackBarType.warning => _SnackPalette(
              background:
                  Color.lerp(AppColors.surface, AppColors.accentPremium, 0.12)!,
              border: AppColors.accentPremium.withValues(alpha: 0.45),
              iconColor: AppColors.accentPremium,
              text: AppColors.textPrimary,
              icon: Icons.warning_amber_rounded,
            ),
        AppSnackBarType.error => _SnackPalette(
              background:
                  Color.lerp(AppColors.surface, AppColors.accentDanger, 0.12)!,
              border: AppColors.accentDanger.withValues(alpha: 0.45),
              iconColor: AppColors.accentDanger,
              text: AppColors.textPrimary,
              icon: Icons.error_outline_rounded,
            ),
      };
}

class _SnackPalette {
  const _SnackPalette({
    required this.background,
    required this.border,
    required this.iconColor,
    required this.text,
    required this.icon,
  });

  final Color background;
  final Color border;
  final Color iconColor;
  final Color text;
  final IconData icon;
}
