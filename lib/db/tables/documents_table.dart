// Table: documents (covers both invoices and estimates via type enum)
import 'package:drift/drift.dart';

/// Stored as TEXT in SQLite; validated at the Dart layer.
///
/// Invoice statuses : draft | sent | paid | partially_paid | overdue
/// Estimate statuses: draft | sent | accepted | expired
class Documents extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Human-readable number, e.g. "INV-0001" or "EST-0001".
  /// Managed by the DAO (per-type sequence counter).
  TextColumn get documentNumber => text().withLength(min: 1, max: 50)();

  /// 'invoice' | 'estimate'
  TextColumn get type => text().withLength(min: 1, max: 10)();

  /// FK → customers.id — nullable (walk-in / ad-hoc customer)
  IntColumn get customerId => integer().nullable()();

  /// Denormalised snapshot at creation time (preserved if customer is edited)
  TextColumn get customerName => text()();
  TextColumn get customerPhone => text().nullable()();
  TextColumn get customerAddress => text().nullable()();
  TextColumn get customerGstNumber => text().nullable()();

  DateTimeColumn get date => dateTime()();
  DateTimeColumn get dueDate => dateTime().nullable()(); // invoice only
  TextColumn get placeOfSupply => text().nullable()();

  // ── Financials ──────────────────────────────────────────────────────────────
  RealColumn get subtotal =>
      real().withDefault(const Constant(0.0))();
  RealColumn get totalDiscount =>
      real().withDefault(const Constant(0.0))();
  RealColumn get totalTax =>
      real().withDefault(const Constant(0.0))();
  RealColumn get grandTotal =>
      real().withDefault(const Constant(0.0))();

  /// Applicable to invoices only; null for estimates.
  RealColumn get amountReceived => real().nullable()();
  RealColumn get balanceDue => real().nullable()();

  /// Pre-computed "Rupees eight thousand only" — stored for PDF rendering.
  TextColumn get amountInWords => text().nullable()();

  /// See status values above. Default 'draft' for both types.
  TextColumn get status =>
      text().withDefault(const Constant('draft'))();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
