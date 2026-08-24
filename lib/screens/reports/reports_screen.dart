// Reports & Analytics Screen — Sales vs Purchases, Outstanding payments, Top Customers, CSV/PDF export
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/reports_provider.dart';
import '../../services/csv_service.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  Future<void> _pickCustomDateRange(BuildContext context, WidgetRef ref) async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (range != null) {
      ref.read(reportCustomDateRangeProvider.notifier).setRange(DateRange(
        DateTime(range.start.year, range.start.month, range.start.day),
        DateTime(range.end.year, range.end.month, range.end.day, 23, 59, 59),
      ));
      ref.read(reportDateFilterProvider.notifier).setFilter(ReportDateFilter.custom);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final dateFilter = ref.watch(reportDateFilterProvider);
    final activeRange = ref.watch(activeDateRangeProvider);
    final salesReportAsync = ref.watch(salesReportProvider);
    final purchaseReportAsync = ref.watch(purchaseReportProvider);
    final topCustomersAsync = ref.watch(topCustomersProvider);
    final outstandingAsync = ref.watch(outstandingReportProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Date Filter Row ─────────────────────────────────────────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'Today',
                    isSelected: dateFilter == ReportDateFilter.today,
                    onSelected: () => ref.read(reportDateFilterProvider.notifier).setFilter(ReportDateFilter.today),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'This Week',
                    isSelected: dateFilter == ReportDateFilter.thisWeek,
                    onSelected: () => ref.read(reportDateFilterProvider.notifier).setFilter(ReportDateFilter.thisWeek),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'This Month',
                    isSelected: dateFilter == ReportDateFilter.thisMonth,
                    onSelected: () => ref.read(reportDateFilterProvider.notifier).setFilter(ReportDateFilter.thisMonth),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Custom Range',
                    isSelected: dateFilter == ReportDateFilter.custom,
                    onSelected: () => _pickCustomDateRange(context, ref),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Range: ${DateFormatter.display(activeRange.start)} - ${DateFormatter.display(activeRange.end)}',
              style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withAlpha(140)),
            ),

            const SizedBox(height: 20),

            // ── Sales Report Card ───────────────────────────────────────────
            salesReportAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error loading sales report: $err'),
              data: (sales) => Card(
                elevation: 0,
                color: AppColors.primaryBlue.withAlpha(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: AppColors.primaryBlue.withAlpha(60)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(Icons.bar_chart_rounded, color: AppColors.primaryBlue),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Sales Summary',
                                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: sales.invoices.isEmpty
                                ? null
                                : () => CsvService.shareSalesReport(sales.invoices, dateFilter.name),
                            icon: const Icon(Icons.file_download_outlined, size: 14),
                            label: const Text('Export CSV', style: TextStyle(fontSize: 11)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Sales Revenue', style: theme.textTheme.bodySmall),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    CurrencyFormatter.format(sales.totalSales),
                                    style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Invoices Issued', style: theme.textTheme.bodySmall),
                              Text('${sales.invoiceCount}', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Avg Invoice Value: ${CurrencyFormatter.format(sales.averageInvoiceValue)}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Purchase Report Card ─────────────────────────────────────────
            purchaseReportAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error loading purchase report: $err'),
              data: (purchase) => Card(
                elevation: 0,
                color: Colors.purple.withAlpha(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.purple.withAlpha(60)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(Icons.shopping_bag_outlined, color: Colors.purple),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Purchase Summary',
                                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: purchase.bills.isEmpty
                                ? null
                                : () => CsvService.sharePurchaseReport(purchase.bills, dateFilter.name),
                            icon: const Icon(Icons.file_download_outlined, size: 14),
                            label: const Text('Export CSV', style: TextStyle(fontSize: 11)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Purchase Outlay', style: theme.textTheme.bodySmall),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    CurrencyFormatter.format(purchase.totalPurchases),
                                    style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.purple),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Purchase Bills', style: theme.textTheme.bodySmall),
                              Text('${purchase.billCount}', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Avg Bill Value: ${CurrencyFormatter.format(purchase.averageBillValue)}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Outstanding Payments Report Card ────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Outstanding Payments Report',
                    style: theme.textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                outstandingAsync.when(
                  data: (list) => list.isEmpty
                      ? const SizedBox.shrink()
                      : IconButton(
                          icon: const Icon(Icons.share_rounded, size: 18),
                          tooltip: 'Export CSV',
                          onPressed: () => CsvService.shareOutstandingReport(list),
                        ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            outstandingAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error: $err'),
              data: (report) {
                if (report.isEmpty) {
                  return Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, color: AppColors.success),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'No outstanding payment balances! All invoices are fully paid.',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final totalDueSum = report.fold(0.0, (prev, e) => prev + e.totalOutstanding);

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: cs.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Total Outstanding Across ${report.length} Customers:',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: cs.onErrorContainer),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(CurrencyFormatter.format(totalDueSum), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: cs.onErrorContainer)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: cs.outline.withAlpha(60)),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: report.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (ctx, idx) {
                          final item = report[idx];
                          return ListTile(
                            dense: true,
                            title: Text(item.customerName, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                            subtitle: Text('${item.unpaidInvoicesCount} unpaid invoice(s)', style: theme.textTheme.bodySmall),
                            trailing: Text(
                              CurrencyFormatter.format(item.totalOutstanding),
                              style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: cs.error, fontSize: 14),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // ── Top Customers by Revenue Report Card ───────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Top Customers by Revenue', style: theme.textTheme.titleMedium),
                topCustomersAsync.when(
                  data: (list) => list.isEmpty
                      ? const SizedBox.shrink()
                      : IconButton(
                          icon: const Icon(Icons.share_rounded, size: 18),
                          tooltip: 'Export CSV',
                          onPressed: () => CsvService.shareTopCustomersReport(list),
                        ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            topCustomersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error: $err'),
              data: (list) {
                if (list.isEmpty) {
                  return const Card(
                    elevation: 0,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No customer sales history yet.'),
                    ),
                  );
                }

                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: cs.outline.withAlpha(60)),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (ctx, idx) {
                      final item = list[idx];
                      return ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          radius: 14,
                          backgroundColor: cs.primaryContainer,
                          child: Text('#${idx + 1}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: cs.primary)),
                        ),
                        title: Text(item.customerName, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                        subtitle: Text('${item.invoiceCount} invoice(s)', style: theme.textTheme.bodySmall),
                        trailing: Text(
                          CurrencyFormatter.format(item.totalRevenue),
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: isSelected,
      onSelected: (_) => onSelected(),
    );
  }
}
