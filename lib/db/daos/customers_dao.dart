// DAO: CustomersDao
import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/customers_table.dart';

part 'customers_dao.g.dart';

@DriftAccessor(tables: [Customers])
class CustomersDao extends DatabaseAccessor<AppDatabase>
    with _$CustomersDaoMixin {
  CustomersDao(super.db);

  // ── Read ────────────────────────────────────────────────────────────────────

  Future<List<Customer>> getAllCustomers() =>
      (select(customers)..orderBy([(t) => OrderingTerm.asc(t.name)])).get();

  Stream<List<Customer>> watchAllCustomers() =>
      (select(customers)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();

  Future<Customer?> getCustomerById(int id) =>
      (select(customers)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Customer>> searchCustomers(String query) {
    final pattern = '%${query.toLowerCase()}%';
    return (select(customers)
          ..where((t) =>
              t.name.lower().like(pattern) |
              t.phone.lower().like(pattern) |
              t.email.lower().like(pattern)))
        .get();
  }

  // ── Write ───────────────────────────────────────────────────────────────────

  Future<int> insertCustomer(CustomersCompanion companion) =>
      into(customers).insert(companion);

  Future<bool> updateCustomer(CustomersCompanion companion) =>
      update(customers).replace(companion);

  Future<int> deleteCustomer(int id) =>
      (delete(customers)..where((t) => t.id.equals(id))).go();
}
