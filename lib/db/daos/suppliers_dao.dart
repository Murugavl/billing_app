// DAO: SuppliersDao
import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/suppliers_table.dart';

part 'suppliers_dao.g.dart';

@DriftAccessor(tables: [Suppliers])
class SuppliersDao extends DatabaseAccessor<AppDatabase>
    with _$SuppliersDaoMixin {
  SuppliersDao(super.db);

  // ── Read ────────────────────────────────────────────────────────────────────

  Future<List<Supplier>> getAllSuppliers() =>
      (select(suppliers)..orderBy([(t) => OrderingTerm.asc(t.name)])).get();

  Stream<List<Supplier>> watchAllSuppliers() =>
      (select(suppliers)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();

  Future<Supplier?> getSupplierById(int id) =>
      (select(suppliers)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Supplier>> searchSuppliers(String query) {
    final pattern = '%${query.toLowerCase()}%';
    return (select(suppliers)
          ..where((t) =>
              t.name.lower().like(pattern) |
              t.phone.lower().like(pattern) |
              t.gstNumber.lower().like(pattern)))
        .get();
  }

  // ── Write ───────────────────────────────────────────────────────────────────

  Future<int> insertSupplier(SuppliersCompanion companion) =>
      into(suppliers).insert(companion);

  Future<bool> updateSupplier(SuppliersCompanion companion) =>
      update(suppliers).replace(companion);

  Future<int> deleteSupplier(int id) =>
      (delete(suppliers)..where((t) => t.id.equals(id))).go();
}
