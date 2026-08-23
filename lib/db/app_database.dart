// Main Drift database — app_database.dart
// Run `dart run build_runner build --delete-conflicting-outputs` after schema changes.
//
// Schema version history:
//   v1 (scaffold) — Customers, Products, Invoices, InvoiceItems
//   v2            — BusinessProfile, Customers (revised), Items, Documents,
//                   DocumentLineItems, Payments
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'tables/business_profile_table.dart';
import 'tables/customers_table.dart';
import 'tables/items_table.dart';
import 'tables/documents_table.dart';
import 'tables/document_line_items_table.dart';
import 'tables/payments_table.dart';

import 'daos/business_profile_dao.dart';
import 'daos/customers_dao.dart';
import 'daos/items_dao.dart';
import 'daos/documents_dao.dart';
import 'daos/payments_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    BusinessProfile,
    Customers,
    Items,
    Documents,
    DocumentLineItems,
    Payments,
  ],
  daos: [
    BusinessProfileDao,
    CustomersDao,
    ItemsDao,
    DocumentsDao,
    PaymentsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          // v1 → v2: drop old scaffold tables and create the real schema.
          // Safe because v1 contained no real user data.
          if (from == 1) {
            // Drop old scaffold tables (may not exist on fresh installs — ignore errors)
            await customStatement('DROP TABLE IF EXISTS invoice_items');
            await customStatement('DROP TABLE IF EXISTS invoices');
            await customStatement('DROP TABLE IF EXISTS products');
            // 'customers' is reused but column set has changed — recreate.
            await customStatement('DROP TABLE IF EXISTS customers');

            // Create the full v2 schema
            await m.createAll();
          }
          // Future migrations:
          // if (from < 3) {
          //   await m.addColumn(documents, documents.someNewColumn);
          // }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

/// Opens an on-disk [QueryExecutor] using the app documents directory.
QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'billwise_db',
    native: DriftNativeOptions(
      databaseDirectory: getApplicationDocumentsDirectory,
    ),
  );
}
