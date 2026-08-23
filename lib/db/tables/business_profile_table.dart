// Table: business_profile (singleton — always id = 1)
import 'package:drift/drift.dart';

/// A single row holds the business owner's profile.
/// Always upsert with id = 1.
class BusinessProfile extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get businessName => text().withLength(min: 1, max: 200)();
  TextColumn get addressLine => text().nullable()();
  TextColumn get phone => text().withLength(max: 20).nullable()();
  TextColumn get email => text().withLength(max: 200).nullable()();
  TextColumn get panNumber => text().withLength(max: 10).nullable()();
  TextColumn get gstNumber => text().withLength(max: 15).nullable()();
  TextColumn get logoPath => text().nullable()();
  TextColumn get signaturePath => text().nullable()();
  TextColumn get bankName => text().withLength(max: 200).nullable()();
  TextColumn get bankAccountNo => text().withLength(max: 30).nullable()();
  TextColumn get bankIfsc => text().withLength(max: 11).nullable()();
  TextColumn get bankBranchAddress => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
