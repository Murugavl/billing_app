// Invoice Form Screen — Create or edit an invoice document
import 'dart:io';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../db/app_database.dart';
import '../../db/daos/documents_dao.dart';
import '../../providers/business_profile_provider.dart';
import '../../providers/invoices_provider.dart';
import '../../services/database_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';
import '../../utils/number_to_words.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/customer_picker_sheet.dart';
import '../../widgets/line_item_dialog.dart';
import '../../widgets/section_card.dart';
import '../pdf/pdf_preview_screen.dart';

class InvoiceFormScreen extends ConsumerStatefulWidget {
  const InvoiceFormScreen({super.key, this.documentWithLines});

  /// Null for creating a new invoice, non-null for editing.
  final DocumentWithLines? documentWithLines;

  @override
  ConsumerState<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends ConsumerState<InvoiceFormScreen> {
  final _formKey = GlobalKey<FormState>();

  Customer? _selectedCustomer;
  late String _documentNumber;
  late DateTime _date;
  late final TextEditingController _placeOfSupplyController;
  late final TextEditingController _amountReceivedController;
  late final TextEditingController _notesController;

  final List<LineItemData> _lines = [];
  bool _isLoading = true;
  bool _isSaving = false;

  bool get _isEditing => widget.documentWithLines != null && widget.documentWithLines!.document.id > 0;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final docsDao = ref.read(documentsDaoProvider);
    final custDao = ref.read(customersDaoProvider);

    if (widget.documentWithLines != null) {
      final doc = widget.documentWithLines!.document;
      final lines = widget.documentWithLines!.lineItems;

      if (doc.documentNumber.trim().isEmpty) {
        _documentNumber = await docsDao.nextDocumentNumber('invoice');
      } else {
        _documentNumber = doc.documentNumber;
      }
      _date = doc.date;
      _placeOfSupplyController = TextEditingController(text: doc.placeOfSupply ?? 'Tamil Nadu');
      _amountReceivedController = TextEditingController(
        text: (doc.amountReceived != null && doc.amountReceived! > 0)
            ? doc.amountReceived!.toStringAsFixed(2)
            : '',
      );
      _notesController = TextEditingController(text: doc.notes ?? '');

      if (doc.customerId != null) {
        _selectedCustomer = await custDao.getCustomerById(doc.customerId!);
      }

      for (final item in lines) {
        _lines.add(
          LineItemData(
            itemId: item.itemId,
            itemName: item.itemName,
            hsnSacCode: item.hsnSacCode,
            quantity: item.quantity,
            unit: item.unit,
            pricePerUnit: item.pricePerUnit,
            isPercentDiscount: item.discountPercent > 0 || item.discountAmount == 0,
            discountPercent: item.discountPercent,
            discountAmount: item.discountAmount,
            taxPercent: item.taxPercent,
          ),
        );
      }
    } else {
      _documentNumber = await docsDao.nextDocumentNumber('invoice');
      _date = DateTime.now();
      _placeOfSupplyController = TextEditingController(text: 'Tamil Nadu');
      _amountReceivedController = TextEditingController(text: '');
      _notesController = TextEditingController();
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _placeOfSupplyController.dispose();
    _amountReceivedController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // ── Calculation helpers ───────────────────────────────────────────────────

  double get _subtotal {
    double sum = 0.0;
    for (final l in _lines) {
      sum += l.subtotal;
    }
    return double.parse(sum.toStringAsFixed(2));
  }

  double get _totalDiscount {
    double sum = 0.0;
    for (final l in _lines) {
      sum += l.calculatedDiscountAmount;
    }
    return double.parse(sum.toStringAsFixed(2));
  }

  double get _taxableAmount {
    double sum = 0.0;
    for (final l in _lines) {
      sum += l.taxableAmount;
    }
    return double.parse(sum.toStringAsFixed(2));
  }

  double get _totalTax {
    double sum = 0.0;
    for (final l in _lines) {
      sum += l.taxAmount;
    }
    return double.parse(sum.toStringAsFixed(2));
  }

  double get _grandTotal {
    return double.parse((_taxableAmount + _totalTax).toStringAsFixed(2));
  }

  double get _amountReceived {
    return double.tryParse(_amountReceivedController.text.trim()) ?? 0.0;
  }

  double get _balanceDue {
    final due = _grandTotal - _amountReceived;
    return due < 0 ? 0.0 : double.parse(due.toStringAsFixed(2));
  }

  String get _amountInWords => NumberToWords.convert(_grandTotal);

  // ── Handlers ──────────────────────────────────────────────────────────────

  Future<void> _pickCustomer() async {
    final selected = await showModalBottomSheet<Customer>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const CustomerPickerSheet(),
    );
    if (selected != null) {
      setState(() => _selectedCustomer = selected);
    }
  }

  Future<void> _addLineItem() async {
    final result = await showDialog<LineItemData>(
      context: context,
      builder: (_) => const LineItemDialog(),
    );
    if (result != null) {
      setState(() => _lines.add(result));
    }
  }

  Future<void> _editLineItem(int index) async {
    final result = await showDialog<LineItemData>(
      context: context,
      builder: (_) => LineItemDialog(initialLine: _lines[index]),
    );
    if (result != null) {
      setState(() => _lines[index] = result);
    }
  }

  void _removeLineItem(int index) {
    setState(() => _lines.removeAt(index));
  }

  Future<void> _saveInvoice(String status) async {
    if (_selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a customer for this invoice')),
      );
      return;
    }

    if (_lines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one line item')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final docsDao = ref.read(documentsDaoProvider);

      final docCompanion = DocumentsCompanion(
        id: _isEditing ? Value(widget.documentWithLines!.document.id) : const Value.absent(),
        documentNumber: Value(_documentNumber),
        type: const Value('invoice'),
        customerId: Value(_selectedCustomer!.id),
        customerName: Value(_selectedCustomer!.name),
        customerPhone: Value(_selectedCustomer!.phone),
        customerAddress: Value(_selectedCustomer!.address),
        customerGstNumber: Value(_selectedCustomer!.gstNumber),
        date: Value(_date),
        placeOfSupply: Value(_placeOfSupplyController.text.trim()),
        subtotal: Value(_subtotal),
        totalDiscount: Value(_totalDiscount),
        totalTax: Value(_totalTax),
        grandTotal: Value(_grandTotal),
        amountReceived: Value(_amountReceived),
        balanceDue: Value(_balanceDue),
        amountInWords: Value(_amountInWords),
        status: Value(status),
        notes: Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
        createdAt: _isEditing ? Value(widget.documentWithLines!.document.createdAt) : Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      );

      final linesCompanions = _lines.map((l) {
        return DocumentLineItemsCompanion(
          itemId: Value(l.itemId),
          itemName: Value(l.itemName),
          hsnSacCode: Value(l.hsnSacCode),
          quantity: Value(l.quantity),
          unit: Value(l.unit),
          pricePerUnit: Value(l.pricePerUnit),
          discountPercent: Value(l.calculatedDiscountPercent),
          discountAmount: Value(l.calculatedDiscountAmount),
          taxableAmount: Value(l.taxableAmount),
          taxPercent: Value(l.taxPercent),
          taxAmount: Value(l.taxAmount),
          lineTotal: Value(l.lineTotal),
        );
      }).toList();

      if (_isEditing) {
        await docsDao.updateDocumentWithLines(
          doc: docCompanion,
          lines: linesCompanions,
        );
      } else {
        await docsDao.insertDocumentWithLines(
          doc: docCompanion,
          lines: linesCompanions,
        );
      }

      ref.invalidate(invoicesStreamProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Invoice updated' : 'Invoice saved successfully'),
            backgroundColor: const Color(0xFF38A169),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving invoice: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final profileAsync = ref.watch(businessProfileProvider);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('New Invoice')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Invoice' : 'Create Tax Invoice'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf_rounded),
              tooltip: 'Preview / Share PDF',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PdfPreviewScreen(
                      documentId: widget.documentWithLines!.document.id,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Business Header & Invoice Number Banner ────────────────────
              profileAsync.when(
                data: (profile) => Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: cs.outline.withAlpha(80)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        if (profile?.logoPath != null && File(profile!.logoPath!).existsSync()) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(profile.logoPath!),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile?.businessName ?? 'Ponsri Enterprises',
                                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (profile?.gstNumber != null)
                                Text(
                                  'GSTIN: ${profile!.gstNumber}',
                                  style: theme.textTheme.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _documentNumber,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: cs.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

              const SizedBox(height: 16),

              // ── Bill To Customer Section ──────────────────────────────────
              SectionCard(
                title: 'BILL TO (CUSTOMER)',
                icon: Icons.person_rounded,
                trailing: TextButton.icon(
                  onPressed: _pickCustomer,
                  icon: Icon(
                    _selectedCustomer == null ? Icons.person_add_rounded : Icons.swap_horiz_rounded,
                    size: 16,
                  ),
                  label: Text(_selectedCustomer == null ? 'Select Customer' : 'Change'),
                ),
                children: [
                  if (_selectedCustomer == null)
                    InkWell(
                      onTap: _pickCustomer,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: cs.outline.withAlpha(100)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_search_rounded, color: cs.primary),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Tap to select or quick-add customer',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedCustomer!.name,
                          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        if (_selectedCustomer!.phone != null)
                          Text(
                            'Phone: ${_selectedCustomer!.phone}',
                            style: theme.textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (_selectedCustomer!.address != null)
                          Text(
                            'Address: ${_selectedCustomer!.address}',
                            style: theme.textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (_selectedCustomer!.gstNumber != null) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: cs.primaryContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'GSTIN: ${_selectedCustomer!.gstNumber}',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: cs.primary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Date & Place of Supply Row ────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: cs.outline.withAlpha(80)),
                      ),
                      child: InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _date,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setState(() => _date = picked);
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Invoice Date',
                                style: GoogleFonts.inter(fontSize: 11, color: cs.onSurface.withAlpha(140)),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today_rounded, size: 16, color: cs.primary),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        DateFormatter.display(_date),
                                        style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      label: 'Place of Supply',
                      controller: _placeOfSupplyController,
                      hint: 'e.g. Tamil Nadu',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Line Items Section ────────────────────────────────────────
              SectionCard(
                title: 'LINE ITEMS',
                icon: Icons.table_chart_rounded,
                trailing: TextButton.icon(
                  onPressed: _addLineItem,
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 16),
                  label: const Text('Add Item'),
                ),
                children: [
                  if (_lines.isEmpty)
                    InkWell(
                      onTap: _addLineItem,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: cs.outline.withAlpha(80)),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.add_shopping_cart_rounded, color: cs.primary, size: 32),
                            const SizedBox(height: 8),
                            Text(
                              'No line items added yet',
                              style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: cs.primary),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Tap to select items from catalog or add custom entries',
                                style: theme.textTheme.bodySmall,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _lines.length,
                      separatorBuilder: (_, __) => const Divider(height: 16),
                      itemBuilder: (ctx, idx) {
                        final line = _lines[idx];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          line.itemName,
                                          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (line.hsnSacCode != null) ...[
                                        const SizedBox(width: 6),
                                        Text('(${line.hsnSacCode})', style: theme.textTheme.bodySmall),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${line.quantity} ${line.unit} × ${CurrencyFormatter.format(line.pricePerUnit)}'
                                    '${line.calculatedDiscountAmount > 0 ? " • Disc: -${CurrencyFormatter.format(line.calculatedDiscountAmount)}" : ""}',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  CurrencyFormatter.format(line.lineTotal),
                                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, size: 16),
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () => _editLineItem(idx),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete_outline, size: 16, color: cs.error),
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () => _removeLineItem(idx),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Totals & Summary Block ─────────────────────────────────────
              Card(
                elevation: 0,
                color: cs.surfaceContainerHighest.withAlpha(120),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: cs.outline.withAlpha(80)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _SummaryRow(label: 'Subtotal', value: CurrencyFormatter.format(_subtotal)),
                      if (_totalDiscount > 0)
                        _SummaryRow(
                          label: 'Total Discount',
                          value: '- ${CurrencyFormatter.format(_totalDiscount)}',
                          color: Colors.green.shade700,
                        ),
                      if (_totalTax > 0)
                        _SummaryRow(label: 'Total Tax (GST)', value: '+ ${CurrencyFormatter.format(_totalTax)}'),
                      const Divider(height: 20),
                      _SummaryRow(
                        label: 'Grand Total',
                        value: CurrencyFormatter.format(_grandTotal),
                        isBold: true,
                        fontSize: 18,
                      ),
                      if (_totalDiscount > 0) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.green.shade300),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.stars_rounded, size: 14, color: Colors.green.shade700),
                              const SizedBox(width: 4),
                              Text(
                                'You Saved ${CurrencyFormatter.format(_totalDiscount)} on this invoice',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Amount in Words ───────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.primaryContainer.withAlpha(60),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: cs.primary.withAlpha(40)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount in Words',
                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: cs.primary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _amountInWords,
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Payment Section ────────────────────────────────────────────
              SectionCard(
                title: 'PAYMENT DETAILS',
                icon: Icons.payments_rounded,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Amount Received (₹)',
                          controller: _amountReceivedController,
                          hint: '0.00',
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Balance Due',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: cs.onSurface.withAlpha(200),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                color: cs.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: cs.outline.withAlpha(80)),
                              ),
                              child: Text(
                                CurrencyFormatter.format(_balanceDue),
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: _balanceDue > 0 ? AppColors.warning : AppColors.success,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Notes ─────────────────────────────────────────────────────
              AppTextField(
                label: 'Notes / Terms & Conditions',
                controller: _notesController,
                hint: 'e.g. Payment due within 15 days.',
                maxLines: 2,
              ),

              const SizedBox(height: 32),

              // ── Bottom Save Buttons ────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: _isSaving ? null : () => _saveInvoice('draft'),
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text('Save as Draft'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _isSaving ? null : () => _saveInvoice('sent'),
                        icon: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.send_rounded, size: 18),
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(_isEditing ? 'Update & Send' : 'Save & Send'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.fontSize = 14,
    this.color,
  });

  final String label;
  final String value;
  final bool isBold;
  final double fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: fontSize,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: fontSize,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
