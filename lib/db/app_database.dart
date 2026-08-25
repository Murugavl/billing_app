// Main Drift database — app_database.dart
// Run `dart run build_runner build --delete-conflicting-outputs` after schema changes.
//
// Schema version history:
//   v1 (scaffold) — Customers, Products, Invoices, InvoiceItems
//   v2            — BusinessProfile, Customers (revised), Items, Documents,
//                   DocumentLineItems, Payments
//   v3            — Suppliers, PurchaseBills, PurchaseLineItems, PurchasePayments
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'tables/business_profile_table.dart';
import 'tables/customers_table.dart';
import 'tables/items_table.dart';
import 'tables/documents_table.dart';
import 'tables/document_line_items_table.dart';
import 'tables/payments_table.dart';
import 'tables/suppliers_table.dart';
import 'tables/purchase_bills_table.dart';
import 'tables/purchase_line_items_table.dart';
import 'tables/purchase_payments_table.dart';

import 'daos/business_profile_dao.dart';
import 'daos/customers_dao.dart';
import 'daos/items_dao.dart';
import 'daos/documents_dao.dart';
import 'daos/payments_dao.dart';
import 'daos/suppliers_dao.dart';
import 'daos/purchase_bills_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    BusinessProfile,
    Customers,
    Items,
    Documents,
    DocumentLineItems,
    Payments,
    Suppliers,
    PurchaseBills,
    PurchaseLineItems,
    PurchasePayments,
  ],
  daos: [
    BusinessProfileDao,
    CustomersDao,
    ItemsDao,
    DocumentsDao,
    PaymentsDao,
    SuppliersDao,
    PurchaseBillsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from == 1) {
            await customStatement('DROP TABLE IF EXISTS invoice_items');
            await customStatement('DROP TABLE IF EXISTS invoices');
            await customStatement('DROP TABLE IF EXISTS products');
            await customStatement('DROP TABLE IF EXISTS customers');
            await m.createAll();
          } else if (from < 3) {
            await m.createTable(suppliers);
            await m.createTable(purchaseBills);
            await m.createTable(purchaseLineItems);
            await m.createTable(purchasePayments);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

/// Opens an on-disk [QueryExecutor] using the app documents directory.
QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'rasidhu_db',
    native: DriftNativeOptions(
      databaseDirectory: getApplicationDocumentsDirectory,
    ),
  );
}
