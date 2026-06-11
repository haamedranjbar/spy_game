import 'package:isar_community/isar.dart';

part 'purchase_state.g.dart';

/// وضعیت خرید نسخه طلایی — یک رکورد در دیتابیس
@collection
class PurchaseState {
  Id id = Isar.autoIncrement;

  /// آیا کاربر نسخه طلایی دارد؟
  late bool isGoldenUser;

  /// توکن خرید از فروشگاه
  String? purchaseToken;

  /// تاریخ خرید
  DateTime? purchaseDate;
}
