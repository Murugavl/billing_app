// PurchaseLineItems Drift table definition
import 'package:drift/drift.dart';
import 'items_table.dart';
import 'purchase_bills_table.dart';

@DataClassName('PurchaseLineItem')
class PurchaseLineItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get purchaseBillId => integer().references(PurchaseBills, #id, onDelete: KeyAction.cascade)();
  IntColumn get itemId => integer().nullable().references(Items, #id)();
  TextColumn get itemName => text().withLength(min: 1, max: 150)();
  TextColumn get hsnSacCode => text().nullable()();
  RealColumn get quantity => real()();
  TextColumn get unit => text().withDefault(const Constant('Pcs'))();
  RealColumn get pricePerUnit => real()();
  RealColumn get taxAmount => real().withDefault(const Constant(0.0))();
  RealColumn get lineTotal => real()();
}
