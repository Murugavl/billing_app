// Table: payments (partial payment tracking for invoices)
import 'package:drift/drift.dart';

/// Payment method values — stored as TEXT, validated at Dart layer.
/// cash | upi | bank_transfer | cheque | other
class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// FK → documents.id (invoice type only)
  IntColumn get documentId => integer()();

  RealColumn get amount => real().withDefault(const Constant(0.0))();
  DateTimeColumn get date => dateTime()();

  /// 'cash' | 'upi' | 'bank_transfer' | 'cheque' | 'other'
  TextColumn get method =>
      text().withDefault(const Constant('cash'))();

  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
