// Unit tests for the billing app database schema
// Tests seed sample data mirroring real invoice/estimate shapes.
//
// Run with: flutter test test/db/database_test.dart

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:billwise/db/app_database.dart';
import 'package:billwise/models/enums.dart';

// ── Helpers ──────────────────────────────────────────────────────────────────

/// Creates a fully in-memory AppDatabase for each test (no disk I/O).
AppDatabase _openInMemory() => AppDatabase(NativeDatabase.memory());

/// Rounds to 2 decimal places (matches invoice arithmetic).
double r(double v) => double.parse(v.toStringAsFixed(2));

void main() {
  late AppDatabase db;

  setUp(() => db = _openInMemory());
  tearDown(() => db.close());

  // ── 1. BusinessProfile ───────────────────────────────────────────────────────
  group('BusinessProfile', () {
    test('upsert creates profile; re-upsert replaces it', () async {
      await db.businessProfileDao.upsertProfile(
        const BusinessProfileCompanion(
          businessName: Value('Ponsri Enterprises'),
          gstNumber: Value('33AABCP1234A1Z5'),
          phone: Value('9876543210'),
          bankName: Value('State Bank of India'),
          bankAccountNo: Value('123456789012'),
          bankIfsc: Value('SBIN0001234'),
        ),
      );

      final profile = await db.businessProfileDao.getProfile();
      expect(profile, isNotNull);
      expect(profile!.businessName, 'Ponsri Enterprises');
      expect(profile.gstNumber, '33AABCP1234A1Z5');
      expect(profile.id, 1); // singleton

      // Re-upsert should update, not insert a second row
      await db.businessProfileDao.upsertProfile(
        const BusinessProfileCompanion(
          businessName: Value('Ponsri Enterprises Pvt Ltd'),
          gstNumber: Value('33AABCP1234A1Z5'),
        ),
      );
      final all = await db.select(db.businessProfile).get();
      expect(all.length, 1);
      expect(all.first.businessName, 'Ponsri Enterprises Pvt Ltd');
    });
  });

  // ── 2. Customers ─────────────────────────────────────────────────────────────
  group('Customers', () {
    test('insert, read, update, delete', () async {
      final id = await db.customersDao.insertCustomer(
        const CustomersCompanion(
          name: Value('Aqua Solutions Pvt Ltd'),
          phone: Value('9000011111'),
          address: Value('12, Industrial Estate, Chennai - 600001'),
          gstNumber: Value('33AAQCS1234B1Z9'),
        ),
      );
      expect(id, greaterThan(0));

      final customer = await db.customersDao.getCustomerById(id);
      expect(customer, isNotNull);
      expect(customer!.name, 'Aqua Solutions Pvt Ltd');

      // Update
      await db.customersDao.updateCustomer(
        customer.toCompanion(true).copyWith(
          email: const Value('billing@aquasolutions.in'),
        ),
      );
      final updated = await db.customersDao.getCustomerById(id);
      expect(updated!.email, 'billing@aquasolutions.in');

      // Delete
      await db.customersDao.deleteCustomer(id);
      expect(await db.customersDao.getCustomerById(id), isNull);
    });

    test('search by name is case-insensitive', () async {
      await db.customersDao.insertCustomer(
        const CustomersCompanion(name: Value('Global Pumps Ltd')),
      );
      final results = await db.customersDao.searchCustomers('global');
      expect(results, isNotEmpty);
      expect(results.first.name, 'Global Pumps Ltd');
    });
  });

  // ── 3. Items ─────────────────────────────────────────────────────────────────
  group('Items', () {
    test('insert and retrieve with HSN code and tax', () async {
      final id = await db.itemsDao.insertItem(
        const ItemsCompanion(
          name: Value('Aqua Queen'),
          hsnSacCode: Value('84818090'), // 8-digit HSN
          defaultUnit: Value('Pcs'),
          defaultPrice: Value(8500.0),
          defaultTaxPercent: Value(18.0),
        ),
      );

      final item = await db.itemsDao.getItemById(id);
      expect(item, isNotNull);
      expect(item!.hsnSacCode, '84818090');
      expect(item.defaultTaxPercent, 18.0);
    });
  });

  // ── 4. Invoice — Aqua Queen sample ──────────────────────────────────────────
  //
  // Real sample:
  //   Item     : Aqua Queen, HSN 84818090
  //   Qty      : 1 Pcs
  //   Price    : ₹8,500
  //   Discount : 5.882% → ₹499.97
  //   Taxable  : ₹8,000.03
  //   Tax (0%) : ₹0  (exempt or 0-rated; line total = taxable)
  //   Line total: ₹8,000.03
  //
  group('Invoice — Aqua Queen sample', () {
    late int customerId;

    setUp(() async {
      customerId = await db.customersDao.insertCustomer(
        const CustomersCompanion(
          name: Value('Aqua Solutions Pvt Ltd'),
          phone: Value('9000011111'),
          address: Value('12, Industrial Estate, Chennai'),
          gstNumber: Value('33AAQCS1234B1Z9'),
        ),
      );
    });

    test('creates invoice with correct line-item financials', () async {
      const qty = 1.0;
      const price = 8500.0;
      // Real invoice uses 5.882% (rounded display), NOT the exact fraction 5/85.
      // 8500 × 5.882% = 499.97 → taxable = 8000.03 (as on the actual document).
      const discountPct = 5.882;
      final discountAmt = r(qty * price * discountPct / 100); // 499.97
      final taxable = r(qty * price - discountAmt);           // 8000.03
      const taxPct = 0.0;
      final taxAmt = r(taxable * taxPct / 100);               // 0.0
      final lineTotal = r(taxable + taxAmt);                  // 8000.03

      final docId = await db.documentsDao.insertDocumentWithLines(
        doc: DocumentsCompanion(
          documentNumber: const Value('INV-0001'),
          type: const Value('invoice'),
          customerId: Value(customerId),
          customerName: const Value('Aqua Solutions Pvt Ltd'),
          customerAddress: const Value('12, Industrial Estate, Chennai'),
          customerGstNumber: const Value('33AAQCS1234B1Z9'),
          date: Value(DateTime(2025, 5, 1)),
          placeOfSupply: const Value('Tamil Nadu'),
          subtotal: Value(qty * price),
          totalDiscount: Value(discountAmt),
          totalTax: Value(taxAmt),
          grandTotal: Value(lineTotal),
          amountReceived: const Value(0.0),
          balanceDue: Value(lineTotal),
          amountInWords: const Value('Rupees Eight Thousand Only'),
          status: const Value('draft'),
        ),
        lines: [
          DocumentLineItemsCompanion(
            itemName: const Value('Aqua Queen'),
            hsnSacCode: const Value('84818090'),
            quantity: const Value(qty),
            unit: const Value('Pcs'),
            pricePerUnit: const Value(price),
            discountPercent: Value(discountPct),
            discountAmount: Value(discountAmt),
            taxableAmount: Value(taxable),
            taxPercent: const Value(taxPct),
            taxAmount: Value(taxAmt),
            lineTotal: Value(lineTotal),
          ),
        ],
      );

      final result = await db.documentsDao.getDocumentWithLines(docId);
      expect(result, isNotNull);

      final doc = result!.document;
      expect(doc.type, 'invoice');
      expect(doc.documentNumber, 'INV-0001');
      expect(doc.grandTotal, closeTo(8000.03, 0.01));
      expect(doc.balanceDue, closeTo(8000.03, 0.01));
      expect(doc.amountInWords, 'Rupees Eight Thousand Only');

      expect(result.lineItems.length, 1);
      final line = result.lineItems.first;
      expect(line.itemName, 'Aqua Queen');
      expect(line.hsnSacCode, '84818090');
      expect(line.quantity, 1.0);
      expect(line.unit, 'Pcs');
      expect(line.pricePerUnit, 8500.0);
      expect(line.discountPercent, closeTo(5.882, 0.001));
      expect(line.discountAmount, closeTo(499.97, 0.01));
      expect(line.taxableAmount, closeTo(8000.03, 0.01));
      expect(line.taxPercent, 0.0);
      expect(line.taxAmount, 0.0);
      expect(line.lineTotal, closeTo(8000.03, 0.01));
    });

    test('document number sequence increments per type', () async {
      expect(await db.documentsDao.nextDocumentNumber('invoice'), 'INV-0001');

      await db.documentsDao.insertDocumentWithLines(
        doc: DocumentsCompanion(
          documentNumber: const Value('INV-0001'),
          type: const Value('invoice'),
          customerId: Value(customerId),
          customerName: const Value('Test'),
          date: Value(DateTime.now()),
          grandTotal: const Value(100.0),
        ),
        lines: [],
      );

      expect(await db.documentsDao.nextDocumentNumber('invoice'), 'INV-0002');
      // Estimate sequence is independent
      expect(await db.documentsDao.nextDocumentNumber('estimate'), 'EST-0001');
    });

    test('status transitions work', () async {
      final docId = await db.documentsDao.insertDocumentWithLines(
        doc: DocumentsCompanion(
          documentNumber: const Value('INV-0001'),
          type: const Value('invoice'),
          customerId: Value(customerId),
          customerName: const Value('Aqua Solutions Pvt Ltd'),
          date: Value(DateTime.now()),
          grandTotal: const Value(8000.03),
          balanceDue: const Value(8000.03),
          amountReceived: const Value(0.0),
        ),
        lines: [],
      );

      await db.documentsDao.updateStatus(docId, 'sent');
      var doc = await db.documentsDao.getDocumentById(docId);
      expect(doc!.status, 'sent');

      await db.documentsDao.updateStatus(docId, 'paid');
      doc = await db.documentsDao.getDocumentById(docId);
      expect(doc!.status, 'paid');
    });
  });

  // ── 5. Estimate — two-item sample ────────────────────────────────────────────
  //
  // Real sample:
  //   Item 1: Manual 40 NB TMS - SOLO - imitative, HSN 84818010, qty 1, Nos
  //           price ₹15,000, no discount, taxable = line total = ₹15,000
  //   Item 2: Flow Meter 2400 LPH - Square, HSN 90261010, qty 1, Nos
  //           price ₹4,200, no discount, taxable = line total = ₹4,200
  //
  group('Estimate — two-item sample', () {
    test('creates estimate with two lines, no discount, taxable = lineTotal',
        () async {
      // Item 1 financials
      const qty1 = 1.0;
      const price1 = 15000.0;
      final taxable1 = qty1 * price1; // 15000.0
      final lineTotal1 = taxable1; // no tax on estimate

      // Item 2 financials
      const qty2 = 1.0;
      const price2 = 4200.0;
      final taxable2 = qty2 * price2; // 4200.0
      final lineTotal2 = taxable2;

      final grandTotal = r(lineTotal1 + lineTotal2); // 19200.0

      final docId = await db.documentsDao.insertDocumentWithLines(
        doc: DocumentsCompanion(
          documentNumber: const Value('EST-0001'),
          type: const Value('estimate'),
          customerName: const Value('Metro Water Board'),
          customerAddress: const Value('Rajaji Bhavan, Chennai - 600002'),
          date: Value(DateTime(2025, 4, 15)),
          placeOfSupply: const Value('Tamil Nadu'),
          subtotal: Value(grandTotal),
          totalDiscount: const Value(0.0),
          totalTax: const Value(0.0),
          grandTotal: Value(grandTotal),
          status: const Value('draft'),
        ),
        lines: [
          DocumentLineItemsCompanion(
            itemName: const Value(
                'Manual 40 NB TMS - SOLO - imitative'),
            hsnSacCode: const Value('84818010'),
            quantity: const Value(qty1),
            unit: const Value('Nos'),
            pricePerUnit: const Value(price1),
            discountPercent: const Value(0.0),
            discountAmount: const Value(0.0),
            taxableAmount: Value(taxable1),
            taxPercent: const Value(0.0),
            taxAmount: const Value(0.0),
            lineTotal: Value(lineTotal1),
          ),
          DocumentLineItemsCompanion(
            itemName: const Value('Flow Meter 2400 LPH - Square'),
            hsnSacCode: const Value('90261010'),
            quantity: const Value(qty2),
            unit: const Value('Nos'),
            pricePerUnit: const Value(price2),
            discountPercent: const Value(0.0),
            discountAmount: const Value(0.0),
            taxableAmount: Value(taxable2),
            taxPercent: const Value(0.0),
            taxAmount: const Value(0.0),
            lineTotal: Value(lineTotal2),
          ),
        ],
      );

      final result = await db.documentsDao.getDocumentWithLines(docId);
      expect(result, isNotNull);

      final doc = result!.document;
      expect(doc.type, 'estimate');
      expect(doc.documentNumber, 'EST-0001');
      expect(doc.grandTotal, closeTo(19200.0, 0.01));
      expect(doc.totalDiscount, 0.0);
      expect(doc.totalTax, 0.0);
      // Estimates have no amountReceived / balanceDue
      expect(doc.amountReceived, isNull);
      expect(doc.balanceDue, isNull);

      expect(result.lineItems.length, 2);

      final line1 = result.lineItems[0];
      expect(line1.itemName, 'Manual 40 NB TMS - SOLO - imitative');
      expect(line1.hsnSacCode, '84818010');
      expect(line1.unit, 'Nos');
      expect(line1.discountPercent, 0.0);
      expect(line1.discountAmount, 0.0);
      expect(line1.taxableAmount, closeTo(15000.0, 0.01));
      expect(line1.lineTotal, closeTo(15000.0, 0.01));
      // taxable == lineTotal (no tax on estimate)
      expect(line1.taxableAmount, closeTo(line1.lineTotal, 0.001));

      final line2 = result.lineItems[1];
      expect(line2.itemName, 'Flow Meter 2400 LPH - Square');
      expect(line2.hsnSacCode, '90261010');
      expect(line2.taxableAmount, closeTo(4200.0, 0.01));
      expect(line2.lineTotal, closeTo(4200.0, 0.01));
      expect(line2.taxableAmount, closeTo(line2.lineTotal, 0.001));
    });

    test('estimate valid status transitions', () async {
      final docId = await db.documentsDao.insertDocumentWithLines(
        doc: DocumentsCompanion(
          documentNumber: const Value('EST-0001'),
          type: const Value('estimate'),
          customerName: const Value('Metro Water Board'),
          date: Value(DateTime.now()),
          grandTotal: const Value(19200.0),
        ),
        lines: [],
      );

      for (final status in ['draft', 'sent', 'accepted', 'expired']) {
        await db.documentsDao.updateStatus(docId, status);
        final doc = await db.documentsDao.getDocumentById(docId);
        expect(doc!.status, status);
      }
    });
  });

  // ── 6. Payments ──────────────────────────────────────────────────────────────
  group('Payments', () {
    late int invoiceId;
    const grandTotal = 8000.03;

    setUp(() async {
      invoiceId = await db.documentsDao.insertDocumentWithLines(
        doc: DocumentsCompanion(
          documentNumber: const Value('INV-0001'),
          type: const Value('invoice'),
          customerName: const Value('Aqua Solutions Pvt Ltd'),
          date: Value(DateTime.now()),
          grandTotal: const Value(grandTotal),
          amountReceived: const Value(0.0),
          balanceDue: const Value(grandTotal),
          status: const Value('sent'),
        ),
        lines: [],
      );
    });

    test('partial payment updates balanceDue and status', () async {
      await db.paymentsDao.recordPayment(
        companion: PaymentsCompanion(
          documentId: Value(invoiceId),
          amount: const Value(3000.0),
          date: Value(DateTime.now()),
          method: const Value('upi'),
        ),
        grandTotal: grandTotal,
      );

      final doc = await db.documentsDao.getDocumentById(invoiceId);
      expect(doc!.status, 'partially_paid');
      expect(doc.amountReceived, closeTo(3000.0, 0.01));
      expect(doc.balanceDue, closeTo(5000.03, 0.01));
    });

    test('full payment marks invoice as paid', () async {
      await db.paymentsDao.recordPayment(
        companion: PaymentsCompanion(
          documentId: Value(invoiceId),
          amount: const Value(grandTotal),
          date: Value(DateTime.now()),
          method: const Value('bank_transfer'),
        ),
        grandTotal: grandTotal,
      );

      final doc = await db.documentsDao.getDocumentById(invoiceId);
      expect(doc!.status, 'paid');
      expect(doc.balanceDue, closeTo(0.0, 0.01));
    });

    test('totalPaidForDocument sums multiple payments', () async {
      await db.paymentsDao.recordPayment(
        companion: PaymentsCompanion(
          documentId: Value(invoiceId),
          amount: const Value(2000.0),
          date: Value(DateTime.now()),
          method: const Value('cash'),
        ),
        grandTotal: grandTotal,
      );
      await db.paymentsDao.recordPayment(
        companion: PaymentsCompanion(
          documentId: Value(invoiceId),
          amount: const Value(3000.0),
          date: Value(DateTime.now()),
          method: const Value('upi'),
        ),
        grandTotal: grandTotal,
      );

      final total = await db.paymentsDao.totalPaidForDocument(invoiceId);
      expect(total, closeTo(5000.0, 0.01));

      final payments =
          await db.paymentsDao.getPaymentsForDocument(invoiceId);
      expect(payments.length, 2);
    });
  });

  // ── 7. Enum helpers ───────────────────────────────────────────────────────────
  group('Domain enums', () {
    test('DocumentType roundtrips', () {
      expect(DocumentType.fromString('invoice'), DocumentType.invoice);
      expect(DocumentType.fromString('estimate'), DocumentType.estimate);
      expect(DocumentType.invoice.value, 'invoice');
    });

    test('DocumentStatus roundtrips including partially_paid', () {
      expect(DocumentStatus.fromString('partially_paid'),
          DocumentStatus.partiallyPaid);
      expect(DocumentStatus.partiallyPaid.value, 'partially_paid');
      expect(DocumentStatus.fromString('accepted'), DocumentStatus.accepted);
    });

    test('PaymentMethod roundtrips', () {
      expect(PaymentMethod.fromString('bank_transfer'),
          PaymentMethod.bankTransfer);
      expect(PaymentMethod.bankTransfer.value, 'bank_transfer');
    });

    test('valid statuses per type', () {
      final invoiceStatuses =
          DocumentStatus.forType(DocumentType.invoice).map((s) => s.value);
      expect(invoiceStatuses, containsAll(['draft', 'paid', 'partially_paid']));
      expect(invoiceStatuses, isNot(contains('accepted')));

      final estimateStatuses =
          DocumentStatus.forType(DocumentType.estimate).map((s) => s.value);
      expect(estimateStatuses, containsAll(['accepted', 'expired']));
      expect(estimateStatuses, isNot(contains('paid')));
    });
  });

  // ── 8. Master data reference counts for deletion safety ────────────────────
  group('Master Data Delete Safety Checks', () {
    test('getDocumentCountForCustomer returns correct count', () async {
      final custId = await db.customersDao.insertCustomer(
        const CustomersCompanion(name: Value('Test Customer')),
      );

      expect(await db.documentsDao.getDocumentCountForCustomer(custId), 0);

      await db.documentsDao.insertDocumentWithLines(
        doc: DocumentsCompanion(
          documentNumber: const Value('INV-0100'),
          type: const Value('invoice'),
          customerId: Value(custId),
          customerName: const Value('Test Customer'),
          date: Value(DateTime.now()),
          grandTotal: const Value(100.0),
        ),
        lines: [],
      );

      expect(await db.documentsDao.getDocumentCountForCustomer(custId), 1);
    });

    test('getDocumentCountForItem returns correct line item count', () async {
      final itemId = await db.itemsDao.insertItem(
        const ItemsCompanion(
          name: Value('Aqua Filter'),
          defaultPrice: Value(500.0),
          defaultUnit: Value('Pcs'),
        ),
      );

      expect(await db.documentsDao.getDocumentCountForItem(itemId), 0);

      await db.documentsDao.insertDocumentWithLines(
        doc: DocumentsCompanion(
          documentNumber: const Value('INV-0101'),
          type: const Value('invoice'),
          customerName: const Value('Test Customer'),
          date: Value(DateTime.now()),
          grandTotal: const Value(500.0),
        ),
        lines: [
          DocumentLineItemsCompanion(
            itemId: Value(itemId),
            itemName: const Value('Aqua Filter'),
            pricePerUnit: const Value(500.0),
            quantity: const Value(1.0),
            lineTotal: const Value(500.0),
          ),
        ],
      );

      expect(await db.documentsDao.getDocumentCountForItem(itemId), 1);
    });
  });
}
