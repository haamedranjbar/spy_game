import 'package:flutter/material.dart';
import 'package:spy_game/core/constants/app_colors.dart';

/// فونت‌های محلی Vazirmatn — نسخه معمولی برای انگلیسی، FD برای فارسی و عربی
abstract final class AppFonts {
  /// اعداد لاتین — زبان انگلیسی
  static const String family = 'Vazirmatn';

  /// اعداد فارسی — زبان‌های فارسی و عربی
  static const String familyFd = 'Vazirmatn FD';

  /// انتخاب خانواده فونت بر اساس زبان فعال
  static String familyForLocale(Locale locale) {
    return switch (locale.languageCode) {
      'fa' || 'ar' => familyFd,
      _ => family,
    };
  }

  /// آیا زبان فعال به نسخه FD (اعداد فارسی) نیاز دارد؟
  static bool usesFdDigits(Locale locale) =>
      locale.languageCode == 'fa' || locale.languageCode == 'ar';

  /// اعمال فونت و رنگ‌های متن روی TextTheme پایه Material
  static TextTheme themed(TextTheme base, {required String fontFamily}) {
    return base.apply(
      fontFamily: fontFamily,
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );
  }
}
