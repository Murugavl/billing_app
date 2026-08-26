import 'package:rasidhu/services/document_numbering_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DocumentNumberingService Unit Tests', () {
    test('Calculates Financial Year correctly (April-March convention)', () {
      // August 2026 -> FY 26-27
      final dateAug2026 = DateTime(2026, 8, 26);
      expect(DocumentNumberingService.calculateFinancialYear(dateAug2026), '26-27');

      // January 2027 -> FY 26-27
      final dateJan2027 = DateTime(2027, 1, 15);
      expect(DocumentNumberingService.calculateFinancialYear(dateJan2027), '26-27');

      // March 2026 -> FY 25-26
      final dateMar2026 = DateTime(2026, 3, 31);
      expect(DocumentNumberingService.calculateFinancialYear(dateMar2026), '25-26');

      // April 1, 2026 -> FY 26-27
      final dateApr2026 = DateTime(2026, 4, 1);
      expect(DocumentNumberingService.calculateFinancialYear(dateApr2026), '26-27');
    });

    test('Formats custom template {PREFIX}/{FY}/{SEQ} with prefix GE and sequence 1', () {
      final formatted = DocumentNumberingService.formatDocumentNumber(
        template: '{PREFIX}/{FY}/{SEQ}',
        prefix: 'GE',
        sequence: 1,
        padding: 3,
        separator: '/',
        date: DateTime(2026, 8, 26),
      );

      expect(formatted, 'GE/26-27/001');
    });

    test('Formats sequence number 2 correctly with incrementing', () {
      final formatted = DocumentNumberingService.formatDocumentNumber(
        template: '{PREFIX}/{FY}/{SEQ}',
        prefix: 'GE',
        sequence: 2,
        padding: 3,
        separator: '/',
        date: DateTime(2026, 8, 26),
      );

      expect(formatted, 'GE/26-27/002');
    });

    test('Formats default template {PREFIX}-{SEQ} with prefix INV', () {
      final formatted = DocumentNumberingService.formatDocumentNumber(
        template: '{PREFIX}-{SEQ}',
        prefix: 'INV',
        sequence: 1,
        padding: 4,
        separator: '-',
        date: DateTime(2026, 8, 26),
      );

      expect(formatted, 'INV-0001');
    });

    test('Handles custom separator with {SEP} placeholder', () {
      final formatted = DocumentNumberingService.formatDocumentNumber(
        template: '{PREFIX}{SEP}{FY}{SEP}{SEQ}',
        prefix: 'PUR',
        sequence: 5,
        padding: 4,
        separator: '/',
        date: DateTime(2026, 8, 26),
      );

      expect(formatted, 'PUR/26-27/0005');
    });
  });
}
