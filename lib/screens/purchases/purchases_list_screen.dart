// Purchases List Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../db/app_database.dart';
import '../../providers/purchases_provider.dart';
import '../../providers/suppliers_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';

class PurchasesListScreen extends ConsumerWidget {
  const PurchasesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredBills = ref.watch(filteredPurchaseBillsProvider);
    final activeFilter = ref.watch(purchaseStatusFilterProvider);
    final searchQuery = ref.watch(purchaseSearchQueryProvider);
    final suppliersAsync = ref.watch(suppliersStreamProvider);
    final suppliersMap = {
      for (final s in suppliersAsync.asData?.value ?? <Supplier>[]) s.id: s.name
    };

    final totalPurchasesSum = filteredBills.fold<double>(
      0.0,
      (sum, bill) => sum + bill.grandTotal,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Bills'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_outlined),
            tooltip: 'Suppliers Catalog',
            onPressed: () => context.push('/suppliers'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  onChanged: (val) =>
                      ref.read(purchaseSearchQueryProvider.notifier).setQuery(val),
                  decoration: InputDecoration(
                    hintText: 'Search bill # or supplier name...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () => ref
                                .read(purchaseSearchQueryProvider.notifier)
                                .clear(),
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.backgroundLight,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'All',
                        isSelected: activeFilter == PurchaseStatusFilter.all,
                        onSelected: () => ref
                            .read(purchaseStatusFilterProvider.notifier)
                            .setFilter(PurchaseStatusFilter.all),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Unpaid',
                        isSelected: activeFilter == PurchaseStatusFilter.unpaid,
                        onSelected: () => ref
                            .read(purchaseStatusFilterProvider.notifier)
                            .setFilter(PurchaseStatusFilter.unpaid),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Partially Paid',
                        isSelected:
                            activeFilter == PurchaseStatusFilter.partiallyPaid,
                        onSelected: () => ref
                            .read(purchaseStatusFilterProvider.notifier)
                            .setFilter(PurchaseStatusFilter.partiallyPaid),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Paid',
                        isSelected: activeFilter == PurchaseStatusFilter.paid,
                        onSelected: () => ref
                            .read(purchaseStatusFilterProvider.notifier)
                            .setFilter(PurchaseStatusFilter.paid),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Total Summary KPI
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: AppColors.primaryBlueMid.withValues(alpha: 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredBills.length} Bills Found',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDarkSecondary,
                  ),
                ),
                Text(
                  'Total: ${CurrencyFormatter.format(totalPurchasesSum)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlueMid,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          // Bills List
          Expanded(
            child: filteredBills.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_outlined,
                            size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        const Text(
                          'No Purchase Bills Found',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDarkSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Tap + Add Purchase Bill to log supplier purchases',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredBills.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final bill = filteredBills[index];
                      final supplierName =
                          suppliersMap[bill.supplierId] ?? 'Supplier #${bill.supplierId}';
                      return _PurchaseBillCard(
                        bill: bill,
                        supplierName: supplierName,
                        onTap: () => context.push('/purchases/${bill.id}'),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/purchases/new'),
        icon: const Icon(Icons.add),
        label: const Text('Add Purchase Bill'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.primaryBlue,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textDarkPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 13,
      ),
      showCheckmark: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primaryBlue : Colors.grey.shade300,
        ),
      ),
    );
  }
}

class _PurchaseBillCard extends StatelessWidget {
  final PurchaseBill bill;
  final String supplierName;
  final VoidCallback onTap;

  const _PurchaseBillCard({
    required this.bill,
    required this.supplierName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    switch (bill.status) {
      case 'paid':
        statusColor = Colors.green;
        statusText = 'PAID';
        break;
      case 'partially_paid':
        statusColor = Colors.orange.shade800;
        statusText = 'PARTIAL';
        break;
      default:
        statusColor = Colors.red;
        statusText = 'UNPAID';
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      supplierName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'Bill #${bill.billNumber}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDarkSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const Text(' • '),
                        Flexible(
                          child: Text(
                            DateFormatter.display(bill.date),
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        CurrencyFormatter.format(bill.grandTotal),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.textDarkPrimary,
                        ),
                      ),
                      if (bill.balanceDue > 0) ...[
                        const SizedBox(height: 3),
                        Text(
                          'Due: ${CurrencyFormatter.format(bill.balanceDue)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
