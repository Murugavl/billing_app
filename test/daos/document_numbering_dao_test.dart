import 'package:rasidhu/db/app_database.dart';
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

  group('Document Numbering DAO Integration Tests', () {
    test('Generates default invoice and estimate numbers', () async {
      final invNum = await database.documentsDao.nextDocumentNumber('invoice');
      expect(invNum, 'INV-0001');

      final estNum = await database.documentsDao.nextDocumentNumber('estimate');
      expect(estNum, 'EST-0001');

      final purNum = await database.purchaseBillsDao.nextPurchaseBillNumber();
      expect(purNum, 'PUR-0001');
    });

    test('Uses custom format {PREFIX}/{FY}/{SEQ} with prefix GE and increments sequence', () async {
      // 1. Configure custom format in BusinessProfile
      await database.businessProfileDao.upsertProfile(
        const BusinessProfileCompanion(
          invoiceNumberPrefix: Value('GE'),
          invoiceNumberFormat: Value('{PREFIX}/{FY}/{SEQ}'),
          invoiceNumberPadding: Value(3),
          invoiceNumberSeparator: Value('/'),
          invoiceNextSequence: Value(1),
        ),
      );

      final date = DateTime(2026, 8, 26);

      // 2. Next preview number should be GE/26-27/001
      final nextNum1 = await database.documentsDao.nextDocumentNumber('invoice', date: date);
      expect(nextNum1, 'GE/26-27/001');

      // 3. Consume first document number
      final consumedNum1 = await database.documentsDao.consumeNextDocumentNumber('invoice', date: date);
      expect(consumedNum1, 'GE/26-27/001');

      // 4. Consume second document number -> should increment sequence to 2
      final consumedNum2 = await database.documentsDao.consumeNextDocumentNumber('invoice', date: date);
      expect(consumedNum2, 'GE/26-27/002');

      // 5. Consume third document number -> should increment sequence to 3
      final consumedNum3 = await database.documentsDao.consumeNextDocumentNumber('invoice', date: date);
      expect(consumedNum3, 'GE/26-27/003');
    });
  });
}
