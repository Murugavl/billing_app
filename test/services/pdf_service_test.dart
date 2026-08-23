// PDF Service Unit Test
import 'dart:io';
import 'package:billwise/db/app_database.dart';
import 'package:billwise/services/pdf_service.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

AppDatabase _openInMemory() => AppDatabase(NativeDatabase.memory());

void main() {
  late AppDatabase db;

  setUp(() => db = _openInMemory());
  tearDown(() => db.close());

  group('PdfService Generation', () {
    test('generates non-empty Uint8List byte array for invoice PDF', () async {
      final custId = await db.customersDao.insertCustomer(
        const CustomersCompanion(
          name: Value('Aqua Solutions Pvt Ltd'),
          phone: Value('9000011111'),
          address: Value('12, Industrial Estate, Chennai'),
          gstNumber: Value('33AAQCS1234B1Z9'),
        ),
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
          date: Value(DateTime.now()),
          subtotal: const Value(8500.0),
          totalDiscount: const Value(499.97),
          totalTax: const Value(0.0),
          grandTotal: const Value(8000.03),
          amountInWords: const Value('Eight Thousand Rupees and Three Paise Only'),
          status: const Value('sent'),
        ),
        lines: [
          const DocumentLineItemsCompanion(
            itemName: Value('Aqua Queen'),
            hsnSacCode: Value('84818090'),
            quantity: Value(1.0),
            unit: Value('Pcs'),
            pricePerUnit: Value(8500.0),
            discountAmount: Value(499.97),
            taxableAmount: Value(8000.03),
            lineTotal: Value(8000.03),
          ),
        ],
      );

      final docWithLines = await db.documentsDao.getDocumentWithLines(docId);
      expect(docWithLines, isNotNull);

      final profile = BusinessProfileData(
        id: 1,
        businessName: 'Ponsri Enterprises',
        addressLine: 'Chennai, TN',
        phone: '9876543210',
        email: 'billing@ponsri.com',
        gstNumber: '33AABCP1234A1Z5',
        bankName: 'State Bank of India',
        bankAccountNo: '1234567890',
        bankIfsc: 'SBIN0001234',
        updatedAt: DateTime.now(),
      );

      final pdfBytes = await PdfService.generateDocumentPdf(
        documentWithLines: docWithLines!,
        profile: profile,
      );

      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(1000));
    });

    test('generates estimate PDF with uploaded logo and ₹3,540.00 currency values', () async {
      final custId = await db.customersDao.insertCustomer(
        const CustomersCompanion(
          name: Value('Metro Water Board'),
          phone: Value('9884012345'),
        ),
      );

      final docId = await db.documentsDao.insertDocumentWithLines(
        doc: DocumentsCompanion(
          documentNumber: const Value('EST-0001'),
          type: const Value('estimate'),
          customerId: Value(custId),
          customerName: const Value('Metro Water Board'),
          date: Value(DateTime.now()),
          subtotal: const Value(3540.0),
          totalDiscount: const Value(0.0),
          totalTax: const Value(540.0),
          grandTotal: const Value(3540.0),
          amountInWords: const Value('Three Thousand Five Hundred Forty Rupees Only'),
          status: const Value('sent'),
        ),
        lines: [
          const DocumentLineItemsCompanion(
            itemName: Value('Water Filter Cartridge'),
            quantity: Value(1.0),
            pricePerUnit: Value(3000.0),
            taxableAmount: Value(3000.0),
            taxAmount: Value(540.0),
            lineTotal: Value(3540.0),
          ),
        ],
      );

      final docWithLines = await db.documentsDao.getDocumentWithLines(docId);
      expect(docWithLines, isNotNull);

      final logoFile = File('assets/images/app_logo.png');

      final profile = BusinessProfileData(
        id: 1,
        businessName: 'Ponsri Enterprises',
        addressLine: 'Chennai, TN',
        logoPath: logoFile.existsSync() ? logoFile.path : null,
        phone: '9876543210',
        updatedAt: DateTime.now(),
      );

      final pdfBytes = await PdfService.generateDocumentPdf(
        documentWithLines: docWithLines!,
        profile: profile,
      );

      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(1000));
    });
  });
}
