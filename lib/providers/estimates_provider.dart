// Riverpod providers for Estimates management
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database.dart';
import '../services/database_provider.dart';

/// Active search query for estimates list
class EstimateSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
  void clear() => state = '';
}

final estimateSearchQueryProvider =
    NotifierProvider<EstimateSearchQueryNotifier, String>(
  EstimateSearchQueryNotifier.new,
);

/// Stream of all estimate documents
final estimatesStreamProvider = StreamProvider<List<Document>>((ref) {
  return ref.watch(documentsDaoProvider).watchDocumentsByType('estimate');
});

/// Filtered estimates list based on estimateSearchQueryProvider
final filteredEstimatesProvider = Provider<List<Document>>((ref) {
  final asyncEstimates = ref.watch(estimatesStreamProvider);
  final query = ref.watch(estimateSearchQueryProvider).trim().toLowerCase();

  return asyncEstimates.when(
    data: (estimates) {
      if (query.isEmpty) return estimates;
      return estimates.where((doc) {
        final numberMatch = doc.documentNumber.toLowerCase().contains(query);
        final customerMatch = doc.customerName.toLowerCase().contains(query);
        final statusMatch = doc.status.toLowerCase().contains(query);
        return numberMatch || customerMatch || statusMatch;
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
