// Home / Dashboard screen — Live dashboard summary cards & Sales vs Purchases Net Margin analytics
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../db/app_database.dart';
import '../../providers/business_profile_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../services/database_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';
import '../invoices/invoice_detail_screen.dart';
import '../pdf/pdf_preview_screen.dart';
import '../search/global_search_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final profileAsync = ref.watch(businessProfileProvider);
    final statsAsync = ref.watch(dashboardStatsProvider);
    final selectedRange = ref.watch(dashboardDateRangeProvider);
    final docsDao = ref.watch(documentsDaoProvider);

    final businessName = profileAsync.when(
      data: (p) => p?.businessName ?? 'Billwise',
      loading: () => 'Billwise',
      error: (_, __) => 'Billwise',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(businessName, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Global Search',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const GlobalSearchScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dashboardStatsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Greeting Card ───────────────────────────────────────────────
            _GreetingCard(businessName: businessName, date: DateTime.now()),
            const SizedBox(height: 20),

            // ── Date Range Filter Bar ───────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Financial Overview', style: theme.textTheme.titleMedium),
                DropdownButton<DashboardDateRange>(
                  value: selectedRange,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.calendar_month_outlined, size: 18),
                  items: const [
                    DropdownMenuItem(
                        value: DashboardDateRange.today, child: Text('Today')),
                    DropdownMenuItem(
                        value: DashboardDateRange.thisWeek, child: Text('This Week')),
                    DropdownMenuItem(
                        value: DashboardDateRange.thisMonth, child: Text('This Month')),
                    DropdownMenuItem(
                        value: DashboardDateRange.thisYear, child: Text('This Year')),
                    DropdownMenuItem(
                        value: DashboardDateRange.all, child: Text('All Time')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      ref.read(dashboardDateRangeProvider.notifier).setDateRange(val);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Sales vs Purchases Net Margin Card ──────────────────────────
            statsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error loading stats: $err'),
              data: (stats) => Column(
                children: [
                  // Sales vs Purchases Card
                  _SalesVsPurchasesCard(stats: stats),
                  const SizedBox(height: 16),

                  // Total Outstanding & Draft Estimates
                  Row(
                    children: [
                      Expanded(
                        child: _SmallStatCard(
                          label: "Unpaid Sales",
                          value: CurrencyFormatter.format(stats.totalOutstanding),
                          subtitle: 'Due from customers',
                          icon: Icons.account_balance_wallet_rounded,
                          color: AppColors.error,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SmallStatCard(
                          label: "Draft Estimates",
                          value: '${stats.draftEstimatesCount}',
                          subtitle: 'Pending quote',
                          icon: Icons.request_quote_rounded,
                          color: AppColors.amberDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Recent Activity ──────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Documents', style: theme.textTheme.titleMedium),
                TextButton(
                  onPressed: () => context.go('/invoices'),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            FutureBuilder<List<Document>>(
              future: docsDao.getAllDocuments(),
              builder: (ctx, snapshot) {
                final list = snapshot.data ?? [];
                if (list.isEmpty) {
                  return const _EmptyDocumentsCard();
                }

                final recent = list.take(5).toList();

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recent.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (ctx, idx) {
                    final doc = recent[idx];
                    final isInvoice = doc.type == 'invoice';

                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: cs.outline.withAlpha(60)),
                      ),
                      child: ListTile(
                        onTap: () {
                          if (isInvoice) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => InvoiceDetailScreen(documentId: doc.id),
                              ),
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PdfPreviewScreen(documentId: doc.id),
                              ),
                            );
                          }
                        },
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (isInvoice ? AppColors.primaryBlue : AppColors.amberDark).withAlpha(20),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isInvoice ? Icons.receipt_long_rounded : Icons.description_rounded,
                            color: isInvoice ? AppColors.primaryBlue : AppColors.amberDark,
                            size: 20,
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                doc.documentNumber,
                                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              CurrencyFormatter.format(doc.grandTotal),
                              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Expanded(
                              child: Text(
                                doc.customerName,
                                style: theme.textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _StatusBadge(status: doc.status),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_home',
        onPressed: () => _showCreateSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create'),
      ),
    );
  }

  void _showCreateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _CreateBottomSheet(),
    );
  }
}

// ── Dashboard Widgets ─────────────────────────────────────────────────────────

class _GreetingCard extends StatelessWidget {
  const _GreetingCard({required this.businessName, required this.date});
  final String businessName;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryNavy,
            AppColors.primaryNavy.withAlpha(220),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormatter.display(date).toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white.withAlpha(180),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Welcome back,',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.white.withAlpha(220)),
          ),
          Text(
            businessName,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _SalesVsPurchasesCard extends StatelessWidget {
  final DashboardStats stats;

  const _SalesVsPurchasesCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final isProfit = stats.netMargin >= 0;
    final totalVolume = stats.totalSales + stats.totalPurchases;
    final salesRatio = totalVolume == 0 ? 0.5 : (stats.totalSales / totalVolume);
    final purchasesRatio = totalVolume == 0 ? 0.5 : (stats.totalPurchases / totalVolume);

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sales vs Purchases',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isProfit ? Colors.green.withAlpha(30) : Colors.red.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isProfit ? 'PROFIT' : 'LOSS',
                    style: TextStyle(
                      color: isProfit ? Colors.green.shade800 : Colors.red.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.arrow_upward, color: Colors.green, size: 16),
                          SizedBox(width: 4),
                          Text('Total Sales', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          CurrencyFormatter.format(stats.totalSales),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 36, width: 1, color: Colors.grey.shade300),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.arrow_downward, color: Colors.red, size: 16),
                            SizedBox(width: 4),
                            Text('Total Purchases', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            CurrencyFormatter.format(stats.totalPurchases),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Visual Comparison Bar Chart
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 12,
                child: Row(
                  children: [
                    Expanded(
                      flex: (salesRatio * 100).round().clamp(1, 99),
                      child: Container(color: Colors.green),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      flex: (purchasesRatio * 100).round().clamp(1, 99),
                      child: Container(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Net Margin Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Net Margin (Sales − Purchases):',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      CurrencyFormatter.format(stats.netMargin),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isProfit ? Colors.green.shade800 : Colors.red.shade800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallStatCard extends StatelessWidget {
  const _SmallStatCard({
    required this.label,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: cs.outline.withAlpha(60)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: cs.onSurface.withAlpha(160)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (subtitle != null)
              Text(subtitle!, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _EmptyDocumentsCard extends StatelessWidget {
  const _EmptyDocumentsCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline.withAlpha(80)),
      ),
      child: Column(
        children: [
          Icon(Icons.description_outlined, size: 40, color: cs.onSurface.withAlpha(120)),
          const SizedBox(height: 10),
          Text(
            'No documents created yet',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Create your first invoice or estimate to see sales activity here.',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'paid':
      case 'accepted':
        color = AppColors.success;
        break;
      case 'partially_paid':
        color = Colors.amber.shade800;
        break;
      case 'overdue':
      case 'expired':
        color = AppColors.error;
        break;
      default:
        color = AppColors.primaryBlue;
    }

    return Text(
      status.replaceAll('_', ' ').toUpperCase(),
      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
    );
  }
}

class _CreateBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: cs.outline.withAlpha(100),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text('Create New', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'Choose a transaction type to create',
              style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withAlpha(150)),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _CreateOption(
                    icon: Icons.receipt_long_rounded,
                    label: 'Invoice',
                    subtitle: 'Bill customer',
                    color: AppColors.primaryBlue,
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/invoices/new');
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _CreateOption(
                    icon: Icons.description_rounded,
                    label: 'Estimate',
                    subtitle: 'Quote customer',
                    color: AppColors.amberDark,
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/estimates/new');
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _CreateOption(
                    icon: Icons.shopping_bag_rounded,
                    label: 'Purchase',
                    subtitle: 'Supplier bill',
                    color: Colors.purple,
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/purchases/new');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateOption extends StatelessWidget {
  const _CreateOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10, color: cs.onSurface.withAlpha(150)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
