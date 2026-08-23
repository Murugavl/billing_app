// Payment Recording & Dashboard Flow Unit Test
import 'package:billwise/db/app_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

AppDatabase _openInMemory() => AppDatabase(NativeDatabase.memory());

void main() {
  late AppDatabase db;

  setUp(() => db = _openInMemory());
  tearDown(() => db.close());

  group('Payment Recording & Status Transitions', () {
    test('recording partial payment updates balanceDue and status to partially_paid', () async {
      final custId = await db.customersDao.insertCustomer(
        const CustomersCompanion(
          name: Value('Aqua Solutions Pvt Ltd'),
          phone: Value('9000011111'),
        ),
      );

      final docId = await db.documentsDao.insertDocumentWithLines(
        doc: DocumentsCompanion(
          documentNumber: const Value('INV-0001'),
          type: const Value('invoice'),
          customerId: Value(custId),
          customerName: const Value('Aqua Solutions Pvt Ltd'),
          date: Value(DateTime.now()),
          subtotal: const Value(8500.0),
          totalDiscount: const Value(499.97),
          totalTax: const Value(0.0),
          grandTotal: const Value(8000.03),
          amountReceived: const Value(0.0),
          balanceDue: const Value(8000.03),
          status: const Value('sent'),
        ),
        lines: [
          const DocumentLineItemsCompanion(
            itemName: Value('Aqua Queen'),
            quantity: Value(1.0),
            pricePerUnit: Value(8500.0),
            lineTotal: Value(8000.03),
          ),
        ],
      );

      // Record partial payment of ₹3,000
      await db.paymentsDao.recordPayment(
        companion: PaymentsCompanion(
          documentId: Value(docId),
          amount: const Value(3000.0),
          date: Value(DateTime.now()),
          method: const Value('upi'),
          notes: const Value('GPay Ref #1234'),
        ),
        grandTotal: 8000.03,
      );

      final updatedDoc = await db.documentsDao.getDocumentById(docId);
      expect(updatedDoc, isNotNull);
      expect(updatedDoc!.amountReceived, 3000.0);
      expect(updatedDoc.balanceDue, 5000.03);
      expect(updatedDoc.status, 'partially_paid');

      final paymentsList = await db.paymentsDao.getPaymentsForDocument(docId);
      expect(paymentsList.length, 1);
      expect(paymentsList.first.amount, 3000.0);
      expect(paymentsList.first.method, 'upi');
    });

    test('recording final payment that reaches full amount marks invoice as paid', () async {
      final custId = await db.customersDao.insertCustomer(
        const CustomersCompanion(
          name: Value('Aqua Solutions Pvt Ltd'),
        ),
      );

      final docId = await db.documentsDao.insertDocumentWithLines(
        doc: DocumentsCompanion(
          documentNumber: const Value('INV-0002'),
          type: const Value('invoice'),
          customerId: Value(custId),
          customerName: const Value('Aqua Solutions Pvt Ltd'),
          date: Value(DateTime.now()),
          subtotal: const Value(8000.03),
          grandTotal: const Value(8000.03),
          amountReceived: const Value(3000.0),
          balanceDue: const Value(5000.03),
          status: const Value('partially_paid'),
        ),
        lines: [
          const DocumentLineItemsCompanion(
            itemName: Value('Aqua Queen'),
            quantity: Value(1.0),
            pricePerUnit: Value(8000.03),
            lineTotal: Value(8000.03),
          ),
        ],
      );

      // Record first payment of ₹3,000 (manually stored in Payments table)
      await db.into(db.payments).insert(
        PaymentsCompanion(
          documentId: Value(docId),
          amount: const Value(3000.0),
          date: Value(DateTime.now()),
          method: const Value('cash'),
        ),
      );

      // Record final payment of ₹5,000.03
      await db.paymentsDao.recordPayment(
        companion: PaymentsCompanion(
          documentId: Value(docId),
          amount: const Value(5000.03),
          date: Value(DateTime.now()),
          method: const Value('bank_transfer'),
        ),
        grandTotal: 8000.03,
      );

      final paidDoc = await db.documentsDao.getDocumentById(docId);
      expect(paidDoc, isNotNull);
      expect(paidDoc!.amountReceived, 8000.03);
      expect(paidDoc.balanceDue, 0.0);
      expect(paidDoc.status, 'paid');

      final paymentsList = await db.paymentsDao.getPaymentsForDocument(docId);
      expect(paymentsList.length, 2);
    });
  });
}
