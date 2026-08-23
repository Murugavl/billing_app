// DAO: ItemsDao
import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/items_table.dart';

part 'items_dao.g.dart';

@DriftAccessor(tables: [Items])
class ItemsDao extends DatabaseAccessor<AppDatabase> with _$ItemsDaoMixin {
  ItemsDao(super.db);

  // ── Read ────────────────────────────────────────────────────────────────────

  Future<List<Item>> getAllItems() =>
      (select(items)..orderBy([(t) => OrderingTerm.asc(t.name)])).get();

  Stream<List<Item>> watchAllItems() =>
      (select(items)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();

  Future<Item?> getItemById(int id) =>
      (select(items)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Item>> searchItems(String query) {
    final pattern = '%${query.toLowerCase()}%';
    return (select(items)
          ..where((t) =>
              t.name.lower().like(pattern) |
              t.hsnSacCode.lower().like(pattern)))
        .get();
  }

  // ── Write ───────────────────────────────────────────────────────────────────

  Future<int> insertItem(ItemsCompanion companion) =>
      into(items).insert(companion);

  Future<bool> updateItem(ItemsCompanion companion) =>
      update(items).replace(companion);

  Future<int> deleteItem(int id) =>
      (delete(items)..where((t) => t.id.equals(id))).go();
}
