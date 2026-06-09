import 'package:isar_community/isar.dart';

part 'database_meta.g.dart';

/// متادیتای دیتابیس — برای init و migration
@collection
class DatabaseMeta {
  Id id = Isar.autoIncrement;

  /// نسخه schema دیتابیس
  int version = 1;
}
