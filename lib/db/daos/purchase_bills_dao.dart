// DAO: PurchaseBillsDao — handles purchase bills, line items & payments
import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/documents_table.dart';
import '../tables/purchase_bills_table.dart';
import '../tables/purchase_line_items_table.dart';
import '../tables/purchase_payments_table.dart';

import '../../services/document_numbering_service.dart';

part 'purchase_bills_dao.g.dart';

class PurchaseBillWithLines {
  final PurchaseBill bill;
  final List<PurchaseLineItem> lineItems;

  const PurchaseBillWithLines({
    required this.bill,
    required this.lineItems,
  });
}

class SalesVsPurchasesSummary {
  final double totalSales;
  final double totalPurchases;
  final double netMargin; // totalSales - totalPurchases

  const SalesVsPurchasesSummary({
    required this.totalSales,
    required this.totalPurchases,
    required this.netMargin,
  });
}

@DriftAccessor(
  tables: [PurchaseBills, PurchaseLineItems, PurchasePayments, Documents],
)
class PurchaseBillsDao extends DatabaseAccessor<AppDatabase>
    with _$PurchaseBillsDaoMixin {
  PurchaseBillsDao(super.db);

  // ── Document Numbering ────────────────────────────────────────────────────────

  Future<String> nextPurchaseBillNumber({DateTime? date}) async {
    final profile = await db.businessProfileDao.getProfile();
    final count = await (selectOnly(purchaseBills)
          ..addColumns([purchaseBills.id.count()]))
        .map((r) => r.read(purchaseBills.id.count()))
        .getSingle();
    final docCount = (count ?? 0) + 1;

    final prefix = profile?.purchaseNumberPrefix ?? 'PUR';
    final format = profile?.purchaseNumberFormat ?? '{PREFIX}-{SEQ}';
    final padding = profile?.purchaseNumberPadding ?? 4;
    final separator = profile?.purchaseNumberSeparator ?? '-';
    final seq = profile?.purchaseNextSequence ?? 1;
    final nextSeq = seq > docCount ? seq : docCount;

    return DocumentNumberingService.formatDocumentNumber(
      template: format,
      prefix: prefix,
      sequence: nextSeq,
      padding: padding,
      separator: separator,
      date: date,
    );
  }

  Future<String> consumeNextPurchaseBillNumber({DateTime? date}) async {
    final profile = await db.businessProfileDao.getProfile();
    final count = await (selectOnly(purchaseBills)
          ..addColumns([purchaseBills.id.count()]))
        .map((r) => r.read(purchaseBills.id.count()))
        .getSingle();
    final docCount = (count ?? 0) + 1;

    final prefix = profile?.purchaseNumberPrefix ?? 'PUR';
    final format = profile?.purchaseNumberFormat ?? '{PREFIX}-{SEQ}';
    final padding = profile?.purchaseNumberPadding ?? 4;
    final separator = profile?.purchaseNumberSeparator ?? '-';
    final seq = profile?.purchaseNextSequence ?? 1;
    final nextSeq = seq > docCount ? seq : docCount;

    final billNum = DocumentNumberingService.formatDocumentNumber(
      template: format,
      prefix: prefix,
      sequence: nextSeq,
      padding: padding,
      separator: separator,
      date: date,
    );

    await db.businessProfileDao.upsertProfile(
      BusinessProfileCompanion(
        purchaseNextSequence: Value(nextSeq + 1),
        updatedAt: Value(DateTime.now()),
      ),
    );

    return billNum;
  }

  // ── Read Purchase Bills ──────────────────────────────────────────────────────

  Future<List<PurchaseBill>> getAllPurchaseBills() =>
      (select(purchaseBills)..orderBy([(t) => OrderingTerm.desc(t.date)])).get();

  Stream<List<PurchaseBill>> watchAllPurchaseBills() =>
      (select(purchaseBills)..orderBy([(t) => OrderingTerm.desc(t.date)])).watch();

  Future<PurchaseBillWithLines?> getPurchaseBillWithLines(int id) async {
    final bill = await (select(purchaseBills)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (bill == null) return null;
    final lines = await (select(purchaseLineItems)..where((t) => t.purchaseBillId.equals(id))).get();
    return PurchaseBillWithLines(bill: bill, lineItems: lines);
  }

  Stream<PurchaseBillWithLines?> watchPurchaseBillWithLines(int id) {
    final billStream = (select(purchaseBills)..where((t) => t.id.equals(id))).watchSingleOrNull();
    return billStream.asyncMap((bill) async {
      if (bill == null) return null;
      final lines = await (select(purchaseLineItems)..where((t) => t.purchaseBillId.equals(id))).get();
      return PurchaseBillWithLines(bill: bill, lineItems: lines);
    });
  }

  Future<List<PurchasePayment>> getPaymentsForBill(int billId) =>
      (select(purchasePayments)
            ..where((t) => t.purchaseBillId.equals(billId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Stream<List<PurchasePayment>> watchPaymentsForBill(int billId) =>
      (select(purchasePayments)
            ..where((t) => t.purchaseBillId.equals(billId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .watch();

  // Delete safety checks
  Future<int> getPurchaseCountForSupplier(int supplierId) async {
    final count = await (selectOnly(purchaseBills)
          ..addColumns([purchaseBills.id.count()])
          ..where(purchaseBills.supplierId.equals(supplierId)))
        .map((r) => r.read(purchaseBills.id.count()))
        .getSingle();
    return count ?? 0;
  }

  Future<int> getPurchaseCountForItem(int itemId) async {
    final count = await (selectOnly(purchaseLineItems)
          ..addColumns([purchaseLineItems.id.count()])
          ..where(purchaseLineItems.itemId.equals(itemId)))
        .map((r) => r.read(purchaseLineItems.id.count()))
        .getSingle();
    return count ?? 0;
  }

  // ── Create & Update Purchase Bill ────────────────────────────────────────────

  Future<int> createPurchaseBill({
    required PurchaseBillsCompanion billCompanion,
    required List<PurchaseLineItemsCompanion> lineItemsCompanions,
    double initialPayment = 0.0,
    String paymentMethod = 'cash',
  }) async {
    return transaction(() async {
      final billId = await into(purchaseBills).insert(billCompanion);

      for (final lineCompanion in lineItemsCompanions) {
        await into(purchaseLineItems).insert(
          lineCompanion.copyWith(purchaseBillId: Value(billId)),
        );
      }

      if (initialPayment > 0) {
        await recordPayment(
          billId: billId,
          amount: initialPayment,
          date: billCompanion.date.value,
          method: paymentMethod,
          notes: 'Initial payment at bill creation',
        );
      }

      return billId;
    });
  }

  Future<bool> updatePurchaseBill({
    required PurchaseBillsCompanion billCompanion,
    required List<PurchaseLineItemsCompanion> lineItemsCompanions,
  }) async {
    return transaction(() async {
      final billId = billCompanion.id.value;
      final updated = await update(purchaseBills).replace(billCompanion);

      // Re-replace line items
      await (delete(purchaseLineItems)..where((t) => t.purchaseBillId.equals(billId))).go();
      for (final lineCompanion in lineItemsCompanions) {
        await into(purchaseLineItems).insert(
          lineCompanion.copyWith(purchaseBillId: Value(billId)),
        );
      }

      return updated;
    });
  }

  Future<int> deletePurchaseBill(int id) =>
      (delete(purchaseBills)..where((t) => t.id.equals(id))).go();

  // ── Payments ─────────────────────────────────────────────────────────────────

  Future<int> recordPayment({
    required int billId,
    required double amount,
    required DateTime date,
    required String method,
    String? notes,
  }) async {
    return transaction(() async {
      final paymentId = await into(purchasePayments).insert(
        PurchasePaymentsCompanion.insert(
          purchaseBillId: billId,
          amount: amount,
          date: date,
          method: method,
          notes: Value(notes),
        ),
      );

      // Recalculate bill status & balance
      final bill = await (select(purchaseBills)..where((t) => t.id.equals(billId))).getSingle();
      final totalPaid = await (selectOnly(purchasePayments)
            ..addColumns([purchasePayments.amount.sum()])
            ..where(purchasePayments.purchaseBillId.equals(billId)))
          .map((r) => r.read(purchasePayments.amount.sum()))
          .getSingle();

      final newAmountPaid = totalPaid ?? 0.0;
      final newBalanceDue = (bill.grandTotal - newAmountPaid).clamp(0.0, double.infinity);

      String newStatus = 'unpaid';
      if (newBalanceDue <= 0.001) {
        newStatus = 'paid';
      } else if (newAmountPaid > 0) {
        newStatus = 'partially_paid';
      }

      await (update(purchaseBills)..where((t) => t.id.equals(billId))).write(
        PurchaseBillsCompanion(
          amountPaid: Value(newAmountPaid),
          balanceDue: Value(newBalanceDue),
          status: Value(newStatus),
        ),
      );

      return paymentId;
    });
  }

  // ── Analytics — Sales vs Purchases ───────────────────────────────────────────

  Future<SalesVsPurchasesSummary> getSalesVsPurchasesSummary(
    DateTime start,
    DateTime end,
  ) async {
    // 1. Total Sales from Documents table (type == 'invoice' and status != 'cancelled')
    final salesResult = await (selectOnly(documents)
          ..addColumns([documents.grandTotal.sum()])
          ..where(
            documents.type.equals('invoice') &
                documents.status.isNotIn(['cancelled']) &
                documents.date.isBiggerOrEqualValue(start) &
                documents.date.isSmallerOrEqualValue(end),
          ))
        .map((r) => r.read(documents.grandTotal.sum()))
        .getSingle();
    final totalSales = salesResult ?? 0.0;

    // 2. Total Purchases from PurchaseBills table
    final purchaseResult = await (selectOnly(purchaseBills)
          ..addColumns([purchaseBills.grandTotal.sum()])
          ..where(
            purchaseBills.date.isBiggerOrEqualValue(start) &
                purchaseBills.date.isSmallerOrEqualValue(end),
          ))
        .map((r) => r.read(purchaseBills.grandTotal.sum()))
        .getSingle();
    final totalPurchases = purchaseResult ?? 0.0;

    return SalesVsPurchasesSummary(
      totalSales: totalSales,
      totalPurchases: totalPurchases,
      netMargin: totalSales - totalPurchases,
    );
  }
}
