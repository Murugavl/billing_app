// Invoice Detail Screen — View document, payment history, & Record Payment dialog
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../db/app_database.dart';
import '../../db/daos/documents_dao.dart';
import '../../services/database_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';
import '../pdf/pdf_preview_screen.dart';
import '../../widgets/app_text_field.dart';
import 'invoice_form_screen.dart';

class InvoiceDetailScreen extends ConsumerWidget {
  const InvoiceDetailScreen({super.key, required this.documentId});

  final int documentId;

  Future<void> _openRecordPaymentDialog(
    BuildContext context,
    WidgetRef ref,
    Document doc,
  ) async {
    final paymentsDao = ref.read(paymentsDaoProvider);
    final maxAmount = doc.balanceDue ?? doc.grandTotal;

    final amountController = TextEditingController(
      text: maxAmount.toStringAsFixed(2),
    );
    final notesController = TextEditingController();
    DateTime paymentDate = DateTime.now();
    String paymentMethod = 'upi'; // default

    final recorded = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) {
          final theme = Theme.of(dialogCtx);
          final cs = theme.colorScheme;

          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.payments_rounded, color: AppColors.primaryBlue),
                const SizedBox(width: 8),
                Text('Record Payment', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Balance Due:', style: theme.textTheme.bodySmall),
                        Text(
                          CurrencyFormatter.format(maxAmount),
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: cs.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: 'Amount Received (₹)',
                    controller: amountController,
                    hint: '0.00',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    prefix: const Icon(Icons.currency_rupee_rounded),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: dialogCtx,
                        initialDate: paymentDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setDialogState(() => paymentDate = picked);
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Payment Date',
                        prefixIcon: Icon(Icons.calendar_today_rounded),
                      ),
                      child: Text(DateFormatter.display(paymentDate)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: paymentMethod,
                    decoration: const InputDecoration(
                      labelText: 'Payment Method',
                      prefixIcon: Icon(Icons.account_balance_wallet_rounded),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'upi', child: Text('UPI / QR Code')),
                      DropdownMenuItem(value: 'cash', child: Text('Cash')),
                      DropdownMenuItem(value: 'bank_transfer', child: Text('Bank Transfer (NEFT/IMPS)')),
                      DropdownMenuItem(value: 'cheque', child: Text('Cheque')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => paymentMethod = val);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes / Txn Ref (Optional)',
                      hintText: 'e.g. GPay Ref #12345678',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final amt = double.tryParse(amountController.text.trim());
                  if (amt == null || amt <= 0) {
                    ScaffoldMessenger.of(dialogCtx).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid payment amount')),
                    );
                    return;
                  }
                  if (amt > maxAmount + 0.01) {
                    ScaffoldMessenger.of(dialogCtx).showSnackBar(
                      SnackBar(content: Text('Amount cannot exceed balance due of ${CurrencyFormatter.format(maxAmount)}')),
                    );
                    return;
                  }

                  await paymentsDao.recordPayment(
                    companion: PaymentsCompanion(
                      documentId: Value(doc.id),
                      amount: Value(amt),
                      date: Value(paymentDate),
                      method: Value(paymentMethod),
                      notes: Value(notesController.text.trim().isEmpty ? null : notesController.text.trim()),
                    ),
                    grandTotal: doc.grandTotal,
                  );

                  if (dialogCtx.mounted) {
                    Navigator.of(dialogCtx).pop(true);
                  }
                },
                child: const Text('Save Payment'),
              ),
            ],
          );
        },
      ),
    );

    if (recorded == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment recorded successfully'),
          backgroundColor: Color(0xFF38A169),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final docsDao = ref.watch(documentsDaoProvider);
    final paymentsDao = ref.watch(paymentsDaoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded),
            tooltip: 'Preview / Share PDF',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PdfPreviewScreen(documentId: documentId),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentWithLines?>(
        stream: docsDao.watchDocumentWithLines(documentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data;
          if (data == null) {
            return const Center(child: Text('Invoice not found'));
          }

          final doc = data.document;
          final lines = data.lineItems;
          final isPaid = doc.status == 'paid';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Invoice Number & Status Header Banner ───────────────────
                Card(
                  elevation: 0,
                  color: cs.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: cs.outline.withAlpha(60)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doc.documentNumber,
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                                Text(
                                  'Date: ${DateFormatter.display(doc.date)}',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                            const Spacer(),
                            _InvoiceStatusBadge(status: doc.status),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Grand Total', style: theme.textTheme.bodySmall),
                                Text(
                                  CurrencyFormatter.format(doc.grandTotal),
                                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Balance Due', style: theme.textTheme.bodySmall),
                                Text(
                                  CurrencyFormatter.format(doc.balanceDue ?? 0.0),
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: (doc.balanceDue ?? 0) > 0 ? cs.error : AppColors.success,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Customer Card ───────────────────────────────────────────
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: cs.outline.withAlpha(60)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BILL TO',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          doc.customerName,
                          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        if (doc.customerPhone != null)
                          Text('Phone: ${doc.customerPhone!}', style: theme.textTheme.bodyMedium),
                        if (doc.customerAddress != null)
                          Text('Address: ${doc.customerAddress!}', style: theme.textTheme.bodyMedium),
                        if (doc.customerGstNumber != null) ...[
                          const SizedBox(height: 4),
                          Text('GSTIN: ${doc.customerGstNumber!}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: cs.primary)),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Line Items List ─────────────────────────────────────────
                Text(
                  'LINE ITEMS',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: cs.onSurface.withAlpha(160)),
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
                    padding: const EdgeInsets.all(12),
                    itemCount: lines.length,
                    separatorBuilder: (_, __) => const Divider(height: 16),
                    itemBuilder: (ctx, idx) {
                      final item = lines[idx];
                      return Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.itemName,
                                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                Text(
                                  '${item.quantity} ${item.unit} × ${CurrencyFormatter.format(item.pricePerUnit)}',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(item.lineTotal),
                            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // ── Payment History Section ──────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PAYMENT HISTORY',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: cs.onSurface.withAlpha(160)),
                    ),
                    if (!isPaid)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () => _openRecordPaymentDialog(context, ref, doc),
                        icon: const Icon(Icons.add_rounded, size: 16),
                        label: const Text('Record Payment', style: TextStyle(fontSize: 12)),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                StreamBuilder<List<Payment>>(
                  stream: paymentsDao.watchPaymentsForDocument(doc.id),
                  builder: (ctx, paySnapshot) {
                    final paymentsList = paySnapshot.data ?? [];
                    if (paymentsList.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: cs.outline.withAlpha(60)),
                        ),
                        child: Text(
                          'No payments recorded yet.',
                          style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface.withAlpha(140)),
                          textAlign: TextAlign.center,
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
                        padding: const EdgeInsets.all(12),
                        itemCount: paymentsList.length,
                        separatorBuilder: (_, __) => const Divider(height: 12),
                        itemBuilder: (ctx, idx) {
                          final p = paymentsList[idx];
                          return Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withAlpha(20),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      CurrencyFormatter.format(p.amount),
                                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    Text(
                                      'Method: ${p.method.replaceAll('_', ' ').toUpperCase()}',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                    if (p.notes != null)
                                      Text(p.notes!, style: TextStyle(fontSize: 11, color: cs.onSurface.withAlpha(140))),
                                  ],
                                ),
                              ),
                              Text(
                                DateFormatter.display(p.date),
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // ── Edit / PDF Action Buttons ───────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => InvoiceFormScreen(documentWithLines: data),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('Edit Invoice'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PdfPreviewScreen(documentId: documentId),
                            ),
                          );
                        },
                        icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                        label: const Text('View / Share PDF'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InvoiceStatusBadge extends StatelessWidget {
  const _InvoiceStatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'paid':
        color = AppColors.success;
        break;
      case 'partially_paid':
        color = Colors.amber.shade800;
        break;
      case 'overdue':
        color = AppColors.error;
        break;
      case 'sent':
        color = AppColors.primaryBlue;
        break;
      default:
        color = Colors.grey.shade600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
