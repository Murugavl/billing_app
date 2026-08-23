// Unit tests for BackupRepository database JSON export and atomic restore
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:billwise/db/app_database.dart';
import 'package:billwise/services/backup_repository.dart';

AppDatabase _openInMemoryDb() {
  return AppDatabase(NativeDatabase.memory());
}

void main() {
  late AppDatabase db;
  late BackupRepository repo;

  setUp(() {
    db = _openInMemoryDb();
    repo = BackupRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('Export database to JSON and restore into clean database preserves all 10 entities', () async {
    // 1. Seed Business Profile
    await db.businessProfileDao.upsertProfile(
      const BusinessProfileCompanion(
        businessName: drift.Value('Ponsri Enterprises'),
        gstNumber: drift.Value('33AABCP1234A1Z5'),
        phone: drift.Value('9876543210'),
      ),
    );

    // 2. Seed Customer
    final custId = await db.customersDao.insertCustomer(
      const CustomersCompanion(
        name: drift.Value('Aqua Tech Client'),
        phone: drift.Value('9123456789'),
      ),
    );

    // 3. Seed Item
    final itemId = await db.itemsDao.insertItem(
      const ItemsCompanion(
        name: drift.Value('RO Membrane 8040'),
        defaultPrice: drift.Value(4500.0),
        defaultUnit: drift.Value('Pcs'),
      ),
    );

    // 4. Seed Document & Line Item
    final docId = await db.documentsDao.insertDocumentWithLines(
      doc: DocumentsCompanion(
        documentNumber: const drift.Value('INV-9001'),
        type: const drift.Value('invoice'),
        customerId: drift.Value(custId),
        customerName: const drift.Value('Aqua Tech Client'),
        date: drift.Value(DateTime.now()),
        subtotal: const drift.Value(4500.0),
        grandTotal: const drift.Value(4500.0),
        balanceDue: const drift.Value(4500.0),
      ),
      lines: [
        DocumentLineItemsCompanion(
          itemId: drift.Value(itemId),
          itemName: const drift.Value('RO Membrane 8040'),
          quantity: const drift.Value(1.0),
          pricePerUnit: const drift.Value(4500.0),
          lineTotal: const drift.Value(4500.0),
        ),
      ],
    );

    // 5. Seed Payment
    await db.into(db.payments).insert(
      PaymentsCompanion.insert(
        documentId: docId,
        amount: const drift.Value(2000.0),
        date: DateTime.now(),
        method: const drift.Value('cash'),
      ),
    );

    // 6. Seed Supplier, Purchase Bill, Line Item, Payment
    final supplierId = await db.suppliersDao.insertSupplier(
      const SuppliersCompanion(
        name: drift.Value('Membrane Wholesaler'),
        phone: drift.Value('9444111222'),
      ),
    );

    final billId = await db.purchaseBillsDao.createPurchaseBill(
      billCompanion: PurchaseBillsCompanion.insert(
        billNumber: 'PUR-8001',
        supplierId: supplierId,
        date: DateTime.now(),
        subtotal: 3000.0,
        totalTax: 0.0,
        grandTotal: 3000.0,
        balanceDue: 3000.0,
      ),
      lineItemsCompanions: [
        PurchaseLineItemsCompanion.insert(
          purchaseBillId: 0,
          itemName: 'Filter Cartridges',
          quantity: 10,
          pricePerUnit: 300.0,
          lineTotal: 3000.0,
        ),
      ],
    );

    await db.purchaseBillsDao.recordPayment(
      billId: billId,
      amount: 1000.0,
      date: DateTime.now(),
      method: 'upi',
    );

    // EXPORT TO JSON
    final jsonExport = await repo.exportDatabaseToJson();
    expect(jsonExport, contains('Ponsri Enterprises'));
    expect(jsonExport, contains('INV-9001'));
    expect(jsonExport, contains('PUR-8001'));

    // RESTORE INTO FRESH DB
    final db2 = _openInMemoryDb();
    final repo2 = BackupRepository(db2);

    await repo2.restoreDatabaseFromJson(jsonExport);

    // VERIFY DATA IN DB2
    final restoredProfile = await db2.businessProfileDao.getProfile();
    expect(restoredProfile, isNotNull);
    expect(restoredProfile!.businessName, equals('Ponsri Enterprises'));

    final restoredCustomers = await db2.customersDao.getAllCustomers();
    expect(restoredCustomers.length, equals(1));
    expect(restoredCustomers.first.name, equals('Aqua Tech Client'));

    final restoredInvoices = await db2.documentsDao.getDocumentsByType('invoice');
    expect(restoredInvoices.length, equals(1));
    expect(restoredInvoices.first.documentNumber, equals('INV-9001'));

    final restoredPurchases = await db2.purchaseBillsDao.getAllPurchaseBills();
    expect(restoredPurchases.length, equals(1));
    expect(restoredPurchases.first.billNumber, equals('PUR-8001'));

    await db2.close();
  });
}
