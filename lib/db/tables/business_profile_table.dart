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

  // Invoice numbering settings
  TextColumn get invoiceNumberPrefix =>
      text().withDefault(const Constant('INV'))();
  TextColumn get invoiceNumberFormat =>
      text().withDefault(const Constant('{PREFIX}-{SEQ}'))();
  IntColumn get invoiceNumberPadding =>
      integer().withDefault(const Constant(4))();
  TextColumn get invoiceNumberSeparator =>
      text().withDefault(const Constant('-'))();
  IntColumn get invoiceNextSequence =>
      integer().withDefault(const Constant(1))();

  // Estimate numbering settings
  TextColumn get estimateNumberPrefix =>
      text().withDefault(const Constant('EST'))();
  TextColumn get estimateNumberFormat =>
      text().withDefault(const Constant('{PREFIX}-{SEQ}'))();
  IntColumn get estimateNumberPadding =>
      integer().withDefault(const Constant(4))();
  TextColumn get estimateNumberSeparator =>
      text().withDefault(const Constant('-'))();
  IntColumn get estimateNextSequence =>
      integer().withDefault(const Constant(1))();

  // Purchase Bill numbering settings
  TextColumn get purchaseNumberPrefix =>
      text().withDefault(const Constant('PUR'))();
  TextColumn get purchaseNumberFormat =>
      text().withDefault(const Constant('{PREFIX}-{SEQ}'))();
  IntColumn get purchaseNumberPadding =>
      integer().withDefault(const Constant(4))();
  TextColumn get purchaseNumberSeparator =>
      text().withDefault(const Constant('-'))();
  IntColumn get purchaseNextSequence =>
      integer().withDefault(const Constant(1))();

  // Bank Details Default Display Settings
  BoolColumn get defaultIncludeBankDetailsInvoice =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get defaultIncludeBankDetailsEstimate =>
      boolean().withDefault(const Constant(true))();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
