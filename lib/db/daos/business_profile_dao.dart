// DAO: BusinessProfileDao
import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/business_profile_table.dart';

part 'business_profile_dao.g.dart';

@DriftAccessor(tables: [BusinessProfile])
class BusinessProfileDao extends DatabaseAccessor<AppDatabase>
    with _$BusinessProfileDaoMixin {
  BusinessProfileDao(super.db);

  // ── Read ────────────────────────────────────────────────────────────────────

  /// Returns the single business profile row, or null if not yet configured.
  Future<BusinessProfileData?> getProfile() =>
      (select(businessProfile)..where((t) => t.id.equals(1)))
          .getSingleOrNull();

  /// Reactive stream of the profile row.
  Stream<BusinessProfileData?> watchProfile() =>
      (select(businessProfile)..where((t) => t.id.equals(1)))
          .watchSingleOrNull();

  // ── Write ───────────────────────────────────────────────────────────────────

  /// Inserts or updates the profile (always id = 1).
  Future<void> upsertProfile(BusinessProfileCompanion companion) async {
    final existing = await getProfile();
    if (existing == null) {
      await into(businessProfile).insert(
        BusinessProfileCompanion.insert(
          businessName: companion.businessName.present
              ? companion.businessName.value
              : 'My Business',
        ).copyWith(
          id: const Value(1),
          addressLine: companion.addressLine,
          phone: companion.phone,
          email: companion.email,
          panNumber: companion.panNumber,
          gstNumber: companion.gstNumber,
          logoPath: companion.logoPath,
          signaturePath: companion.signaturePath,
          bankName: companion.bankName,
          bankAccountNo: companion.bankAccountNo,
          bankIfsc: companion.bankIfsc,
          bankBranchAddress: companion.bankBranchAddress,
          invoiceNumberPrefix: companion.invoiceNumberPrefix,
          invoiceNumberFormat: companion.invoiceNumberFormat,
          invoiceNumberPadding: companion.invoiceNumberPadding,
          invoiceNumberSeparator: companion.invoiceNumberSeparator,
          invoiceNextSequence: companion.invoiceNextSequence,
          estimateNumberPrefix: companion.estimateNumberPrefix,
          estimateNumberFormat: companion.estimateNumberFormat,
          estimateNumberPadding: companion.estimateNumberPadding,
          estimateNumberSeparator: companion.estimateNumberSeparator,
          estimateNextSequence: companion.estimateNextSequence,
          purchaseNumberPrefix: companion.purchaseNumberPrefix,
          purchaseNumberFormat: companion.purchaseNumberFormat,
          purchaseNumberPadding: companion.purchaseNumberPadding,
          purchaseNumberSeparator: companion.purchaseNumberSeparator,
          purchaseNextSequence: companion.purchaseNextSequence,
          defaultIncludeBankDetailsInvoice:
              companion.defaultIncludeBankDetailsInvoice,
          defaultIncludeBankDetailsEstimate:
              companion.defaultIncludeBankDetailsEstimate,
        ),
      );
    } else {
      await (update(businessProfile)..where((t) => t.id.equals(1))).write(companion);
    }
  }
}
