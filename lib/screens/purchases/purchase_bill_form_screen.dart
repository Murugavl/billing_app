// Purchase Bill Form Screen — Create / Edit Purchase Bill
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../db/app_database.dart';
import '../../providers/items_provider.dart';
import '../../providers/suppliers_provider.dart';
import '../../services/database_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/section_card.dart';
import '../suppliers/supplier_form_screen.dart';

class PurchaseBillFormScreen extends ConsumerStatefulWidget {
  final int? billId;

  const PurchaseBillFormScreen({super.key, this.billId});

  @override
  ConsumerState<PurchaseBillFormScreen> createState() =>
      _PurchaseBillFormScreenState();
}

class _PurchaseBillFormScreenState
    extends ConsumerState<PurchaseBillFormScreen> {
  final _formKey = GlobalKey<FormState>();

  Supplier? _selectedSupplier;
  final _billNumberController = TextEditingController();
  final _notesController = TextEditingController();
  final _initialPaidController = TextEditingController(text: '');
  DateTime _selectedDate = DateTime.now();

  List<_TempLineItem> _lineItems = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _billNumberController.text =
        'PUR-${DateFormat('yyyyMMdd-HHmm').format(DateTime.now())}';
  }

  @override
  void dispose() {
    _billNumberController.dispose();
    _notesController.dispose();
    _initialPaidController.dispose();
    super.dispose();
  }

  double get _subtotal =>
      _lineItems.fold(0.0, (sum, line) => sum + line.lineSubtotal);
  double get _totalTax =>
      _lineItems.fold(0.0, (sum, line) => sum + line.taxAmount);
  double get _grandTotal => _subtotal + _totalTax;

  void _addLineItem() {
    _showLineItemDialog();
  }

  void _showLineItemDialog({_TempLineItem? existing, int? index}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final hsnCtrl = TextEditingController(text: existing?.hsnSacCode ?? '');
    final qtyCtrl =
        TextEditingController(text: existing != null ? existing.quantity.toString() : '');
    final unitCtrl = TextEditingController(text: existing?.unit ?? 'Pcs');
    final priceCtrl = TextEditingController(
        text: existing != null ? existing.pricePerUnit.toStringAsFixed(2) : '');
    final taxRateCtrl =
        TextEditingController(text: existing != null ? existing.taxRate.toString() : '');
    Item? selectedItemMaster = existing?.itemMaster;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) {
          final itemsAsync = ref.watch(itemsStreamProvider);
          final catalogItems = itemsAsync.asData?.value ?? [];

          return AlertDialog(
            title: Text(existing == null ? 'Add Line Item' : 'Edit Line Item'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<Item>(
                    value: selectedItemMaster,
                    decoration: const InputDecoration(
                      labelText: 'Select from Product Catalog (Optional)',
                      border: OutlineInputBorder(),
                    ),
                    items: catalogItems.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text('${item.name} (${item.defaultUnit})'),
                      );
                    }).toList(),
                    onChanged: (item) {
                      if (item != null) {
                        setDlgState(() {
                          selectedItemMaster = item;
                          nameCtrl.text = item.name;
                          hsnCtrl.text = item.hsnSacCode ?? '';
                          unitCtrl.text = item.defaultUnit;
                          priceCtrl.text = item.defaultPrice.toString();
                          taxRateCtrl.text = (item.defaultTaxPercent ?? 0.0).toString();
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'Item / Product Name *',
                    controller: nameCtrl,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'HSN/SAC Code',
                          controller: hsnCtrl,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppTextField(
                          label: 'Unit',
                          controller: unitCtrl,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Qty *',
                          controller: qtyCtrl,
                          hint: '1',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppTextField(
                          label: 'Purchase Price/Unit (₹) *',
                          controller: priceCtrl,
                          hint: '0.00',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'GST Tax Rate (%)',
                    controller: taxRateCtrl,
                    hint: '18.0',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
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
                onPressed: () {
                  final name = nameCtrl.text.trim();
                  final qty = double.tryParse(qtyCtrl.text) ?? 1.0;
                  final price = double.tryParse(priceCtrl.text) ?? 0.0;
                  final taxRate = double.tryParse(taxRateCtrl.text) ?? 0.0;

                  if (name.isEmpty) return;

                  final subtotal = qty * price;
                  final taxAmt = (subtotal * taxRate) / 100.0;
                  final lineTotal = subtotal + taxAmt;

                  final newItem = _TempLineItem(
                    itemMaster: selectedItemMaster,
                    name: name,
                    hsnSacCode: hsnCtrl.text.trim().isEmpty ? null : hsnCtrl.text.trim(),
                    quantity: qty,
                    unit: unitCtrl.text.trim().isEmpty ? 'Pcs' : unitCtrl.text.trim(),
                    pricePerUnit: price,
                    taxRate: taxRate,
                    taxAmount: taxAmt,
                    lineSubtotal: subtotal,
                    lineTotal: lineTotal,
                  );

                  setState(() {
                    if (index != null) {
                      _lineItems[index] = newItem;
                    } else {
                      _lineItems.add(newItem);
                    }
                  });
                  Navigator.pop(ctx);
                },
                child: Text(existing == null ? 'Add' : 'Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _savePurchaseBill() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSupplier == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a Supplier')),
      );
      return;
    }
    if (_lineItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one line item')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final initialPaid = double.tryParse(_initialPaidController.text) ?? 0.0;
      final balance = (_grandTotal - initialPaid).clamp(0.0, double.infinity);
      String status = 'unpaid';
      if (balance <= 0.001) {
        status = 'paid';
      } else if (initialPaid > 0) {
        status = 'partially_paid';
      }

      final billCompanion = PurchaseBillsCompanion.insert(
        billNumber: _billNumberController.text.trim(),
        supplierId: _selectedSupplier!.id,
        date: _selectedDate,
        subtotal: _subtotal,
        totalTax: _totalTax,
        grandTotal: _grandTotal,
        amountPaid: drift.Value(initialPaid),
        balanceDue: balance,
        status: drift.Value(status),
        notes: drift.Value(_notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim()),
      );

      final lineCompanions = _lineItems.map((l) {
        return PurchaseLineItemsCompanion.insert(
          purchaseBillId: 0,
          itemId: drift.Value(l.itemMaster?.id),
          itemName: l.name,
          hsnSacCode: drift.Value(l.hsnSacCode),
          quantity: l.quantity,
          unit: drift.Value(l.unit),
          pricePerUnit: l.pricePerUnit,
          taxAmount: drift.Value(l.taxAmount),
          lineTotal: l.lineTotal,
        );
      }).toList();

      await ref.read(purchaseBillsDaoProvider).createPurchaseBill(
            billCompanion: billCompanion,
            lineItemsCompanions: lineCompanions,
            initialPayment: initialPaid,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase Bill created successfully')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save purchase bill: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final suppliersAsync = ref.watch(suppliersStreamProvider);
    final suppliersList = suppliersAsync.asData?.value ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Purchase Bill'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Supplier Picker Card
              SectionCard(
                title: 'Supplier Information',
                icon: Icons.storefront_rounded,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<Supplier>(
                          value: _selectedSupplier,
                          decoration: const InputDecoration(
                            labelText: 'Select Supplier *',
                            border: OutlineInputBorder(),
                          ),
                          items: suppliersList.map((s) {
                            return DropdownMenuItem(
                              value: s,
                              child: Text('${s.name} (${s.phone})'),
                            );
                          }).toList(),
                          onChanged: (supplier) =>
                              setState(() => _selectedSupplier = supplier),
                          validator: (v) =>
                              v == null ? 'Please select a supplier' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        icon: const Icon(Icons.person_add_outlined),
                        tooltip: 'Add New Supplier',
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SupplierFormScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  if (_selectedSupplier != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.storefront,
                              size: 20, color: AppColors.primaryBlue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${_selectedSupplier!.name} | GST: ${_selectedSupplier!.gstNumber ?? "N/A"} | ${_selectedSupplier!.address ?? ""}',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 16),

              // 2. Bill Metadata
              SectionCard(
                title: 'Bill Details',
                icon: Icons.receipt_long_rounded,
                children: [
                  AppTextField(
                    label: 'Purchase Bill Number *',
                    controller: _billNumberController,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Bill Date',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(_selectedDate),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 3. Line Items
              SectionCard(
                title: 'Purchased Items',
                icon: Icons.inventory_2_rounded,
                trailing: TextButton.icon(
                  onPressed: _addLineItem,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Item'),
                ),
                children: [
                  _lineItems.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(24),
                          alignment: Alignment.center,
                          child: Text(
                            'No items added yet. Tap "+ Add Item" above.',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _lineItems.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (ctx, index) {
                            final item = _lineItems[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                item.name,
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '${item.quantity} ${item.unit} x ${CurrencyFormatter.format(item.pricePerUnit)} (Tax: ${item.taxRate}%)',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    CurrencyFormatter.format(item.lineTotal),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 18),
                                    onPressed: () => _showLineItemDialog(
                                        existing: item, index: index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        size: 18, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _lineItems.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ],
              ),

              const SizedBox(height: 16),

              // 4. Financial Summary & Initial Payment
              SectionCard(
                title: 'Financial Summary & Payment',
                icon: Icons.account_balance_wallet_rounded,
                children: [
                  _SummaryRow(label: 'Subtotal', amount: _subtotal),
                  _SummaryRow(label: 'Total Tax', amount: _totalTax),
                  const Divider(height: 20),
                  _SummaryRow(
                    label: 'Grand Total',
                    amount: _grandTotal,
                    isBold: true,
                    fontSize: 16,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Initial Amount Paid (₹)',
                    controller: _initialPaidController,
                    hint: '0.00',
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Balance Due:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(
                          (_grandTotal -
                                  (double.tryParse(
                                          _initialPaidController.text) ??
                                      0.0))
                              .clamp(0.0, double.infinity),
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'Notes / Remarks (Optional)',
                    controller: _notesController,
                    maxLines: 2,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isSaving ? null : _savePurchaseBill,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'SAVE PURCHASE BILL',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TempLineItem {
  final Item? itemMaster;
  final String name;
  final String? hsnSacCode;
  final double quantity;
  final String unit;
  final double pricePerUnit;
  final double taxRate;
  final double taxAmount;
  final double lineSubtotal;
  final double lineTotal;

  _TempLineItem({
    this.itemMaster,
    required this.name,
    this.hsnSacCode,
    required this.quantity,
    required this.unit,
    required this.pricePerUnit,
    required this.taxRate,
    required this.taxAmount,
    required this.lineSubtotal,
    required this.lineTotal,
  });
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isBold;
  final double fontSize;

  const _SummaryRow({
    required this.label,
    required this.amount,
    this.isBold = false,
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
            ),
          ),
          Text(
            CurrencyFormatter.format(amount),
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
