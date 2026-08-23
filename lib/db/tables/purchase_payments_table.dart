// PurchasePayments Drift table definition
import 'package:drift/drift.dart';
import 'purchase_bills_table.dart';

@DataClassName('PurchasePayment')
class PurchasePayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get purchaseBillId => integer().references(PurchaseBills, #id, onDelete: KeyAction.cascade)();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get method => text()(); // cash, upi, bank_transfer, cheque
  TextColumn get notes => text().nullable()();
}
