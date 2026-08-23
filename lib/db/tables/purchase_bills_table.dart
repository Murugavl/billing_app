// PurchaseBills Drift table definition
import 'package:drift/drift.dart';
import 'suppliers_table.dart';

@DataClassName('PurchaseBill')
class PurchaseBills extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get billNumber => text().withLength(min: 1, max: 50)();
  IntColumn get supplierId => integer().references(Suppliers, #id)();
  DateTimeColumn get date => dateTime()();
  RealColumn get subtotal => real()();
  RealColumn get totalTax => real()();
  RealColumn get grandTotal => real()();
  RealColumn get amountPaid => real().withDefault(const Constant(0.0))();
  RealColumn get balanceDue => real()();
  // Status: 'unpaid', 'partially_paid', 'paid'
  TextColumn get status => text().withDefault(const Constant('unpaid'))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
