// Line Item Dialog — Add or edit a line item on an invoice/estimate
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../db/app_database.dart';
import '../providers/items_provider.dart';
import '../utils/currency_formatter.dart';
import 'app_text_field.dart';

class LineItemData {
  int? itemId;
  String itemName;
  String? hsnSacCode;
  double quantity;
  String unit;
  double pricePerUnit;
  bool isPercentDiscount; // true = %, false = ₹ flat
  double discountPercent;
  double discountAmount;
  double taxPercent;

  LineItemData({
    this.itemId,
    required this.itemName,
    this.hsnSacCode,
    this.quantity = 1.0,
    this.unit = 'Pcs',
    this.pricePerUnit = 0.0,
    this.isPercentDiscount = true,
    this.discountPercent = 0.0,
    this.discountAmount = 0.0,
    this.taxPercent = 0.0,
  });

  double get subtotal => double.parse((quantity * pricePerUnit).toStringAsFixed(2));

  double get calculatedDiscountAmount {
    if (isPercentDiscount) {
      return double.parse((subtotal * (discountPercent / 100)).toStringAsFixed(2));
    } else {
      return discountAmount;
    }
  }

  double get calculatedDiscountPercent {
    if (subtotal <= 0) return 0.0;
    if (isPercentDiscount) {
      return discountPercent;
    } else {
      return double.parse(((discountAmount / subtotal) * 100).toStringAsFixed(3));
    }
  }

  double get taxableAmount => double.parse((subtotal - calculatedDiscountAmount).toStringAsFixed(2));

  double get taxAmount => double.parse((taxableAmount * (taxPercent / 100)).toStringAsFixed(2));

  double get lineTotal => double.parse((taxableAmount + taxAmount).toStringAsFixed(2));
}

class LineItemDialog extends ConsumerStatefulWidget {
  const LineItemDialog({super.key, this.initialLine});

  final LineItemData? initialLine;

  @override
  ConsumerState<LineItemDialog> createState() => _LineItemDialogState();
}

class _LineItemDialogState extends ConsumerState<LineItemDialog> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedItemId;
  late final TextEditingController _nameController;
  late final TextEditingController _hsnController;
  late final TextEditingController _qtyController;
  late final TextEditingController _unitController;
  late final TextEditingController _priceController;
  late final TextEditingController _discountController;
  late final TextEditingController _taxController;

  late final TextEditingController _catalogSearchController;
  String _catalogQuery = '';

  bool _isPercentDiscount = true;
  bool _showCatalogPicker = false;

  @override
  void initState() {
    super.initState();
    _catalogSearchController = TextEditingController();
    _catalogSearchController.addListener(() {
      setState(() => _catalogQuery = _catalogSearchController.text.trim().toLowerCase());
    });

    final init = widget.initialLine;
    _selectedItemId = init?.itemId;
    _nameController = TextEditingController(text: init?.itemName ?? '');
    _hsnController = TextEditingController(text: init?.hsnSacCode ?? '');
    _qtyController = TextEditingController(
      text: init != null ? init.quantity.toString() : '',
    );
    _unitController = TextEditingController(text: init?.unit ?? 'Pcs');
    _priceController = TextEditingController(
      text: init != null ? init.pricePerUnit.toStringAsFixed(2) : '',
    );

    _isPercentDiscount = init?.isPercentDiscount ?? true;
    _discountController = TextEditingController(
      text: init != null
          ? (_isPercentDiscount
              ? init.discountPercent.toString()
              : init.discountAmount.toStringAsFixed(2))
          : '',
    );

    _taxController = TextEditingController(
      text: init != null ? init.taxPercent.toString() : '',
    );

    // If adding fresh, default to showing catalog picker first
    if (widget.initialLine == null) {
      _showCatalogPicker = true;
    }
  }

  @override
  void dispose() {
    _catalogSearchController.dispose();
    _nameController.dispose();
    _hsnController.dispose();
    _qtyController.dispose();
    _unitController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  void _populateFromCatalog(Item item) {
    setState(() {
      _selectedItemId = item.id;
      _nameController.text = item.name;
      _hsnController.text = item.hsnSacCode ?? '';
      _unitController.text = item.defaultUnit;
      _priceController.text = item.defaultPrice.toStringAsFixed(2);
      _taxController.text = (item.defaultTaxPercent ?? 0.0).toString();
      _showCatalogPicker = false;
    });
  }

  LineItemData _buildLineData() {
    final qty = double.tryParse(_qtyController.text.trim()) ?? 1.0;
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final discVal = double.tryParse(_discountController.text.trim()) ?? 0.0;
    final tax = double.tryParse(_taxController.text.trim()) ?? 0.0;

    return LineItemData(
      itemId: _selectedItemId,
      itemName: _nameController.text.trim(),
      hsnSacCode: _hsnController.text.trim().isEmpty ? null : _hsnController.text.trim(),
      quantity: qty,
      unit: _unitController.text.trim().isEmpty ? 'Pcs' : _unitController.text.trim(),
      pricePerUnit: price,
      isPercentDiscount: _isPercentDiscount,
      discountPercent: _isPercentDiscount ? discVal : 0.0,
      discountAmount: _isPercentDiscount ? 0.0 : discVal,
      taxPercent: tax,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final asyncItems = ref.watch(itemsStreamProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 680),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.initialLine == null ? 'Add Line Item' : 'Edit Line Item',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(),

              if (_showCatalogPicker) ...[
                // Catalog picker mode
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Select from Catalog',
                        style: theme.textTheme.titleSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => setState(() => _showCatalogPicker = false),
                          icon: const Icon(Icons.edit_note_rounded, size: 18),
                          label: const Text('Custom / Manual Entry'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: asyncItems.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline_rounded, size: 36, color: Colors.red),
                          const SizedBox(height: 8),
                          Text('Error loading catalog: $err'),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => setState(() => _showCatalogPicker = false),
                            child: const Text('Enter Manually'),
                          ),
                        ],
                      ),
                    ),
                    data: (allItems) {
                      debugPrint('[LineItemDialog] Catalog item count from DB: ${allItems.length}');
                      if (allItems.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.inventory_2_outlined, size: 40, color: Colors.grey),
                              const SizedBox(height: 8),
                              const Text('No items in catalog'),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () => setState(() => _showCatalogPicker = false),
                                child: const Text('Enter Manually'),
                              ),
                            ],
                          ),
                        );
                      }

                      final filtered = allItems.where((item) {
                        if (_catalogQuery.isEmpty) return true;
                        final nameMatch = item.name.toLowerCase().contains(_catalogQuery);
                        final hsnMatch = item.hsnSacCode?.toLowerCase().contains(_catalogQuery) ?? false;
                        final unitMatch = item.defaultUnit.toLowerCase().contains(_catalogQuery);
                        return nameMatch || hsnMatch || unitMatch;
                      }).toList();

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: TextField(
                              controller: _catalogSearchController,
                              decoration: InputDecoration(
                                hintText: 'Search catalog items...',
                                prefixIcon: const Icon(Icons.search_rounded, size: 18),
                                suffixIcon: _catalogQuery.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear_rounded, size: 18),
                                        onPressed: () => _catalogSearchController.clear(),
                                      )
                                    : null,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                isDense: true,
                              ),
                            ),
                          ),
                          Expanded(
                            child: filtered.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'No matching items found',
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                          const SizedBox(height: 8),
                                          TextButton(
                                            onPressed: () => _catalogSearchController.clear(),
                                            child: const Text('Clear search'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: filtered.length,
                                    separatorBuilder: (_, __) => const Divider(height: 1),
                                    itemBuilder: (ctx, idx) {
                                      final item = filtered[idx];
                                      return ListTile(
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                        title: Text(item.name, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                                        subtitle: Text(
                                          '${CurrencyFormatter.format(item.defaultPrice)} / ${item.defaultUnit}'
                                          '${item.hsnSacCode != null ? " • HSN: ${item.hsnSacCode}" : ""}',
                                          style: theme.textTheme.bodySmall,
                                        ),
                                        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                                        onTap: () => _populateFromCatalog(item),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ] else ...[
                // Edit / Form Mode
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Item Details',
                                  style: theme.textTheme.titleSmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                    onPressed: () => setState(() => _showCatalogPicker = true),
                                    icon: const Icon(Icons.search_rounded, size: 16),
                                    label: const Text('Pick from Catalog'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          AppTextField(
                            label: 'Item / Service Name',
                            controller: _nameController,
                            isRequired: true,
                            hint: 'e.g. Aqua Queen',
                            validator: (v) => v == null || v.trim().isEmpty ? 'Item name required' : null,
                          ),
                          const FieldGap(),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: AppTextField(
                                  label: 'HSN / SAC Code',
                                  controller: _hsnController,
                                  hint: '84818090',
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 1,
                                child: AppTextField(
                                  label: 'Unit',
                                  controller: _unitController,
                                  isRequired: true,
                                  hint: 'Pcs',
                                ),
                              ),
                            ],
                          ),
                          const FieldGap(),
                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  label: 'Quantity',
                                  controller: _qtyController,
                                  isRequired: true,
                                  hint: '1',
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  onChanged: (_) => setState(() {}),
                                  validator: (v) {
                                    final str = (v ?? '').trim();
                                    if (str.isEmpty) return null;
                                    final val = double.tryParse(str);
                                    if (val == null || val <= 0) return 'Must be > 0';
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: AppTextField(
                                  label: 'Price per Unit (₹)',
                                  controller: _priceController,
                                  isRequired: true,
                                  hint: '0.00',
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  onChanged: (_) => setState(() {}),
                                  validator: (v) {
                                    final str = (v ?? '').trim();
                                    if (str.isEmpty) return null;
                                    final val = double.tryParse(str);
                                    if (val == null || val < 0) return 'Invalid price';
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const FieldGap(),

                          // ── Discount Toggle (% vs ₹) ──────────────────────
                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  label: 'Discount (${_isPercentDiscount ? "%" : "₹"})',
                                  controller: _discountController,
                                  hint: '0',
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: SegmentedButton<bool>(
                                  segments: const [
                                    ButtonSegment(value: true, label: Text('%')),
                                    ButtonSegment(value: false, label: Text('₹')),
                                  ],
                                  selected: {_isPercentDiscount},
                                  onSelectionChanged: (val) {
                                    setState(() {
                                      _isPercentDiscount = val.first;
                                      _discountController.text = '';
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const FieldGap(),

                          // ── Tax % ─────────────────────────────────────────
                          AppTextField(
                            label: 'Tax % (GST)',
                            controller: _taxController,
                            hint: '0',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 16),

                          // ── Live Calculation Card ─────────────────────────
                          Builder(builder: (context) {
                            final data = _buildLineData();
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: cs.primaryContainer.withAlpha(80),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: cs.primary.withAlpha(60)),
                              ),
                              child: Column(
                                children: [
                                  _CalcRow(
                                    label: 'Subtotal (${data.quantity} × ${CurrencyFormatter.format(data.pricePerUnit)})',
                                    value: CurrencyFormatter.format(data.subtotal),
                                  ),
                                  if (data.calculatedDiscountAmount > 0)
                                    _CalcRow(
                                      label: 'Discount (${data.calculatedDiscountPercent.toStringAsFixed(3)}%)',
                                      value: '- ${CurrencyFormatter.format(data.calculatedDiscountAmount)}',
                                      color: Colors.green.shade700,
                                    ),
                                  _CalcRow(
                                    label: 'Taxable Amount',
                                    value: CurrencyFormatter.format(data.taxableAmount),
                                  ),
                                  if (data.taxAmount > 0)
                                    _CalcRow(
                                      label: 'Tax (${data.taxPercent}%)',
                                      value: '+ ${CurrencyFormatter.format(data.taxAmount)}',
                                    ),
                                  const Divider(height: 12),
                                  _CalcRow(
                                    label: 'Line Total',
                                    value: CurrencyFormatter.format(data.lineTotal),
                                    isBold: true,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pop(_buildLineData());
                      }
                    },
                    child: Text(
                      widget.initialLine == null ? 'Add Line Item' : 'Update Line Item',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CalcRow extends StatelessWidget {
  const _CalcRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.color,
  });

  final String label;
  final String value;
  final bool isBold;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
