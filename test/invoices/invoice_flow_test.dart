// Invoice Flow & Sample Verification Unit Test
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

  group('Invoice Calculation & Sample Data Verification', () {
    test('Aqua Queen sample calculation produces exact ₹8,000.03 line & grand total', () {
      final line = LineItemData(
        itemName: 'Aqua Queen',
        hsnSacCode: '84818090',
        quantity: 1.0,
        unit: 'Pcs',
        pricePerUnit: 8500.0,
        isPercentDiscount: true,
        discountPercent: 5.882, // 5.882% rounded as on actual sample
        taxPercent: 0.0,
      );

      expect(line.subtotal, 8500.0);
      expect(line.calculatedDiscountAmount, 499.97);
      expect(line.taxableAmount, 8000.03);
      expect(line.taxAmount, 0.0);
      expect(line.lineTotal, 8000.03);

      final words = NumberToWords.convert(line.lineTotal);
      expect(words, 'Eight Thousand Rupees and Three Paise Only');
    });

    test('Full invoice creation and DB persistence with Aqua Queen sample', () async {
      final custId = await db.customersDao.insertCustomer(
        const CustomersCompanion(
          name: Value('Aqua Solutions Pvt Ltd'),
          phone: Value('9000011111'),
          address: Value('12, Industrial Estate, Chennai'),
          gstNumber: Value('33AAQCS1234B1Z9'),
        ),
      );

      final line = LineItemData(
        itemName: 'Aqua Queen',
        hsnSacCode: '84818090',
        quantity: 1.0,
        unit: 'Pcs',
        pricePerUnit: 8500.0,
        isPercentDiscount: true,
        discountPercent: 5.882,
        taxPercent: 0.0,
      );

      final docId = await db.documentsDao.insertDocumentWithLines(
        doc: DocumentsCompanion(
          documentNumber: const Value('INV-0001'),
          type: const Value('invoice'),
          customerId: Value(custId),
          customerName: const Value('Aqua Solutions Pvt Ltd'),
          customerPhone: const Value('9000011111'),
          customerAddress: const Value('12, Industrial Estate, Chennai'),
          customerGstNumber: const Value('33AAQCS1234B1Z9'),
          date: Value(DateTime(2025, 5, 1)),
          placeOfSupply: const Value('Tamil Nadu'),
          subtotal: Value(line.subtotal),
          totalDiscount: Value(line.calculatedDiscountAmount),
          totalTax: Value(line.taxAmount),
          grandTotal: Value(line.lineTotal),
          amountReceived: const Value(0.0),
          balanceDue: Value(line.lineTotal),
          amountInWords: Value(NumberToWords.convert(line.lineTotal)),
          status: const Value('sent'),
        ),
        lines: [
          DocumentLineItemsCompanion(
            itemName: Value(line.itemName),
            hsnSacCode: Value(line.hsnSacCode),
            quantity: Value(line.quantity),
            unit: Value(line.unit),
            pricePerUnit: Value(line.pricePerUnit),
            discountPercent: Value(line.calculatedDiscountPercent),
            discountAmount: Value(line.calculatedDiscountAmount),
            taxableAmount: Value(line.taxableAmount),
            taxPercent: Value(line.taxPercent),
            taxAmount: Value(line.taxAmount),
            lineTotal: Value(line.lineTotal),
          ),
        ],
      );

      final fetched = await db.documentsDao.getDocumentWithLines(docId);
      expect(fetched, isNotNull);
      final doc = fetched!.document;
      expect(doc.documentNumber, 'INV-0001');
      expect(doc.grandTotal, 8000.03);
      expect(doc.balanceDue, 8000.03);
      expect(doc.amountInWords, 'Eight Thousand Rupees and Three Paise Only');
      expect(fetched.lineItems.length, 1);
      expect(fetched.lineItems.first.lineTotal, 8000.03);
    });
  });
}
