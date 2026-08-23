// Estimates Tab Screen — list of all estimates with search, status filters, Convert to Invoice action, and creation FAB
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../db/app_database.dart';
import '../../db/daos/documents_dao.dart';
import '../../providers/estimates_provider.dart';
import '../../services/database_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';
import '../invoices/invoice_form_screen.dart';
import 'estimate_form_screen.dart';
import '../pdf/pdf_preview_screen.dart';

class EstimatesScreen extends ConsumerStatefulWidget {
  const EstimatesScreen({super.key});

  @override
  ConsumerState<EstimatesScreen> createState() => _EstimatesScreenState();
}

class _EstimatesScreenState extends ConsumerState<EstimatesScreen> {
  late final TextEditingController _searchController;
  String _selectedStatusFilter = 'ALL';

  static const List<String> _statusFilters = [
    'ALL',
    'DRAFT',
    'SENT',
    'ACCEPTED',
    'EXPIRED'
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(estimateSearchQueryProvider),
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
        content: const Text('Are you sure you want to delete this estimate?'),
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
          builder: (_) => EstimateFormScreen(documentWithLines: docWithLines),
        ),
      );
    }
  }

  Future<void> _convertToInvoice(BuildContext context, Document doc) async {
    final docsDao = ref.read(documentsDaoProvider);
    final docWithLines = await docsDao.getDocumentWithLines(doc.id);
    if (docWithLines == null || !context.mounted) return;

    // Create draft Invoice Document
    final draftDoc = Document(
      id: 0,
      documentNumber: '', // will auto-generate INV-xxxx
      type: 'invoice',
      customerId: doc.customerId,
      customerName: doc.customerName,
      customerPhone: doc.customerPhone,
      customerAddress: doc.customerAddress,
      customerGstNumber: doc.customerGstNumber,
      date: DateTime.now(),
      placeOfSupply: doc.placeOfSupply,
      subtotal: doc.subtotal,
      totalDiscount: doc.totalDiscount,
      totalTax: doc.totalTax,
      grandTotal: doc.grandTotal,
      amountReceived: 0.0,
      balanceDue: doc.grandTotal,
      amountInWords: doc.amountInWords,
      status: 'draft',
      notes: doc.notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Update estimate status to accepted
    await docsDao.updateStatus(doc.id, 'accepted');

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Converted ${doc.documentNumber} to Invoice'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => InvoiceFormScreen(
            documentWithLines: DocumentWithLines(
              document: draftDoc,
              lineItems: docWithLines.lineItems,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final estimates = ref.watch(filteredEstimatesProvider);
    final asyncAllEstimates = ref.watch(estimatesStreamProvider);
    final searchQuery = ref.watch(estimateSearchQueryProvider);

    final displayList = estimates.where((doc) {
      if (_selectedStatusFilter == 'ALL') return true;
      return doc.status.toUpperCase() == _selectedStatusFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estimates / Quotations'),
      ),
      body: Column(
        children: [
          // ── Search bar ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                ref.read(estimateSearchQueryProvider.notifier).setQuery(val);
              },
              decoration: InputDecoration(
                hintText: 'Search by estimate #, customer name...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(estimateSearchQueryProvider.notifier).clear();
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
                  child: ChoiceChip(
                    label: Text(label, style: const TextStyle(fontSize: 12)),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedStatusFilter = st);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          // ── Estimates List ──────────────────────────────────────────────
          Expanded(
            child: asyncAllEstimates.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error loading estimates: $err')),
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
                              color: AppColors.amberDark.withAlpha(25),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.description_rounded, size: 48, color: AppColors.amberDark),
                          ),
                          const SizedBox(height: 16),
                          Text('No Estimates Yet', style: theme.textTheme.titleLarge),
                          const SizedBox(height: 8),
                          Text(
                            'Create quotations and estimates to send to your clients.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurface.withAlpha(140),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.amberDark,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const EstimateFormScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Create First Estimate'),
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
                          'No estimates found matching criteria',
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
                        onTap: () => _openEdit(context, doc),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.amberDark.withAlpha(20),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.description_rounded, color: AppColors.amberDark, size: 22),
                        ),
                        title: Row(
                          children: [
                            Text(
                              doc.documentNumber,
                              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const Spacer(),
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
                              _EstimateStatusChip(status: doc.status),
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
                            } else if (val == 'convert') {
                              _convertToInvoice(context, doc);
                            } else if (val == 'delete') {
                              _handleDelete(context, doc);
                            }
                          },
                          itemBuilder: (ctx) => [
                            const PopupMenuItem(
                              value: 'pdf',
                              child: Row(
                                children: [
                                  Icon(Icons.picture_as_pdf_outlined, size: 18, color: AppColors.amberDark),
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
                                  Text('Edit Estimate'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'convert',
                              child: Row(
                                children: [
                                  Icon(Icons.transform_rounded, size: 18, color: AppColors.primaryBlue),
                                  SizedBox(width: 8),
                                  Text('Convert to Invoice', style: TextStyle(color: AppColors.primaryBlue)),
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
        heroTag: 'fab_estimate_screen',
        backgroundColor: AppColors.amberDark,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const EstimateFormScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Estimate'),
      ),
    );
  }
}

class _EstimateStatusChip extends StatelessWidget {
  const _EstimateStatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'accepted':
        color = AppColors.success;
        break;
      case 'expired':
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
