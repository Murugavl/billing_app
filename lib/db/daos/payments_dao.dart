// DAO: PaymentsDao — partial payment tracking against invoices
import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/payments_table.dart';
import '../tables/documents_table.dart';

part 'payments_dao.g.dart';

@DriftAccessor(tables: [Payments, Documents])
class PaymentsDao extends DatabaseAccessor<AppDatabase>
    with _$PaymentsDaoMixin {
  PaymentsDao(super.db);

  // ── Read ────────────────────────────────────────────────────────────────────

  Future<List<Payment>> getPaymentsForDocument(int documentId) =>
      (select(payments)
            ..where((t) => t.documentId.equals(documentId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Stream<List<Payment>> watchPaymentsForDocument(int documentId) =>
      (select(payments)
            ..where((t) => t.documentId.equals(documentId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .watch();

  /// Total amount received for a given document.
  Future<double> totalPaidForDocument(int documentId) async {
    final expr = payments.amount.sum();
    final query = selectOnly(payments)
      ..addColumns([expr])
      ..where(payments.documentId.equals(documentId));
    final result = await query.map((r) => r.read(expr)).getSingle();
    return result ?? 0.0;
  }

  // ── Write ───────────────────────────────────────────────────────────────────

  /// Records a payment and updates the document's amountReceived + balanceDue
  /// + status, all in a single transaction.
  Future<int> recordPayment({
    required PaymentsCompanion companion,
    required double grandTotal,
  }) async {
    return db.transaction(() async {
      final paymentId = await into(payments).insert(companion);
      final docId = companion.documentId.value;

      // Recompute totals
      final totalPaid = await totalPaidForDocument(docId);
      final balanceDue = grandTotal - totalPaid;

      String newStatus;
      if (balanceDue <= 0) {
        newStatus = 'paid';
      } else if (totalPaid > 0) {
        newStatus = 'partially_paid';
      } else {
        newStatus = 'sent';
      }

      await (update(documents)..where((t) => t.id.equals(docId))).write(
        DocumentsCompanion(
          amountReceived: Value(totalPaid),
          balanceDue: Value(balanceDue < 0 ? 0.0 : balanceDue),
          status: Value(newStatus),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return paymentId;
    });
  }

  Future<int> deletePayment(int id) =>
      (delete(payments)..where((t) => t.id.equals(id))).go();
}
