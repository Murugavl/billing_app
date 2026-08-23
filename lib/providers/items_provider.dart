// Riverpod providers for Items management
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database.dart';
import '../services/database_provider.dart';

/// Active search query notifier for items list
class ItemSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
  void clear() => state = '';
}

final itemSearchQueryProvider =
    NotifierProvider<ItemSearchQueryNotifier, String>(
  ItemSearchQueryNotifier.new,
);

/// Stream of all items sorted by name
final itemsStreamProvider = StreamProvider<List<Item>>((ref) {
  return ref.watch(itemsDaoProvider).watchAllItems();
});

/// Filtered items list based on itemSearchQueryProvider
final filteredItemsProvider = Provider<List<Item>>((ref) {
  final asyncItems = ref.watch(itemsStreamProvider);
  final query = ref.watch(itemSearchQueryProvider).trim().toLowerCase();

  return asyncItems.when(
    data: (items) {
      if (query.isEmpty) return items;
      return items.where((item) {
        final nameMatch = item.name.toLowerCase().contains(query);
        final hsnMatch = item.hsnSacCode?.toLowerCase().contains(query) ?? false;
        final unitMatch = item.defaultUnit.toLowerCase().contains(query);
        return nameMatch || hsnMatch || unitMatch;
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
