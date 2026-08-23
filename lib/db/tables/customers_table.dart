// Table: customers
import 'package:drift/drift.dart';

class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get phone => text().withLength(max: 20).nullable()();
  TextColumn get email => text().withLength(max: 200).nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get gstNumber => text().withLength(max: 15).nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
