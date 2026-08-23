// Purchase Module Unit Tests — Supplier CRUD, Purchase Bills, Payments, and Net Margin Analytics
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:billwise/db/app_database.dart';

AppDatabase _openInMemoryDb() {
  return AppDatabase(NativeDatabase.memory());
}

void main() {
  late AppDatabase db;

  setUp(() {
    db = _openInMemoryDb();
  });

  tearDown(() async {
    await db.close();
  });

  group('Supplier Management & Delete Safety', () {
    test('Supplier insert, retrieve and search works', () async {
      final id = await db.suppliersDao.insertSupplier(
        const SuppliersCompanion(
          name: drift.Value('Aqua Tech Water Solutions'),
          phone: drift.Value('9876543210'),
          gstNumber: drift.Value('33AAAAA0000A1Z5'),
        ),
      );

      final supplier = await db.suppliersDao.getSupplierById(id);
      expect(supplier, isNotNull);
      expect(supplier!.name, equals('Aqua Tech Water Solutions'));

      final search = await db.suppliersDao.searchSuppliers('Aqua');
      expect(search.length, equals(1));
      expect(search.first.name, equals('Aqua Tech Water Solutions'));
    });

    test('Supplier delete safety check prevents deletion if bill exists', () async {
      final supplierId = await db.suppliersDao.insertSupplier(
        const SuppliersCompanion(
          name: drift.Value('Filter Media Supplies'),
          phone: drift.Value('9123456789'),
        ),
      );

      await db.purchaseBillsDao.createPurchaseBill(
        billCompanion: PurchaseBillsCompanion.insert(
          billNumber: 'PUR-001',
          supplierId: supplierId,
          date: DateTime.now(),
          subtotal: 1000.0,
          totalTax: 180.0,
          grandTotal: 1180.0,
          balanceDue: 1180.0,
        ),
        lineItemsCompanions: [
          PurchaseLineItemsCompanion.insert(
            purchaseBillId: 0,
            itemName: 'Activated Carbon Bag',
            quantity: 1,
            pricePerUnit: 1000.0,
            taxAmount: const drift.Value(180.0),
            lineTotal: 1180.0,
          ),
        ],
      );

      final count = await db.purchaseBillsDao.getPurchaseCountForSupplier(supplierId);
      expect(count, equals(1));
    });
  });

  group('Purchase Bill Creation & Payments', () {
    test('Create Purchase Bill calculates status correctly on payment', () async {
      final supplierId = await db.suppliersDao.insertSupplier(
        const SuppliersCompanion(
          name: drift.Value('Industrial Valves Ltd'),
          phone: drift.Value('9444111222'),
        ),
      );

      final billId = await db.purchaseBillsDao.createPurchaseBill(
        billCompanion: PurchaseBillsCompanion.insert(
          billNumber: 'PUR-1001',
          supplierId: supplierId,
          date: DateTime.now(),
          subtotal: 5000.0,
          totalTax: 900.0,
          grandTotal: 5900.0,
          balanceDue: 5900.0,
        ),
        lineItemsCompanions: [
          PurchaseLineItemsCompanion.insert(
            purchaseBillId: 0,
            itemName: 'Solenoid Valve 1 inch',
            quantity: 5,
            pricePerUnit: 1000.0,
            taxAmount: const drift.Value(900.0),
            lineTotal: 5900.0,
          ),
        ],
      );

      var billWithLines = await db.purchaseBillsDao.getPurchaseBillWithLines(billId);
      expect(billWithLines, isNotNull);
      expect(billWithLines!.bill.status, equals('unpaid'));
      expect(billWithLines.bill.balanceDue, equals(5900.0));

      // Partial payment ₹2,000
      await db.purchaseBillsDao.recordPayment(
        billId: billId,
        amount: 2000.0,
        date: DateTime.now(),
        method: 'upi',
      );

      billWithLines = await db.purchaseBillsDao.getPurchaseBillWithLines(billId);
      expect(billWithLines!.bill.status, equals('partially_paid'));
      expect(billWithLines.bill.amountPaid, equals(2000.0));
      expect(billWithLines.bill.balanceDue, equals(3900.0));

      // Full final payment ₹3,900
      await db.purchaseBillsDao.recordPayment(
        billId: billId,
        amount: 3900.0,
        date: DateTime.now(),
        method: 'bank_transfer',
      );

      billWithLines = await db.purchaseBillsDao.getPurchaseBillWithLines(billId);
      expect(billWithLines!.bill.status, equals('paid'));
      expect(billWithLines.bill.amountPaid, equals(5900.0));
      expect(billWithLines.bill.balanceDue, equals(0.0));
    });
  });

  group('Sales vs Purchases & Net Margin Verification', () {
    test('Total Purchases and Net Margin correctly compute (Sales - Purchases)', () async {
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, 1);
      final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      // 1. Insert an Invoice for ₹10,000
      final customerId = await db.customersDao.insertCustomer(
        const CustomersCompanion(
          name: drift.Value('Aqua Queen Client'),
          phone: drift.Value('9597794387'),
        ),
      );

      await db.documentsDao.insertDocumentWithLines(
        doc: DocumentsCompanion(
          type: const drift.Value('invoice'),
          documentNumber: const drift.Value('INV-0001'),
          customerName: const drift.Value('Aqua Queen Client'),
          date: drift.Value(now),
          subtotal: const drift.Value(10000.0),
          grandTotal: const drift.Value(10000.0),
          balanceDue: const drift.Value(10000.0),
          customerId: drift.Value(customerId),
        ),
        lines: [
          const DocumentLineItemsCompanion(
            itemName: drift.Value('Ro Plant Maintenance'),
            quantity: drift.Value(1.0),
            pricePerUnit: drift.Value(10000.0),
            lineTotal: drift.Value(10000.0),
          ),
        ],
      );

      // 2. Insert a Purchase Bill for ₹4,000
      final supplierId = await db.suppliersDao.insertSupplier(
        const SuppliersCompanion(
          name: drift.Value('Membrane Wholesaler'),
          phone: drift.Value('9888877777'),
        ),
      );

      await db.purchaseBillsDao.createPurchaseBill(
        billCompanion: PurchaseBillsCompanion.insert(
          billNumber: 'PUR-002',
          supplierId: supplierId,
          date: now,
          subtotal: 4000.0,
          totalTax: 0.0,
          grandTotal: 4000.0,
          balanceDue: 4000.0,
        ),
        lineItemsCompanions: [
          PurchaseLineItemsCompanion.insert(
            purchaseBillId: 0,
            itemName: 'Dow Filmtec Membrane 8040',
            quantity: 1,
            pricePerUnit: 4000.0,
            lineTotal: 4000.0,
          ),
        ],
      );

      // 3. Compute Summary
      final summary = await db.purchaseBillsDao.getSalesVsPurchasesSummary(start, end);

      expect(summary.totalSales, equals(10000.0));
      expect(summary.totalPurchases, equals(4000.0));
      expect(summary.netMargin, equals(6000.0)); // 10000 - 4000
    });
  });
}
