// Table: document_line_items
import 'package:drift/drift.dart';

class DocumentLineItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// FK → documents.id
  IntColumn get documentId => integer()();

  /// FK → items.id — nullable when the line is an ad-hoc / custom entry.
  IntColumn get itemId => integer().nullable()();

  /// Item type: 'product' or 'service'
  TextColumn get itemType =>
      text().withLength(max: 20).withDefault(const Constant('product'))();

  TextColumn get itemName => text()();
  TextColumn get hsnSacCode => text().nullable()();
  RealColumn get quantity =>
      real().withDefault(const Constant(1.0))();
  TextColumn get unit =>
      text().withLength(max: 20).withDefault(const Constant('Pcs'))();

  RealColumn get pricePerUnit =>
      real().withDefault(const Constant(0.0))();

  /// Discount applied to this line (%)
  RealColumn get discountPercent =>
      real().withDefault(const Constant(0.0))();

  /// Computed: quantity * pricePerUnit * (discountPercent / 100)
  RealColumn get discountAmount =>
      real().withDefault(const Constant(0.0))();

  /// Computed: (quantity * pricePerUnit) - discountAmount
  RealColumn get taxableAmount =>
      real().withDefault(const Constant(0.0))();

  /// GST % applied on taxableAmount
  RealColumn get taxPercent =>
      real().withDefault(const Constant(0.0))();

  /// Computed: taxableAmount * (taxPercent / 100)
  RealColumn get taxAmount =>
      real().withDefault(const Constant(0.0))();

  /// taxableAmount + taxAmount
  RealColumn get lineTotal =>
      real().withDefault(const Constant(0.0))();

  /// For maintaining display order
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}
