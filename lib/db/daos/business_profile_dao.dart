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

  /// Inserts or replaces the profile (always id = 1).
  Future<void> upsertProfile(BusinessProfileCompanion companion) =>
      into(businessProfile).insertOnConflictUpdate(
        companion.copyWith(id: const Value(1)),
      );
}
