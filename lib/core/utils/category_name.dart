import 'package:flutter/material.dart';
import 'package:spy_game/data/models/word_category.dart';

/// نام نمایشی دسته بر اساس زبان فعلی
String localizedCategoryName(WordCategory category, Locale locale) {
  return switch (locale.languageCode) {
    'en' => category.nameEn,
    'ar' => category.nameEn,
    _ => category.name,
  };
}
