// Table: items (product / service catalogue)
import 'package:drift/drift.dart';

class Items extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get hsnSacCode => text().withLength(max: 10).nullable()();

  /// Default unit label, e.g. "Pcs", "Nos", "Kg", "Hrs", "Ltr"
  TextColumn get defaultUnit =>
      text().withLength(max: 20).withDefault(const Constant('Pcs'))();

  /// Default selling price (INR)
  RealColumn get defaultPrice =>
      real().withDefault(const Constant(0.0))();

  /// Default tax rate — GST % (e.g. 0, 5, 12, 18, 28). Nullable = exempt/zero.
  RealColumn get defaultTaxPercent => real().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
