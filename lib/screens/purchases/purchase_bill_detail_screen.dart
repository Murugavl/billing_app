// Purchase Bill Detail Screen — View details & record supplier payments
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../db/app_database.dart';
import '../../providers/purchases_provider.dart';
import '../../providers/suppliers_provider.dart';
import '../../services/database_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/section_card.dart';

class PurchaseBillDetailScreen extends ConsumerWidget {
  final int billId;

  const PurchaseBillDetailScreen({super.key, required this.billId});

  void _showRecordPaymentDialog(
      BuildContext context, WidgetRef ref, PurchaseBill bill) {
    final amountCtrl =
        TextEditingController(text: bill.balanceDue.toStringAsFixed(2));
    final notesCtrl = TextEditingController();
    String selectedMethod = 'cash';
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) {
          return AlertDialog(
            title: const Text('Record Supplier Payment'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bill #${bill.billNumber}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDarkSecondary,
                    ),
                  ),
                  Text(
                    'Balance Due: ${CurrencyFormatter.format(bill.balanceDue)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Payment Amount (₹) *',
                    controller: amountCtrl,
                    hint: '0.00',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedMethod,
                    decoration: const InputDecoration(
                      labelText: 'Payment Method',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'cash', child: Text('Cash')),
                      DropdownMenuItem(value: 'upi', child: Text('UPI / GPay')),
                      DropdownMenuItem(
                          value: 'bank_transfer', child: Text('Bank Transfer')),
                      DropdownMenuItem(value: 'cheque', child: Text('Cheque')),
                    ],
                    onChanged: (val) =>
                        setDlgState(() => selectedMethod = val ?? 'cash'),
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'Notes / Reference (Optional)',
                    controller: notesCtrl,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final amount = double.tryParse(amountCtrl.text) ?? 0.0;
                  if (amount <= 0) return;

                  await ref.read(purchaseBillsDaoProvider).recordPayment(
                        billId: bill.id,
                        amount: amount,
                        date: selectedDate,
                        method: selectedMethod,
                        notes: notesCtrl.text.trim().isEmpty
                            ? null
                            : notesCtrl.text.trim(),
                      );

                  if (context.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payment recorded successfully')),
                    );
                  }
                },
                child: const Text('Record'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(purchaseBillDetailProvider(billId));
    final paymentsAsync = ref.watch(purchaseBillPaymentsProvider(billId));
    final suppliersAsync = ref.watch(suppliersStreamProvider);
    final suppliersList = suppliersAsync.asData?.value ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Bill Details'),
      ),
      body: detailAsync.when(
        data: (detail) {
          if (detail == null) {
            return const Center(child: Text('Purchase Bill not found'));
          }

          final bill = detail.bill;
          final lines = detail.lineItems;
          final supplier = suppliersList.firstWhere(
            (s) => s.id == bill.supplierId,
            orElse: () => Supplier(
              id: bill.supplierId,
              name: 'Supplier #${bill.supplierId}',
              phone: '',
              createdAt: DateTime.now(),
            ),
          );

          Color statusColor;
          String statusText;
          switch (bill.status) {
            case 'paid':
              statusColor = Colors.green;
              statusText = 'PAID';
              break;
            case 'partially_paid':
              statusColor = Colors.orange.shade800;
              statusText = 'PARTIALLY PAID';
              break;
            default:
              statusColor = Colors.red;
              statusText = 'UNPAID';
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Status Header Card
                Card(
                  elevation: 0,
                  color: AppColors.backgroundLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bill #${bill.billNumber}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Date: ${DateFormatter.display(bill.date)}',
                              style: const TextStyle(color: AppColors.textDarkSecondary),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Supplier Card
                SectionCard(
                  title: 'Supplier Details',
                  icon: Icons.storefront_rounded,
                  children: [
                    Text(
                      supplier.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Phone: ${supplier.phone}'),
                    if (supplier.gstNumber != null)
                      Text('GSTIN: ${supplier.gstNumber}'),
                    if (supplier.address != null)
                      Text('Address: ${supplier.address}'),
                  ],
                ),

                const SizedBox(height: 16),

                // Purchased Line Items Table
                SectionCard(
                  title: 'Purchased Items (${lines.length})',
                  icon: Icons.inventory_2_rounded,
                  children: lines.map((l) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l.itemName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${l.quantity} ${l.unit} x ${CurrencyFormatter.format(l.pricePerUnit)}',
                                  style: const TextStyle(
                                      color: AppColors.textDarkSecondary,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(l.lineTotal),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Financial Summary Card
                SectionCard(
                  title: 'Payment Breakdown',
                  icon: Icons.account_balance_wallet_rounded,
                  children: [
                    _DetailRow(
                        label: 'Subtotal', amount: bill.subtotal),
                    _DetailRow(
                        label: 'Total Tax', amount: bill.totalTax),
                    const Divider(height: 16),
                    _DetailRow(
                      label: 'Grand Total',
                      amount: bill.grandTotal,
                      isBold: true,
                      fontSize: 16,
                    ),
                    _DetailRow(
                      label: 'Amount Paid',
                      amount: bill.amountPaid,
                      color: Colors.green,
                    ),
                    _DetailRow(
                      label: 'Balance Due',
                      amount: bill.balanceDue,
                      isBold: true,
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Payment History Card
                SectionCard(
                  title: 'Payment History',
                  icon: Icons.history_rounded,
                  children: [
                    paymentsAsync.when(
                      data: (payments) {
                        if (payments.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text('No payments recorded yet.'),
                          );
                        }
                        return Column(
                          children: payments.map((p) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.payment, color: Colors.green),
                              title: Text(
                                CurrencyFormatter.format(p.amount),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '${p.method.toUpperCase()} • ${DateFormatter.display(p.date)}',
                              ),
                            );
                          }).toList(),
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const SizedBox(),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                if (bill.balanceDue > 0)
                  ElevatedButton.icon(
                    onPressed: () =>
                        _showRecordPaymentDialog(context, ref, bill),
                    icon: const Icon(Icons.add_card),
                    label: const Text('RECORD SUPPLIER PAYMENT'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error loading bill: $e')),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isBold;
  final Color? color;
  final double fontSize;

  const _DetailRow({
    required this.label,
    required this.amount,
    this.isBold = false,
    this.color,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: fontSize,
              color: color,
            ),
          ),
          Text(
            CurrencyFormatter.format(amount),
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: fontSize,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
