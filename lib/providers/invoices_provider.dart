// Riverpod providers for Invoices management
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database.dart';
import '../services/database_provider.dart';

/// Active search query for invoices list
class InvoiceSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
  void clear() => state = '';
}

final invoiceSearchQueryProvider =
    NotifierProvider<InvoiceSearchQueryNotifier, String>(
  InvoiceSearchQueryNotifier.new,
);

/// Stream of all invoice documents
final invoicesStreamProvider = StreamProvider<List<Document>>((ref) {
  return ref.watch(documentsDaoProvider).watchDocumentsByType('invoice');
});

/// Filtered invoices list based on invoiceSearchQueryProvider
final filteredInvoicesProvider = Provider<List<Document>>((ref) {
  final asyncInvoices = ref.watch(invoicesStreamProvider);
  final query = ref.watch(invoiceSearchQueryProvider).trim().toLowerCase();

  return asyncInvoices.when(
    data: (invoices) {
      if (query.isEmpty) return invoices;
      return invoices.where((doc) {
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
