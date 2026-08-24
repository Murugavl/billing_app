// Test Suite: App-Wide Database Reactivity & Reports Stream Consistency
import 'package:billwise/db/app_database.dart';
import 'package:billwise/db/daos/customers_dao.dart';
import 'package:billwise/db/daos/documents_dao.dart';
import 'package:billwise/providers/dashboard_provider.dart';
import 'package:billwise/providers/reports_provider.dart';
import 'package:billwise/services/database_provider.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

AppDatabase _openInMemory() => AppDatabase(NativeDatabase.memory());

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late DocumentsDao docsDao;
  late CustomersDao customersDao;

  setUp(() {
    db = _openInMemory();
    docsDao = DocumentsDao(db);
    customersDao = CustomersDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Reactive Database Stream Providers Test', () {
    test('editing invoice line item amount reactively updates salesReportProvider without manual invalidation', () async {
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
      );
      addTearDown(container.dispose);

      // 1. Create a customer
      final custId = await customersDao.insertCustomer(
        const CustomersCompanion(
          name: Value('Acme Traders'),
          phone: Value('9876543210'),
        ),
      );

      final now = DateTime.now();

      // 2. Insert initial invoice (INV-0001 with Grand Total = 1000.0)
      final docId = await docsDao.insertDocumentWithLines(
        doc: DocumentsCompanion(
          documentNumber: const Value('INV-0001'),
          type: const Value('invoice'),
          customerId: Value(custId),
          customerName: const Value('Acme Traders'),
          date: Value(now),
          subtotal: const Value(1000.0),
          totalTax: const Value(0.0),
          totalDiscount: const Value(0.0),
          grandTotal: const Value(1000.0),
          amountReceived: const Value(0.0),
          balanceDue: const Value(1000.0),
          status: const Value('unpaid'),
        ),
        lines: [
          const DocumentLineItemsCompanion(
            itemName: Value('Widget A'),
            quantity: Value(1.0),
            pricePerUnit: Value(1000.0),
            taxableAmount: Value(1000.0),
          ),
        ],
      );

      // 3. Listen to salesReportProvider
      late SalesReportData initialReport;
      final subscription = container.listen(salesReportProvider, (prev, next) {
        if (next.hasValue) {
          initialReport = next.value!;
        }
      });

      await Future.delayed(const Duration(milliseconds: 100));

      expect(initialReport.totalSales, equals(1000.0));
      expect(initialReport.invoiceCount, equals(1));

      // 4. Edit the invoice: change Grand Total from 1000.0 to 2500.0 (simulating line item edit)
      await docsDao.updateDocumentWithLines(
        doc: DocumentsCompanion(
          id: Value(docId),
          documentNumber: const Value('INV-0001'),
          type: const Value('invoice'),
          customerId: Value(custId),
          customerName: const Value('Acme Traders'),
          date: Value(now),
          subtotal: const Value(2500.0),
          totalTax: const Value(0.0),
          totalDiscount: const Value(0.0),
          grandTotal: const Value(2500.0),
          amountReceived: const Value(0.0),
          balanceDue: const Value(2500.0),
          status: const Value('unpaid'),
        ),
        lines: [
          const DocumentLineItemsCompanion(
            itemName: Value('Widget A'),
            quantity: Value(2.5),
            pricePerUnit: Value(1000.0),
            taxableAmount: Value(2500.0),
          ),
        ],
      );

      await Future.delayed(const Duration(milliseconds: 100));

      // 5. Verify salesReportProvider updated reactively
      final updatedReport = container.read(salesReportProvider).asData!.value;
      expect(updatedReport.totalSales, equals(2500.0));

      subscription.close();
    });

    test('editing invoice updates topCustomersProvider and outstandingReportProvider reactively', () async {
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
      );
      addTearDown(container.dispose);

      final custId = await customersDao.insertCustomer(
        const CustomersCompanion(
          name: Value('Ponsri Water Tech'),
        ),
      );

      final now = DateTime.now();

      final docId = await docsDao.insertDocumentWithLines(
        doc: DocumentsCompanion(
          documentNumber: const Value('INV-0002'),
          type: const Value('invoice'),
          customerId: Value(custId),
          customerName: const Value('Ponsri Water Tech'),
          date: Value(now),
          subtotal: const Value(500.0),
          grandTotal: const Value(500.0),
          amountReceived: const Value(0.0),
          balanceDue: const Value(500.0),
          status: const Value('unpaid'),
        ),
        lines: [],
      );

      container.listen(topCustomersProvider, (_, __) {});
      container.listen(outstandingReportProvider, (_, __) {});
      await Future.delayed(const Duration(milliseconds: 100));

      var topCust = container.read(topCustomersProvider).asData!.value;
      var outstanding = container.read(outstandingReportProvider).asData!.value;

      expect(topCust.first.totalRevenue, equals(500.0));
      expect(outstanding.first.totalOutstanding, equals(500.0));

      // Update invoice amount from 500.0 to 1800.0
      await docsDao.updateDocumentWithLines(
        doc: DocumentsCompanion(
          id: Value(docId),
          documentNumber: const Value('INV-0002'),
          type: const Value('invoice'),
          customerId: Value(custId),
          customerName: const Value('Ponsri Water Tech'),
          date: Value(now),
          subtotal: const Value(1800.0),
          grandTotal: const Value(1800.0),
          amountReceived: const Value(0.0),
          balanceDue: const Value(1800.0),
          status: const Value('unpaid'),
        ),
        lines: [],
      );

      await Future.delayed(const Duration(milliseconds: 100));

      topCust = container.read(topCustomersProvider).asData!.value;
      outstanding = container.read(outstandingReportProvider).asData!.value;

      expect(topCust.first.totalRevenue, equals(1800.0));
      expect(outstanding.first.totalOutstanding, equals(1800.0));
    });
  });
}
