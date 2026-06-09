import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spy_game/data/datasources/isar_datasource.dart';

part 'isar_provider.g.dart';

/// Provider دسترسی به instance Isar
@Riverpod(keepAlive: true)
Future<Isar> isar(Ref ref) async {
  return IsarDatasource.open();
}
