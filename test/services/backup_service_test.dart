// Backup Service & Data Safety Unit Test
import 'package:billwise/db/app_database.dart';
import 'package:billwise/services/backup_service.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

AppDatabase _openInMemory() => AppDatabase(NativeDatabase.memory());

void main() {
  late AppDatabase db1;
  late AppDatabase db2;

  setUp(() {
    db1 = _openInMemory();
    db2 = _openInMemory();
  });

  tearDown(() {
    db1.close();
    db2.close();
  });

  group('Full Backup & Restore Cycle (Data Preservation)', () {
    test('backup from original DB and restore onto fresh DB preserves all entities', () async {
      // 1. Setup Business Profile on DB1
      await db1.businessProfileDao.upsertProfile(
        const BusinessProfileCompanion(
          businessName: Value('Ponsri Enterprises'),
          addressLine: Value('123 Billing Street, Chennai'),
          phone: Value('9876543210'),
          gstNumber: Value('33AABCP1234A1Z5'),
          bankName: Value('State Bank of India'),
        ),
      );

      // 2. Insert Customer on DB1
      final custId = await db1.customersDao.insertCustomer(
        const CustomersCompanion(
          name: Value('Aqua Solutions Pvt Ltd'),
          phone: Value('9000011111'),
          address: Value('12, Industrial Estate'),
        ),
      );

      // 3. Insert Catalog Item on DB1
      final itemId = await db1.itemsDao.insertItem(
        const ItemsCompanion(
          name: Value('Aqua Queen Water Purifier'),
          hsnSacCode: Value('84818090'),
          defaultUnit: Value('Pcs'),
          defaultPrice: Value(8500.0),
        ),
      );

      // 4. Insert Invoice document on DB1
      final invId = await db1.documentsDao.insertDocumentWithLines(
        doc: DocumentsCompanion(
          documentNumber: const Value('INV-0001'),
          type: const Value('invoice'),
          customerId: Value(custId),
          customerName: const Value('Aqua Solutions Pvt Ltd'),
          date: Value(DateTime(2025, 5, 1)),
          subtotal: const Value(8500.0),
          totalDiscount: const Value(499.97),
          grandTotal: const Value(8000.03),
          amountReceived: const Value(3000.0),
          balanceDue: const Value(5000.03),
          amountInWords: const Value('Eight Thousand Rupees and Three Paise Only'),
          status: const Value('partially_paid'),
        ),
        lines: [
          DocumentLineItemsCompanion(
            itemId: Value(itemId),
            itemName: const Value('Aqua Queen Water Purifier'),
            hsnSacCode: const Value('84818090'),
            quantity: const Value(1.0),
            unit: const Value('Pcs'),
            pricePerUnit: const Value(8500.0),
            discountAmount: const Value(499.97),
            taxableAmount: const Value(8000.03),
            lineTotal: const Value(8000.03),
          ),
        ],
      );

      // 5. Insert Estimate document on DB1
      final estId = await db1.documentsDao.insertDocumentWithLines(
        doc: DocumentsCompanion(
          documentNumber: const Value('EST-0001'),
          type: const Value('estimate'),
          customerId: Value(custId),
          customerName: const Value('Aqua Solutions Pvt Ltd'),
          date: Value(DateTime(2025, 4, 15)),
          subtotal: const Value(19200.0),
          grandTotal: const Value(19200.0),
          status: const Value('sent'),
        ),
        lines: [
          const DocumentLineItemsCompanion(
            itemName: Value('Flow Meter'),
            quantity: Value(1.0),
            pricePerUnit: Value(19200.0),
            lineTotal: Value(19200.0),
          ),
        ],
      );

      // 6. Record Payment against Invoice on DB1
      await db1.paymentsDao.recordPayment(
        companion: PaymentsCompanion(
          documentId: Value(invId),
          amount: const Value(3000.0),
          date: Value(DateTime(2025, 5, 2)),
          method: const Value('upi'),
          notes: const Value('Advance payment via GPay'),
        ),
        grandTotal: 8000.03,
      );

      // Verify DB1 data state
      final profile1 = await db1.businessProfileDao.getProfile();
      expect(profile1?.businessName, 'Ponsri Enterprises');
      final custs1 = await db1.customersDao.getAllCustomers();
      expect(custs1.length, 1);

      // Generate Backup JSON from DB1
      final backupJson = await BackupService.generateBackupJson(db1);
      expect(backupJson, isNotEmpty);
      expect(backupJson.contains('ponsri_billing'), isTrue);

      // Restore Backup JSON onto fresh, empty DB2
      final restored = await BackupService.restoreFromBackupJson(db2, backupJson);
      expect(restored, isTrue);

      // 7. Verify all entities on DB2 after restoration
      final profile2 = await db2.businessProfileDao.getProfile();
      expect(profile2, isNotNull);
      expect(profile2!.businessName, 'Ponsri Enterprises');
      expect(profile2.gstNumber, '33AABCP1234A1Z5');

      final custs2 = await db2.customersDao.getAllCustomers();
      expect(custs2.length, 1);
      expect(custs2.first.name, 'Aqua Solutions Pvt Ltd');

      final items2 = await db2.itemsDao.getAllItems();
      expect(items2.length, 1);
      expect(items2.first.name, 'Aqua Queen Water Purifier');

      final docs2 = await db2.documentsDao.getAllDocuments();
      expect(docs2.length, 2);

      final inv2 = await db2.documentsDao.getDocumentWithLines(invId);
      expect(inv2, isNotNull);
      expect(inv2!.document.documentNumber, 'INV-0001');
      expect(inv2.document.grandTotal, 8000.03);
      expect(inv2.document.amountReceived, 3000.0);
      expect(inv2.document.balanceDue, 5000.03);
      expect(inv2.document.status, 'partially_paid');
      expect(inv2.lineItems.length, 1);
      expect(inv2.lineItems.first.itemName, 'Aqua Queen Water Purifier');

      final est2 = await db2.documentsDao.getDocumentWithLines(estId);
      expect(est2, isNotNull);
      expect(est2!.document.documentNumber, 'EST-0001');

      final payments2 = await db2.paymentsDao.getPaymentsForDocument(invId);
      expect(payments2.length, 1);
      expect(payments2.first.amount, 3000.0);
      expect(payments2.first.method, 'upi');
      expect(payments2.first.notes, 'Advance payment via GPay');
    });
  });
}
