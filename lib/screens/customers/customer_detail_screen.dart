import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../db/app_database.dart';
import '../../providers/customers_provider.dart';
import '../../services/database_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';
import '../pdf/pdf_preview_screen.dart';
import 'customer_form_screen.dart';

class CustomerDetailScreen extends ConsumerWidget {
  const CustomerDetailScreen({super.key, required this.customerId});

  final int customerId;

  Future<void> _handleDelete(BuildContext context, WidgetRef ref, Customer customer) async {
    final docsDao = ref.read(documentsDaoProvider);
    final count = await docsDao.getDocumentCountForCustomer(customer.id);

    if (!context.mounted) return;

    if (count > 0) {
      // Show warning dialog — cannot delete
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: Icon(Icons.warning_amber_rounded, size: 40, color: Theme.of(ctx).colorScheme.error),
          title: const Text('Cannot Delete Customer'),
          content: Text(
            '${customer.name} has $count document(s) (invoices/estimates) associated with them.\n\nYou must delete their documents first before removing this customer.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Show confirmation dialog
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete Customer?'),
          content: Text('Are you sure you want to delete ${customer.name}? This action cannot be undone.'),
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
        final custDao = ref.read(customersDaoProvider);
        await custDao.deleteCustomer(customer.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${customer.name} deleted'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(context).pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final customersAsync = ref.watch(customersStreamProvider);

    final customer = customersAsync.when(
      data: (list) => list.firstWhere(
        (c) => c.id == customerId,
        orElse: () => Customer(
          id: -1,
          name: '',
          phone: '',
          address: '',
          createdAt: DateTime.now(),
        ),
      ),
      loading: () => null,
      error: (_, __) => null,
    );

    if (customer == null || customer.id == -1) {
      return Scaffold(
        appBar: AppBar(title: const Text('Customer Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final docsAsync = ref.watch(customerDocumentsProvider(customerId));

    return Scaffold(
      appBar: AppBar(
        title: Text(customer.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            tooltip: 'Edit Customer',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CustomerFormScreen(customer: customer),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            tooltip: 'Delete Customer',
            onPressed: () => _handleDelete(context, ref, customer),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Customer Card ────────────────────────────────────────────────
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: cs.outline.withAlpha(80)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: cs.primaryContainer,
                          child: Text(
                            customer.name.substring(0, 1).toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: cs.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.phone_rounded, size: 14, color: cs.primary),
                                  const SizedBox(width: 4),
                                  Text(customer.phone ?? '', style: theme.textTheme.bodyMedium),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    if (customer.email != null && customer.email!.isNotEmpty) ...[
                      _InfoRow(
                        icon: Icons.email_rounded,
                        label: 'Email',
                        value: customer.email!,
                      ),
                      const SizedBox(height: 10),
                    ],
                    if (customer.address != null && customer.address!.isNotEmpty)
                      _InfoRow(
                        icon: Icons.location_on_rounded,
                        label: 'Address',
                        value: customer.address!,
                      ),
                    if (customer.gstNumber != null && customer.gstNumber!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _InfoRow(
                        icon: Icons.receipt_long_rounded,
                        label: 'GSTIN',
                        value: customer.gstNumber!,
                        isBadge: true,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Document History Section ─────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Document History',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                docsAsync.when(
                  data: (docs) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${docs.length} total',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: cs.primary,
                      ),
                    ),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            docsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error loading history: $err'),
              ),
              data: (docs) {
                if (docs.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: cs.outline.withAlpha(60)),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.history_rounded, size: 40, color: cs.onSurface.withAlpha(80)),
                        const SizedBox(height: 10),
                        Text(
                          'No document history',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: cs.onSurface.withAlpha(160),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Invoices and estimates created for this customer will appear here.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withAlpha(120),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final isInvoice = doc.type == 'invoice';
                    final badgeColor = isInvoice ? AppColors.primaryBlue : AppColors.amberDark;

                    return Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: cs.outline.withAlpha(60)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PdfPreviewScreen(documentId: doc.id),
                            ),
                          );
                        },
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: badgeColor.withAlpha(20),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isInvoice ? Icons.receipt_long_rounded : Icons.description_rounded,
                            color: badgeColor,
                            size: 20,
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              doc.documentNumber,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _TypeChip(type: doc.type),
                          ],
                        ),
                        subtitle: Text(
                          DateFormatter.display(doc.date),
                          style: theme.textTheme.bodySmall,
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              CurrencyFormatter.format(doc.grandTotal),
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: cs.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            _StatusChip(status: doc.status),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isBadge = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isBadge;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: cs.onSurface.withAlpha(150)),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: cs.onSurface.withAlpha(150),
          ),
        ),
        Expanded(
          child: isBadge
              ? UnconstrainedBox(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: cs.primary,
                      ),
                    ),
                  ),
                )
              : Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: cs.onSurface,
                  ),
                ),
        ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final isInvoice = type == 'invoice';
    final color = isInvoice ? AppColors.primaryBlue : AppColors.amberDark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'paid':
        color = AppColors.success;
        break;
      case 'partially_paid':
        color = AppColors.primaryBlueMid;
        break;
      case 'accepted':
        color = AppColors.success;
        break;
      case 'overdue':
      case 'expired':
        color = AppColors.error;
        break;
      case 'sent':
        color = AppColors.amberDark;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
