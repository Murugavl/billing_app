// Suppliers Drift table definition
import 'package:drift/drift.dart';

@DataClassName('Supplier')
class Suppliers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get phone => text().withLength(min: 1, max: 20)();
  TextColumn get address => text().nullable()();
  TextColumn get gstNumber => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
