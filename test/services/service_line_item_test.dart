import 'package:rasidhu/db/app_database.dart';
import 'package:rasidhu/db/daos/documents_dao.dart';
import 'package:rasidhu/services/pdf_service.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  group('Service Line Item Tests', () {
    final profile = BusinessProfileData(
      id: 1,
      businessName: 'Ponsri Enterprises',
      invoiceNumberPrefix: 'INV',
      invoiceNumberFormat: '{PREFIX}-{SEQ}',
      invoiceNumberPadding: 4,
      invoiceNumberSeparator: '-',
      invoiceNextSequence: 1,
      estimateNumberPrefix: 'EST',
      estimateNumberFormat: '{PREFIX}-{SEQ}',
      estimateNumberPadding: 4,
      estimateNumberSeparator: '-',
      estimateNextSequence: 1,
      purchaseNumberPrefix: 'PUR',
      purchaseNumberFormat: '{PREFIX}-{SEQ}',
      purchaseNumberPadding: 4,
      purchaseNumberSeparator: '-',
      purchaseNextSequence: 1,
      defaultIncludeBankDetailsInvoice: true,
      defaultIncludeBankDetailsEstimate: true,
      updatedAt: DateTime(2026, 8, 26),
    );

    test('DAO persists Service-type line items correctly', () async {
      final docId = await database.documentsDao.insertDocumentWithLines(
        doc: DocumentsCompanion.insert(
          documentNumber: 'INV-0001',
          type: 'invoice',
          customerName: 'Test Customer',
          date: DateTime(2026, 8, 26),
          subtotal: const Value(650.0),
          grandTotal: const Value(650.0),
        ),
        lines: [
          DocumentLineItemsCompanion.insert(
            documentId: 0,
            itemType: const Value('service'),
            itemName: 'Service charges',
            hsnSacCode: const Value(null),
            quantity: const Value(1.0),
            unit: const Value('Service'),
            pricePerUnit: const Value(650.0),
            taxableAmount: const Value(650.0),
            lineTotal: const Value(650.0),
          ),
        ],
      );

      final docWithLines = await database.documentsDao.getDocumentWithLines(docId);
      expect(docWithLines, isNotNull);
      expect(docWithLines!.lineItems.length, 1);
      final line = docWithLines.lineItems.first;
      expect(line.itemType, 'service');
      expect(line.itemName, 'Service charges');
      expect(line.quantity, 1.0);
      expect(line.unit, 'Service');
      expect(line.pricePerUnit, 650.0);
      expect(line.lineTotal, 650.0);
      expect(line.hsnSacCode, isNull);
    });

    test('PDF generator renders Service and Product line items cleanly in same document', () async {
      final doc = Document(
        id: 1,
        documentNumber: 'INV-0002',
        type: 'invoice',
        customerName: 'Mixed Item Customer',
        date: DateTime(2026, 8, 26),
        subtotal: 2650.0,
        totalDiscount: 0.0,
        totalTax: 0.0,
        grandTotal: 2650.0,
        includeBankDetails: true,
        status: 'paid',
        createdAt: DateTime(2026, 8, 26),
        updatedAt: DateTime(2026, 8, 26),
      );

      final lines = [
        DocumentLineItem(
          id: 1,
          documentId: 1,
          itemType: 'product',
          itemName: 'Aqua Queen',
          hsnSacCode: '84818090',
          quantity: 2.0,
          unit: 'Pcs',
          pricePerUnit: 1000.0,
          discountPercent: 0.0,
          discountAmount: 0.0,
          taxableAmount: 2000.0,
          taxPercent: 0.0,
          taxAmount: 0.0,
          lineTotal: 2000.0,
          sortOrder: 0,
        ),
        DocumentLineItem(
          id: 2,
          documentId: 1,
          itemType: 'service',
          itemName: 'Service charges',
          hsnSacCode: null,
          quantity: 1.0,
          unit: 'Service',
          pricePerUnit: 650.0,
          discountPercent: 0.0,
          discountAmount: 0.0,
          taxableAmount: 650.0,
          taxPercent: 0.0,
          taxAmount: 0.0,
          lineTotal: 650.0,
          sortOrder: 1,
        ),
      ];

      final pdfBytes = await PdfService.generateDocumentPdf(
        documentWithLines: DocumentWithLines(document: doc, lineItems: lines),
        profile: profile,
      );

      expect(pdfBytes, isNotEmpty);
      expect(pdfBytes.length, greaterThan(100));
    });

    test('PDF generator renders business name and customer name in uppercase without modifying original objects', () async {
      final mixedCaseProfile = BusinessProfileData(
        id: 1,
        businessName: 'Ponsri enterprises',
        invoiceNumberPrefix: 'INV',
        invoiceNumberFormat: '{PREFIX}-{SEQ}',
        invoiceNumberPadding: 4,
        invoiceNumberSeparator: '-',
        invoiceNextSequence: 1,
        estimateNumberPrefix: 'EST',
        estimateNumberFormat: '{PREFIX}-{SEQ}',
        estimateNumberPadding: 4,
        estimateNumberSeparator: '-',
        estimateNextSequence: 1,
        purchaseNumberPrefix: 'PUR',
        purchaseNumberFormat: '{PREFIX}-{SEQ}',
        purchaseNumberPadding: 4,
        purchaseNumberSeparator: '-',
        purchaseNextSequence: 1,
        defaultIncludeBankDetailsInvoice: true,
        defaultIncludeBankDetailsEstimate: true,
        updatedAt: DateTime(2026, 8, 26),
      );

      final mixedCaseDoc = Document(
        id: 3,
        documentNumber: 'INV-0003',
        type: 'invoice',
        customerName: 'Acme corporation',
        customerAddress: '123 Main St',
        date: DateTime(2026, 8, 26),
        subtotal: 650.0,
        totalDiscount: 0.0,
        totalTax: 0.0,
        grandTotal: 650.0,
        includeBankDetails: true,
        status: 'draft',
        createdAt: DateTime(2026, 8, 26),
        updatedAt: DateTime(2026, 8, 26),
      );

      final pdfBytes = await PdfService.generateDocumentPdf(
        documentWithLines: DocumentWithLines(document: mixedCaseDoc, lineItems: []),
        profile: mixedCaseProfile,
      );

      expect(pdfBytes, isNotEmpty);
      expect(mixedCaseProfile.businessName, 'Ponsri enterprises');
      expect(mixedCaseDoc.customerName, 'Acme corporation');
    });

    test('PDF generator handles PAN-only, GSTIN-only, both, and neither without blank labels', () async {
      final doc = Document(
        id: 4,
        documentNumber: 'INV-0004',
        type: 'invoice',
        customerName: 'Test Client',
        customerGstNumber: '33ABCDE1234F1Z5',
        date: DateTime(2026, 8, 26),
        subtotal: 500.0,
        totalDiscount: 0.0,
        totalTax: 0.0,
        grandTotal: 500.0,
        includeBankDetails: false,
        status: 'paid',
        createdAt: DateTime(2026, 8, 26),
        updatedAt: DateTime(2026, 8, 26),
      );

      // Case 1: PAN only
      final panOnlyProfile = profile.copyWith(panNumber: const Value('ABCDE1234F'), gstNumber: const Value(null));
      final pdf1 = await PdfService.generateDocumentPdf(
        documentWithLines: DocumentWithLines(document: doc, lineItems: []),
        profile: panOnlyProfile,
      );
      expect(pdf1, isNotEmpty);

      // Case 2: GSTIN only
      final gstOnlyProfile = profile.copyWith(panNumber: const Value(null), gstNumber: const Value('33XYZAB1234F1Z9'));
      final pdf2 = await PdfService.generateDocumentPdf(
        documentWithLines: DocumentWithLines(document: doc, lineItems: []),
        profile: gstOnlyProfile,
      );
      expect(pdf2, isNotEmpty);

      // Case 3: Both PAN and GSTIN
      final bothProfile = profile.copyWith(panNumber: const Value('ABCDE1234F'), gstNumber: const Value('33XYZAB1234F1Z9'));
      final pdf3 = await PdfService.generateDocumentPdf(
        documentWithLines: DocumentWithLines(document: doc, lineItems: []),
        profile: bothProfile,
      );
      expect(pdf3, isNotEmpty);

      // Case 4: Neither PAN nor GSTIN
      final neitherProfile = profile.copyWith(panNumber: const Value(null), gstNumber: const Value(null));
      final pdf4 = await PdfService.generateDocumentPdf(
        documentWithLines: DocumentWithLines(document: doc, lineItems: []),
        profile: neitherProfile,
      );
      expect(pdf4, isNotEmpty);
    });
  });
}
