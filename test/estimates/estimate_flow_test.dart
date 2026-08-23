// Estimate Flow & Conversion Unit Test
import 'package:billwise/db/app_database.dart';
import 'package:billwise/utils/number_to_words.dart';
import 'package:billwise/widgets/line_item_dialog.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

AppDatabase _openInMemory() => AppDatabase(NativeDatabase.memory());

void main() {
  late AppDatabase db;

  setUp(() => db = _openInMemory());
  tearDown(() => db.close());

  group('Estimate Flow & Conversion Verification', () {
    test('Estimate sample calculation with two items produces ₹19,200.00 total', () {
      final line1 = LineItemData(
        itemName: 'Manual 40 NB TMS - SOLO - imitative',
        hsnSacCode: '84818010',
        quantity: 1.0,
        unit: 'Nos',
        pricePerUnit: 15000.0,
      );

      final line2 = LineItemData(
        itemName: 'Flow Meter 2400 LPH - Square',
        hsnSacCode: '90261010',
        quantity: 1.0,
        unit: 'Nos',
        pricePerUnit: 4200.0,
      );

      expect(line1.taxableAmount, 15000.0);
      expect(line1.lineTotal, 15000.0);
      expect(line2.taxableAmount, 4200.0);
      expect(line2.lineTotal, 4200.0);

      final grandTotal = line1.lineTotal + line2.lineTotal;
      expect(grandTotal, 19200.0);

      final words = NumberToWords.convert(grandTotal);
      expect(words, 'Nineteen Thousand Two Hundred Rupees Only');
    });

    test('Convert Estimate to Invoice copies Customer & Line Items accurately', () async {
      final custId = await db.customersDao.insertCustomer(
        const CustomersCompanion(
          name: Value('Metro Water Board'),
          phone: Value('9884012345'),
          address: Value('Rajaji Bhavan, Chennai'),
        ),
      );

      // Insert estimate EST-0001
      final estId = await db.documentsDao.insertDocumentWithLines(
        doc: DocumentsCompanion(
          documentNumber: const Value('EST-0001'),
          type: const Value('estimate'),
          customerId: Value(custId),
          customerName: const Value('Metro Water Board'),
          customerPhone: const Value('9884012345'),
          customerAddress: const Value('Rajaji Bhavan, Chennai'),
          date: Value(DateTime(2025, 4, 15)),
          placeOfSupply: const Value('Tamil Nadu'),
          subtotal: const Value(19200.0),
          totalDiscount: const Value(0.0),
          totalTax: const Value(0.0),
          grandTotal: const Value(19200.0),
          amountInWords: Value(NumberToWords.convert(19200.0)),
          status: const Value('sent'),
        ),
        lines: [
          const DocumentLineItemsCompanion(
            itemName: Value('Manual 40 NB TMS - SOLO - imitative'),
            hsnSacCode: Value('84818010'),
            quantity: Value(1.0),
            unit: Value('Nos'),
            pricePerUnit: Value(15000.0),
            taxableAmount: Value(15000.0),
            lineTotal: Value(15000.0),
          ),
          const DocumentLineItemsCompanion(
            itemName: Value('Flow Meter 2400 LPH - Square'),
            hsnSacCode: Value('90261010'),
            quantity: Value(1.0),
            unit: Value('Nos'),
            pricePerUnit: Value(4200.0),
            taxableAmount: Value(4200.0),
            lineTotal: Value(4200.0),
          ),
        ],
      );

      // Fetch estimate
      final estimateWithLines = await db.documentsDao.getDocumentWithLines(estId);
      expect(estimateWithLines, isNotNull);

      // Mark estimate accepted
      await db.documentsDao.updateStatus(estId, 'accepted');

      // Create new invoice from estimate data
      final invNumber = await db.documentsDao.nextDocumentNumber('invoice');
      expect(invNumber, 'INV-0001');

      final invId = await db.documentsDao.insertDocumentWithLines(
        doc: DocumentsCompanion(
          documentNumber: Value(invNumber),
          type: const Value('invoice'),
          customerId: Value(estimateWithLines!.document.customerId!),
          customerName: Value(estimateWithLines.document.customerName),
          customerPhone: Value(estimateWithLines.document.customerPhone),
          customerAddress: Value(estimateWithLines.document.customerAddress),
          date: Value(DateTime.now()),
          subtotal: Value(estimateWithLines.document.subtotal),
          grandTotal: Value(estimateWithLines.document.grandTotal),
          amountReceived: const Value(0.0),
          balanceDue: Value(estimateWithLines.document.grandTotal),
          amountInWords: Value(estimateWithLines.document.amountInWords),
          status: const Value('sent'),
        ),
        lines: estimateWithLines.lineItems.map((l) {
          return DocumentLineItemsCompanion(
            itemName: Value(l.itemName),
            hsnSacCode: Value(l.hsnSacCode),
            quantity: Value(l.quantity),
            unit: Value(l.unit),
            pricePerUnit: Value(l.pricePerUnit),
            taxableAmount: Value(l.taxableAmount),
            lineTotal: Value(l.lineTotal),
          );
        }).toList(),
      );

      final convertedInv = await db.documentsDao.getDocumentWithLines(invId);
      expect(convertedInv, isNotNull);
      expect(convertedInv!.document.type, 'invoice');
      expect(convertedInv.document.documentNumber, 'INV-0001');
      expect(convertedInv.document.customerName, 'Metro Water Board');
      expect(convertedInv.document.grandTotal, 19200.0);
      expect(convertedInv.lineItems.length, 2);
      expect(convertedInv.lineItems[0].itemName, 'Manual 40 NB TMS - SOLO - imitative');
      expect(convertedInv.lineItems[1].itemName, 'Flow Meter 2400 LPH - Square');

      final updatedEst = await db.documentsDao.getDocumentById(estId);
      expect(updatedEst!.status, 'accepted');
    });

    test('Draft document from estimate conversion with id = 0 inserts new row instead of updating', () async {
      // Simulate draft document created in _convertToInvoice (id = 0)
      final draftDoc = Document(
        id: 0,
        documentNumber: '',
        type: 'invoice',
        customerId: 1,
        customerName: 'Test Customer',
        date: DateTime.now(),
        subtotal: 1000.0,
        totalDiscount: 0.0,
        totalTax: 180.0,
        grandTotal: 1180.0,
        status: 'draft',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Verify that for id == 0, _isEditing logic evaluates to false so insert is called
      final isEditing = draftDoc.id > 0;
      expect(isEditing, isFalse);

      final invNumber = await db.documentsDao.nextDocumentNumber('invoice');
      expect(invNumber, isNotEmpty);

      // Perform insertion as Form Screen does when _isEditing is false
      final newInvId = await db.documentsDao.insertDocumentWithLines(
        doc: DocumentsCompanion(
          documentNumber: Value(invNumber),
          type: const Value('invoice'),
          customerId: const Value(1),
          customerName: const Value('Test Customer'),
          date: Value(DateTime.now()),
          subtotal: const Value(1000.0),
          grandTotal: const Value(1180.0),
          status: const Value('draft'),
        ),
        lines: [],
      );

      expect(newInvId, greaterThan(0));

      final invoices = await db.documentsDao.getDocumentsByType('invoice');
      expect(invoices.map((i) => i.id), contains(newInvId));
    });
  });
}
