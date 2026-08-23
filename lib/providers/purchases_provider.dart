// Riverpod providers for Purchase Bills management
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database.dart';
import '../db/daos/purchase_bills_dao.dart';
import '../services/database_provider.dart';
import 'suppliers_provider.dart';

/// Purchase bill status filter enum
enum PurchaseStatusFilter { all, unpaid, partiallyPaid, paid }

class PurchaseStatusFilterNotifier extends Notifier<PurchaseStatusFilter> {
  @override
  PurchaseStatusFilter build() => PurchaseStatusFilter.all;

  void setFilter(PurchaseStatusFilter filter) => state = filter;
}

final purchaseStatusFilterProvider =
    NotifierProvider<PurchaseStatusFilterNotifier, PurchaseStatusFilter>(
  PurchaseStatusFilterNotifier.new,
);

/// Search query notifier for purchase bills
class PurchaseSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
  void clear() => state = '';
}

final purchaseSearchQueryProvider =
    NotifierProvider<PurchaseSearchQueryNotifier, String>(
  PurchaseSearchQueryNotifier.new,
);

/// Stream of all purchase bills
final purchaseBillsStreamProvider = StreamProvider<List<PurchaseBill>>((ref) {
  return ref.watch(purchaseBillsDaoProvider).watchAllPurchaseBills();
});

/// Filtered purchase bills list
final filteredPurchaseBillsProvider = Provider<List<PurchaseBill>>((ref) {
  final asyncBills = ref.watch(purchaseBillsStreamProvider);
  final filter = ref.watch(purchaseStatusFilterProvider);
  final query = ref.watch(purchaseSearchQueryProvider).trim().toLowerCase();
  final suppliersAsync = ref.watch(suppliersStreamProvider);
  final suppliersMap = {
    for (final s in suppliersAsync.asData?.value ?? <Supplier>[]) s.id: s.name.toLowerCase()
  };

  return asyncBills.when(
    data: (bills) {
      return bills.where((b) {
        // Status filter
        if (filter == PurchaseStatusFilter.unpaid && b.status != 'unpaid') return false;
        if (filter == PurchaseStatusFilter.partiallyPaid && b.status != 'partially_paid') return false;
        if (filter == PurchaseStatusFilter.paid && b.status != 'paid') return false;

        // Search query filter
        if (query.isNotEmpty) {
          final billMatch = b.billNumber.toLowerCase().contains(query);
          final supplierName = suppliersMap[b.supplierId] ?? '';
          final supplierMatch = supplierName.contains(query);
          if (!billMatch && !supplierMatch) return false;
        }

        return true;
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Single purchase bill with line items provider
final purchaseBillDetailProvider =
    FutureProvider.family<PurchaseBillWithLines?, int>((ref, billId) async {
  return ref.watch(purchaseBillsDaoProvider).getPurchaseBillWithLines(billId);
});

/// Payments history provider for a purchase bill
final purchaseBillPaymentsProvider =
    FutureProvider.family<List<PurchasePayment>, int>((ref, billId) async {
  return ref.watch(purchaseBillsDaoProvider).getPaymentsForBill(billId);
});
