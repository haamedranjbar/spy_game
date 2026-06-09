import 'package:isar_community/isar.dart';

part 'word.g.dart';

/// سطح دشواری کلمه
enum WordDifficulty {
  easy,
  medium,
  hard,
}

/// یک کلمه در یک دسته‌بندی
@collection
class Word {
  Id id = Isar.autoIncrement;

  /// متن کلمه
  late String text;

  /// شناسه دسته‌بندی والد
  @Index()
  late int categoryId;

  /// سطح دشواری
  @enumerated
  late WordDifficulty difficulty;
}
