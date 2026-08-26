// DAO: DocumentsDao — handles both invoices and estimates
import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/documents_table.dart';
import '../tables/document_line_items_table.dart';

import '../../services/document_numbering_service.dart';

part 'documents_dao.g.dart';

/// A document together with its line items — used as a rich return type.
class DocumentWithLines {
  final Document document;
  final List<DocumentLineItem> lineItems;

  const DocumentWithLines({required this.document, required this.lineItems});
}

@DriftAccessor(tables: [Documents, DocumentLineItems])
class DocumentsDao extends DatabaseAccessor<AppDatabase>
    with _$DocumentsDaoMixin {
  DocumentsDao(super.db);

  // ── Sequence counter ─────────────────────────────────────────────────────────

  /// Returns the next document number for a given type according to BusinessProfile settings.
  Future<String> nextDocumentNumber(String type, {DateTime? date}) async {
    final profile = await db.businessProfileDao.getProfile();
    final count = await (selectOnly(documents)
          ..addColumns([documents.id.count()])
          ..where(documents.type.equals(type)))
        .map((r) => r.read(documents.id.count()))
        .getSingle();
    final docCount = (count ?? 0) + 1;

    if (type == 'invoice') {
      final prefix = profile?.invoiceNumberPrefix ?? 'INV';
      final format = profile?.invoiceNumberFormat ?? '{PREFIX}-{SEQ}';
      final padding = profile?.invoiceNumberPadding ?? 4;
      final separator = profile?.invoiceNumberSeparator ?? '-';
      final seq = profile?.invoiceNextSequence ?? 1;
      final nextSeq = seq > docCount ? seq : docCount;

      return DocumentNumberingService.formatDocumentNumber(
        template: format,
        prefix: prefix,
        sequence: nextSeq,
        padding: padding,
        separator: separator,
        date: date,
      );
    } else {
      final prefix = profile?.estimateNumberPrefix ?? 'EST';
      final format = profile?.estimateNumberFormat ?? '{PREFIX}-{SEQ}';
      final padding = profile?.estimateNumberPadding ?? 4;
      final separator = profile?.estimateNumberSeparator ?? '-';
      final seq = profile?.estimateNextSequence ?? 1;
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
  }

  /// Consumes and returns the next document number, while incrementing the sequence counter in BusinessProfile.
  Future<String> consumeNextDocumentNumber(String type, {DateTime? date}) async {
    final profile = await db.businessProfileDao.getProfile();
    final count = await (selectOnly(documents)
          ..addColumns([documents.id.count()])
          ..where(documents.type.equals(type)))
        .map((r) => r.read(documents.id.count()))
        .getSingle();
    final docCount = (count ?? 0) + 1;

    if (type == 'invoice') {
      final prefix = profile?.invoiceNumberPrefix ?? 'INV';
      final format = profile?.invoiceNumberFormat ?? '{PREFIX}-{SEQ}';
      final padding = profile?.invoiceNumberPadding ?? 4;
      final separator = profile?.invoiceNumberSeparator ?? '-';
      final seq = profile?.invoiceNextSequence ?? 1;
      final nextSeq = seq > docCount ? seq : docCount;

      final docNum = DocumentNumberingService.formatDocumentNumber(
        template: format,
        prefix: prefix,
        sequence: nextSeq,
        padding: padding,
        separator: separator,
        date: date,
      );

      await db.businessProfileDao.upsertProfile(
        BusinessProfileCompanion(
          invoiceNextSequence: Value(nextSeq + 1),
          updatedAt: Value(DateTime.now()),
        ),
      );

      return docNum;
    } else {
      final prefix = profile?.estimateNumberPrefix ?? 'EST';
      final format = profile?.estimateNumberFormat ?? '{PREFIX}-{SEQ}';
      final padding = profile?.estimateNumberPadding ?? 4;
      final separator = profile?.estimateNumberSeparator ?? '-';
      final seq = profile?.estimateNextSequence ?? 1;
      final nextSeq = seq > docCount ? seq : docCount;

      final docNum = DocumentNumberingService.formatDocumentNumber(
        template: format,
        prefix: prefix,
        sequence: nextSeq,
        padding: padding,
        separator: separator,
        date: date,
      );

      await db.businessProfileDao.upsertProfile(
        BusinessProfileCompanion(
          estimateNextSequence: Value(nextSeq + 1),
          updatedAt: Value(DateTime.now()),
        ),
      );

      return docNum;
    }
  }

  // ── Read — Documents ─────────────────────────────────────────────────────────

  Future<List<Document>> getAllDocuments() =>
      (select(documents)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Stream<List<Document>> watchAllDocuments() =>
      (select(documents)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Future<List<Document>> getDocumentsByType(String type) =>
      (select(documents)
            ..where((t) => t.type.equals(type))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Stream<List<Document>> watchDocumentsByType(String type) =>
      (select(documents)
            ..where((t) => t.type.equals(type))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .watch();

  Future<Document?> getDocumentById(int id) =>
      (select(documents)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Returns the document together with all its line items.
  Future<DocumentWithLines?> getDocumentWithLines(int id) async {
    final doc =
        await (select(documents)..where((t) => t.id.equals(id)))
            .getSingleOrNull();
    if (doc == null) return null;
    final lines = await (select(documentLineItems)
          ..where((t) => t.documentId.equals(id))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
    return DocumentWithLines(document: doc, lineItems: lines);
  }

  Stream<DocumentWithLines?> watchDocumentWithLines(int id) {
    final docStream =
        (select(documents)..where((t) => t.id.equals(id))).watchSingleOrNull();

    return docStream.asyncMap((doc) async {
      if (doc == null) return null;
      final lines = await (select(documentLineItems)
            ..where((t) => t.documentId.equals(id))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();
      return DocumentWithLines(document: doc, lineItems: lines);
    });
  }

  Future<List<Document>> getDocumentsByCustomer(int customerId) =>
      (select(documents)
            ..where((t) => t.customerId.equals(customerId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Stream<List<Document>> watchDocumentsByCustomer(int customerId) =>
      (select(documents)
            ..where((t) => t.customerId.equals(customerId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .watch();

  /// Returns the number of documents associated with a customer.
  Future<int> getDocumentCountForCustomer(int customerId) async {
    final count = await (selectOnly(documents)
          ..addColumns([documents.id.count()])
          ..where(documents.customerId.equals(customerId)))
        .map((r) => r.read(documents.id.count()))
        .getSingle();
    return count ?? 0;
  }

  /// Returns the number of line items (and thus document references) associated with an item.
  Future<int> getDocumentCountForItem(int itemId) async {
    final count = await (selectOnly(documentLineItems)
          ..addColumns([documentLineItems.id.count()])
          ..where(documentLineItems.itemId.equals(itemId)))
        .map((r) => r.read(documentLineItems.id.count()))
        .getSingle();
    return count ?? 0;
  }

  Future<List<Document>> getDocumentsByStatus(String status) =>
      (select(documents)
            ..where((t) => t.status.equals(status))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  // ── Write — Documents (with lines, in one transaction) ──────────────────────

  /// Inserts a document + its line items atomically.
  /// Returns the new document id.
  Future<int> insertDocumentWithLines({
    required DocumentsCompanion doc,
    required List<DocumentLineItemsCompanion> lines,
  }) async {
    return db.transaction(() async {
      final docId = await into(documents).insert(doc);
      for (var i = 0; i < lines.length; i++) {
        await into(documentLineItems).insert(
          lines[i].copyWith(
            documentId: Value(docId),
            sortOrder: Value(i),
          ),
        );
      }
      return docId;
    });
  }

  /// Replaces a document and its line items atomically.
  Future<void> updateDocumentWithLines({
    required DocumentsCompanion doc,
    required List<DocumentLineItemsCompanion> lines,
  }) async {
    assert(doc.id.present, 'doc.id must be set for update');
    final docId = doc.id.value;
    await db.transaction(() async {
      await (update(documents)..where((t) => t.id.equals(docId))).write(
        doc.copyWith(updatedAt: Value(DateTime.now())),
      );
      await (delete(documentLineItems)
            ..where((t) => t.documentId.equals(docId)))
          .go();
      for (var i = 0; i < lines.length; i++) {
        await into(documentLineItems).insert(
          lines[i].copyWith(
            documentId: Value(docId),
            sortOrder: Value(i),
          ),
        );
      }
    });
  }

  /// Updates only the status field of a document.
  Future<void> updateStatus(int id, String status) async {
    await (update(documents)..where((t) => t.id.equals(id))).write(
      DocumentsCompanion(
        status: Value(status),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Soft-updates amountReceived + balanceDue (called after recording a payment).
  Future<void> updatePaymentTotals(
      int id, double amountReceived, double balanceDue) async {
    await (update(documents)..where((t) => t.id.equals(id))).write(
      DocumentsCompanion(
        amountReceived: Value(amountReceived),
        balanceDue: Value(balanceDue),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> deleteDocument(int id) async {
    return db.transaction(() async {
      await (delete(documentLineItems)
            ..where((t) => t.documentId.equals(id)))
          .go();
      return (delete(documents)..where((t) => t.id.equals(id))).go();
    });
  }
}
