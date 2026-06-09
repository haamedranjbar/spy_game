import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spy_game/data/models/word_category.dart';
import 'package:spy_game/presentation/providers/isar_provider.dart';

part 'category_provider.g.dart';

/// بارگذاری دسته‌های یک حالت (کلاسیک / خانوادگی)
@riverpod
Future<List<WordCategory>> categoriesByType(
  Ref ref,
  CategoryType type,
) async {
  try {
    final isar = await ref.watch(isarProvider.future);
    return isar.wordCategorys.filter().typeEqualTo(type).findAll();
  } catch (_) {
    return const [];
  }
}
