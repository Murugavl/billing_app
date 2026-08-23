// Riverpod providers for Customers management
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database.dart';
import '../services/database_provider.dart';

/// Active search query notifier for customers list
class CustomerSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
  void clear() => state = '';
}

final customerSearchQueryProvider =
    NotifierProvider<CustomerSearchQueryNotifier, String>(
  CustomerSearchQueryNotifier.new,
);

/// Stream of all customers sorted by name
final customersStreamProvider = StreamProvider<List<Customer>>((ref) {
  return ref.watch(customersDaoProvider).watchAllCustomers();
});

/// Filtered customers list based on customerSearchQueryProvider
final filteredCustomersProvider = Provider<List<Customer>>((ref) {
  final asyncCustomers = ref.watch(customersStreamProvider);
  final query = ref.watch(customerSearchQueryProvider).trim().toLowerCase();

  return asyncCustomers.when(
    data: (customers) {
      if (query.isEmpty) return customers;
      return customers.where((c) {
        final nameMatch = c.name.toLowerCase().contains(query);
        final phoneMatch = c.phone?.toLowerCase().contains(query) ?? false;
        final emailMatch = c.email?.toLowerCase().contains(query) ?? false;
        final gstMatch = c.gstNumber?.toLowerCase().contains(query) ?? false;
        return nameMatch || phoneMatch || emailMatch || gstMatch;
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Stream of documents for a specific customer
final customerDocumentsProvider =
    StreamProvider.family<List<Document>, int>((ref, customerId) {
  return ref.watch(documentsDaoProvider).watchDocumentsByCustomer(customerId);
});
