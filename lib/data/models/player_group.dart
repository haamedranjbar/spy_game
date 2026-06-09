import 'package:isar_community/isar.dart';

part 'player_group.g.dart';

/// گروه ذخیره‌شده بازیکنان
@collection
class PlayerGroup {
  Id id = Isar.autoIncrement;

  /// نام گروه (مثلاً «خودمونی»)
  late String name;

  /// لیست اسامی بازیکنان
  List<String> playerNames = [];

  /// زمان ایجاد گروه
  late DateTime createdAt;
}
