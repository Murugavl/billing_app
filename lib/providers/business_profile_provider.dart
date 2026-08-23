// Global Riverpod providers for BusinessProfile state
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database.dart';
import '../services/database_provider.dart';

/// Reactive stream of the singleton business profile row.
/// Emits null when no profile has been saved yet (first-run state).
final businessProfileProvider = StreamProvider<BusinessProfileData?>((ref) {
  return ref.watch(businessProfileDaoProvider).watchProfile();
});

/// Convenience: true once a profile row exists.
final isProfileConfiguredProvider = Provider<bool>((ref) {
  return ref.watch(businessProfileProvider).when(
    data: (p) => p != null,
    loading: () => false,
    error: (_, __) => false,
  );
});
