// Riverpod providers for Suppliers management
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database.dart';
import '../services/database_provider.dart';

/// Active search query notifier for suppliers list
class SupplierSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
  void clear() => state = '';
}

final supplierSearchQueryProvider =
    NotifierProvider<SupplierSearchQueryNotifier, String>(
  SupplierSearchQueryNotifier.new,
);

/// Stream of all suppliers sorted by name
final suppliersStreamProvider = StreamProvider<List<Supplier>>((ref) {
  return ref.watch(suppliersDaoProvider).watchAllSuppliers();
});

/// Filtered suppliers list based on supplierSearchQueryProvider
final filteredSuppliersProvider = Provider<List<Supplier>>((ref) {
  final asyncSuppliers = ref.watch(suppliersStreamProvider);
  final query = ref.watch(supplierSearchQueryProvider).trim().toLowerCase();

  return asyncSuppliers.when(
    data: (suppliers) {
      if (query.isEmpty) return suppliers;
      return suppliers.where((s) {
        final nameMatch = s.name.toLowerCase().contains(query);
        final phoneMatch = s.phone.toLowerCase().contains(query);
        final gstMatch = s.gstNumber?.toLowerCase().contains(query) ?? false;
        return nameMatch || phoneMatch || gstMatch;
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
