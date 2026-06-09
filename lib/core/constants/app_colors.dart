import 'package:flutter/material.dart';

/// پالت رنگی ثابت اپ — هیچ رنگ hardcode در UI مجاز نیست
abstract final class AppColors {
  // پس‌زمینه و سطح‌ها
  static const Color background = Color(0xFF0A0E1A);
  static const Color surface = Color(0xFF141B2D);
  static const Color surfaceLight = Color(0xFF1E293B);
  static const Color cardBorder = Color(0xFF2A3548);

  // رنگ‌های اصلی تم (طبق قوانین پروژه)
  static const Color primaryRed = Color(0xFFE53935);
  static const Color primaryBlue = Color(0xFF1E88E5);

  // Accent بر اساس context
  static const Color accentDefault = Color(0xFF8B5CF6);
  static const Color accentClassic = Color(0xFF60A5FA);
  static const Color accentFamily = Color(0xFFEC4899);
  static const Color accentPremium = Color(0xFFD4AF37);

  /// پس‌زمینه ملایم دسته‌های قفل‌دار — لایه طلایی شفاف روی سطح تیره
  static Color premiumLockedBackground([Color base = surface]) =>
      Color.lerp(base, accentPremium, 0.1)!;
  /// ساخت دسته سفارشی — متمایز از طلایی قفل پریمیوم
  static const Color accentCustomCategory = Color(0xFF2DD4BF);
  static const Color accentDanger = Color(0xFFEF4444);

  // متن
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // سوئیچ و انتخاب
  static const Color switchActive = accentDefault;
  static const Color selectedGlow = Color(0x668B5CF6);

  // گرادیان دکمه Start
  static const List<Color> gradientPurple = [
    Color(0xFF7C3AED),
    Color(0xFF8B5CF6),
    Color(0xFFA78BFA),
  ];

  // گرادیان Family
  static const List<Color> gradientFamily = [
    Color(0xFFDB2777),
    Color(0xFFEC4899),
    Color(0xFFF472B6),
  ];

  // سایه و overlay
  static const Color overlay = Color(0x80000000);
  static const Color divider = Color(0xFF334155);
}
