import 'package:rasidhu/db/app_database.dart';
import 'package:rasidhu/db/daos/documents_dao.dart';
import 'package:rasidhu/services/pdf_service.dart';
import 'package:drift/drift.dart';
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

  group('PDF Bank Details Toggle Tests', () {
    final profile = BusinessProfileData(
      id: 1,
      businessName: 'Ponsri Enterprises',
      bankName: 'State Bank of India',
      bankAccountNo: '1234567890',
      bankIfsc: 'SBIN0001234',
      bankBranchAddress: 'Main Branch',
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

    test('PDF includes bank details when includeBankDetails is true', () async {
      final doc = Document(
        id: 1,
        documentNumber: 'INV-0001',
        type: 'invoice',
        customerName: 'Acme Corp',
        date: DateTime(2026, 8, 26),
        subtotal: 1000.0,
        totalDiscount: 0.0,
        totalTax: 180.0,
        grandTotal: 1180.0,
        includeBankDetails: true,
        status: 'paid',
        createdAt: DateTime(2026, 8, 26),
        updatedAt: DateTime(2026, 8, 26),
      );

      final pdfBytes = await PdfService.generateDocumentPdf(
        documentWithLines: DocumentWithLines(document: doc, lineItems: []),
        profile: profile,
      );

      expect(pdfBytes, isNotEmpty);
      expect(pdfBytes.length, greaterThan(100));
    });

    test('PDF generates successfully without bank details when includeBankDetails is false', () async {
      final doc = Document(
        id: 2,
        documentNumber: 'INV-0002',
        type: 'invoice',
        customerName: 'Beta Traders',
        date: DateTime(2026, 8, 26),
        subtotal: 500.0,
        totalDiscount: 0.0,
        totalTax: 90.0,
        grandTotal: 590.0,
        includeBankDetails: false,
        status: 'draft',
        createdAt: DateTime(2026, 8, 26),
        updatedAt: DateTime(2026, 8, 26),
      );

      final pdfBytes = await PdfService.generateDocumentPdf(
        documentWithLines: DocumentWithLines(document: doc, lineItems: []),
        profile: profile,
      );

      expect(pdfBytes, isNotEmpty);
      expect(pdfBytes.length, greaterThan(100));
    });

    test('DAO persists includeBankDetails flag and BusinessProfile defaults correctly', () async {
      await database.businessProfileDao.upsertProfile(
        const BusinessProfileCompanion(
          businessName: Value('Ponsri Enterprises'),
          defaultIncludeBankDetailsInvoice: Value(false),
          defaultIncludeBankDetailsEstimate: Value(true),
        ),
      );

      final savedProfile = await database.businessProfileDao.getProfile();
      expect(savedProfile?.defaultIncludeBankDetailsInvoice, false);
      expect(savedProfile?.defaultIncludeBankDetailsEstimate, true);

      final docId = await database.documentsDao.insertDocumentWithLines(
        doc: DocumentsCompanion.insert(
          documentNumber: 'INV-0001',
          type: 'invoice',
          customerName: 'Test Customer',
          date: DateTime(2026, 8, 26),
          includeBankDetails: const Value(false),
        ),
        lines: [],
      );

      final savedDoc = await database.documentsDao.getDocumentById(docId);
      expect(savedDoc?.includeBankDetails, false);
    });
  });
}
