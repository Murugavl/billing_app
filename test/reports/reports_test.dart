// Reports & Global Search Unit Test
import 'package:billwise/db/app_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

AppDatabase _openInMemory() => AppDatabase(NativeDatabase.memory());

void main() {
  late AppDatabase db;

  setUp(() => db = _openInMemory());
  tearDown(() => db.close());

  group('Reports & Global Search', () {
    test('sales calculation correctly sums grand totals for given date range', () async {
      final custId = await db.customersDao.insertCustomer(
        const CustomersCompanion(name: Value('Aqua Solutions')),
      );

      // Insert invoice 1: ₹8,000.03
      await db.documentsDao.insertDocumentWithLines(
        doc: DocumentsCompanion(
          documentNumber: const Value('INV-0001'),
          type: const Value('invoice'),
          customerId: Value(custId),
          customerName: const Value('Aqua Solutions'),
          date: Value(DateTime.now()),
          grandTotal: const Value(8000.03),
          amountReceived: const Value(8000.03),
          balanceDue: const Value(0.0),
          status: const Value('paid'),
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

      // Insert invoice 2: ₹12,000.00
      await db.documentsDao.insertDocumentWithLines(
        doc: DocumentsCompanion(
          documentNumber: const Value('INV-0002'),
          type: const Value('invoice'),
          customerId: Value(custId),
          customerName: const Value('Aqua Solutions'),
          date: Value(DateTime.now()),
          grandTotal: const Value(12000.0),
          amountReceived: const Value(4000.0),
          balanceDue: const Value(8000.0),
          status: const Value('partially_paid'),
        ),
        lines: [
          const DocumentLineItemsCompanion(
            itemName: Value('Flow Meter'),
            quantity: Value(1.0),
            pricePerUnit: Value(12000.0),
            lineTotal: Value(12000.0),
          ),
        ],
      );

      final allInvoices = await db.documentsDao.getDocumentsByType('invoice');
      expect(allInvoices.length, 2);

      final totalSales = allInvoices.fold(0.0, (sum, doc) => sum + doc.grandTotal);
      expect(totalSales, 20000.03);

      final totalOutstanding = allInvoices.where((doc) => doc.status != 'paid').fold(0.0, (sum, doc) => sum + (doc.balanceDue ?? 0.0));
      expect(totalOutstanding, 8000.0);
    });

    test('global search finds customers and invoices by query substring', () async {
      final custId1 = await db.customersDao.insertCustomer(
        const CustomersCompanion(name: Value('Ponsri Enterprises'), phone: Value('9876543210')),
      );

      await db.documentsDao.insertDocumentWithLines(
        doc: DocumentsCompanion(
          documentNumber: const Value('INV-0088'),
          type: const Value('invoice'),
          customerId: Value(custId1),
          customerName: const Value('Ponsri Enterprises'),
          date: Value(DateTime.now()),
          grandTotal: const Value(5000.0),
        ),
        lines: [],
      );

      final custMatches = await db.customersDao.searchCustomers('ponsri');
      expect(custMatches.length, 1);
      expect(custMatches.first.name, 'Ponsri Enterprises');

      final invMatches = (await db.documentsDao.getDocumentsByType('invoice'))
          .where((doc) => doc.documentNumber.toLowerCase().contains('0088'))
          .toList();
      expect(invMatches.length, 1);
      expect(invMatches.first.documentNumber, 'INV-0088');
    });
  });
}
