// Invoices Tab Screen — list of all invoices with search, filters & creation FAB
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../db/app_database.dart';
import '../../providers/invoices_provider.dart';
import '../../services/database_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/app_filter_chip.dart';
import 'invoice_form_screen.dart';
import 'invoice_detail_screen.dart';
import '../pdf/pdf_preview_screen.dart';

class InvoicesScreen extends ConsumerStatefulWidget {
  const InvoicesScreen({super.key});

  @override
  ConsumerState<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends ConsumerState<InvoicesScreen> {
  late final TextEditingController _searchController;
  String _selectedStatusFilter = 'ALL';

  static const List<String> _statusFilters = [
    'ALL',
    'DRAFT',
    'SENT',
    'PARTIALLY_PAID',
    'PAID',
    'OVERDUE'
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(invoiceSearchQueryProvider),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleDelete(BuildContext context, Document doc) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete ${doc.documentNumber}?'),
        content: const Text('Are you sure you want to delete this invoice? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final docsDao = ref.read(documentsDaoProvider);
      await docsDao.deleteDocument(doc.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${doc.documentNumber} deleted'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _openEdit(BuildContext context, Document doc) async {
    final docsDao = ref.read(documentsDaoProvider);
    final docWithLines = await docsDao.getDocumentWithLines(doc.id);
    if (docWithLines != null && context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => InvoiceFormScreen(documentWithLines: docWithLines),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final invoices = ref.watch(filteredInvoicesProvider);
    final asyncAllInvoices = ref.watch(invoicesStreamProvider);
    final searchQuery = ref.watch(invoiceSearchQueryProvider);

    final displayList = invoices.where((doc) {
      if (_selectedStatusFilter == 'ALL') return true;
      return doc.status.toUpperCase() == _selectedStatusFilter;
    }).toList();

    final totalInvoicesSum = displayList.fold<double>(
      0.0,
      (sum, doc) => sum + doc.grandTotal,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
      ),
      body: Column(
        children: [
          // ── Search bar ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                ref.read(invoiceSearchQueryProvider.notifier).setQuery(val);
              },
              decoration: InputDecoration(
                hintText: 'Search by invoice #, customer name...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(invoiceSearchQueryProvider.notifier).clear();
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // ── Status Filter Chips ─────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: _statusFilters.map((st) {
                final isSelected = _selectedStatusFilter == st;
                final label = st.replaceAll('_', ' ');
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: AppFilterChip(
                    label: label,
                    isSelected: isSelected,
                    onSelected: () {
                      setState(() => _selectedStatusFilter = st);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // ── Total Summary KPI ──────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppColors.primaryBlue.withValues(alpha: 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${displayList.length} Invoices Found',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDarkSecondary,
                  ),
                ),
                Text(
                  'Total: ${CurrencyFormatter.format(totalInvoicesSum)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── Invoice List ────────────────────────────────────────────────
          Expanded(
            child: asyncAllInvoices.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error loading invoices: $err')),
              data: (allList) {
                if (allList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: cs.primaryContainer.withAlpha(100),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.receipt_long_rounded, size: 48, color: cs.primary),
                          ),
                          const SizedBox(height: 16),
                          Text('No Invoices Yet', style: theme.textTheme.titleLarge),
                          const SizedBox(height: 8),
                          Text(
                            'Create your first professional invoice in seconds.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurface.withAlpha(140),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const InvoiceFormScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Create First Invoice'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (displayList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off_rounded, size: 48, color: cs.onSurface.withAlpha(100)),
                        const SizedBox(height: 12),
                        Text(
                          'No invoices found matching criteria',
                          style: theme.textTheme.titleMedium?.copyWith(color: cs.onSurface.withAlpha(160)),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                  itemCount: displayList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final doc = displayList[index];
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: cs.outline.withAlpha(60)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => InvoiceDetailScreen(documentId: doc.id),
                            ),
                          );
                        },
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withAlpha(20),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.receipt_long_rounded, color: AppColors.primaryBlue, size: 22),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                doc.documentNumber,
                                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              CurrencyFormatter.format(doc.grandTotal),
                              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doc.customerName,
                                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(DateFormatter.display(doc.date), style: theme.textTheme.bodySmall),
                                  ],
                                ),
                              ),
                              _InvoiceStatusChip(status: doc.status),
                            ],
                          ),
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert_rounded, size: 20, color: cs.onSurface.withAlpha(140)),
                          onSelected: (val) {
                            if (val == 'pdf') {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => PdfPreviewScreen(documentId: doc.id),
                                ),
                              );
                            } else if (val == 'edit') {
                              _openEdit(context, doc);
                            } else if (val == 'delete') {
                              _handleDelete(context, doc);
                            }
                          },
                          itemBuilder: (ctx) => [
                            const PopupMenuItem(
                              value: 'pdf',
                              child: Row(
                                children: [
                                  Icon(Icons.picture_as_pdf_outlined, size: 18, color: AppColors.primaryBlue),
                                  SizedBox(width: 8),
                                  Text('Preview / Share PDF'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit_outlined, size: 18),
                                  SizedBox(width: 8),
                                  Text('Edit Invoice'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline, size: 18, color: cs.error),
                                  const SizedBox(width: 8),
                                  Text('Delete', style: TextStyle(color: cs.error)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_invoice_screen',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const InvoiceFormScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Invoice'),
      ),
    );
  }
}

class _InvoiceStatusChip extends StatelessWidget {
  const _InvoiceStatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'paid':
        color = AppColors.success;
        break;
      case 'partially_paid':
        color = AppColors.primaryBlueMid;
        break;
      case 'overdue':
        color = AppColors.error;
        break;
      case 'sent':
        color = AppColors.amberDark;
        break;
      default:
        color = Colors.grey.shade600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
