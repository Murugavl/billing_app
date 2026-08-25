// Estimate Form Screen — Create or edit an estimate/quotation document
import 'dart:io';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../db/app_database.dart';
import '../../db/daos/documents_dao.dart';
import '../../providers/business_profile_provider.dart';
import '../../services/database_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';
import '../../utils/number_to_words.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/customer_picker_sheet.dart';
import '../../widgets/line_item_dialog.dart';
import '../../widgets/section_card.dart';
import '../invoices/invoice_form_screen.dart';
import '../pdf/pdf_preview_screen.dart';

class EstimateFormScreen extends ConsumerStatefulWidget {
  const EstimateFormScreen({super.key, this.documentWithLines});

  /// Null for creating a new estimate, non-null for editing.
  final DocumentWithLines? documentWithLines;

  @override
  ConsumerState<EstimateFormScreen> createState() => _EstimateFormScreenState();
}

class _EstimateFormScreenState extends ConsumerState<EstimateFormScreen> {
  final _formKey = GlobalKey<FormState>();

  Customer? _selectedCustomer;
  late String _documentNumber;
  late DateTime _date;
  late final TextEditingController _placeOfSupplyController;
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

      _documentNumber = doc.documentNumber;
      _date = doc.date;
      _placeOfSupplyController = TextEditingController(text: doc.placeOfSupply ?? 'Tamil Nadu');
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
      _documentNumber = await docsDao.nextDocumentNumber('estimate');
      _date = DateTime.now();
      _placeOfSupplyController = TextEditingController(text: 'Tamil Nadu');
      _notesController = TextEditingController();
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _placeOfSupplyController.dispose();
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

  Future<void> _convertToInvoice() async {
    if (_selectedCustomer == null || _lines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a customer and add line items before converting')),
      );
      return;
    }

    final docsDao = ref.read(documentsDaoProvider);
    final nextInvNum = await docsDao.nextDocumentNumber('invoice');

    // Convert line items to DocumentLineItems
    final lineItems = _lines.map((l) {
      return DocumentLineItem(
        id: 0,
        documentId: 0,
        itemId: l.itemId,
        itemName: l.itemName,
        hsnSacCode: l.hsnSacCode,
        quantity: l.quantity,
        unit: l.unit,
        pricePerUnit: l.pricePerUnit,
        discountPercent: l.calculatedDiscountPercent,
        discountAmount: l.calculatedDiscountAmount,
        taxableAmount: l.taxableAmount,
        taxPercent: l.taxPercent,
        taxAmount: l.taxAmount,
        lineTotal: l.lineTotal,
        sortOrder: 0,
      );
    }).toList();

    final draftDoc = Document(
      id: 0,
      documentNumber: nextInvNum, // auto-generated next INV-xxxx
      type: 'invoice',
      customerId: _selectedCustomer!.id,
      customerName: _selectedCustomer!.name,
      customerPhone: _selectedCustomer!.phone,
      customerAddress: _selectedCustomer!.address,
      customerGstNumber: _selectedCustomer!.gstNumber,
      date: DateTime.now(),
      placeOfSupply: _placeOfSupplyController.text.trim(),
      subtotal: _subtotal,
      totalDiscount: _totalDiscount,
      totalTax: _totalTax,
      grandTotal: _grandTotal,
      amountReceived: 0.0,
      balanceDue: _grandTotal,
      amountInWords: _amountInWords,
      status: 'draft',
      notes: _notesController.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // If existing estimate, mark status as accepted in DB
    if (_isEditing) {
      final docsDao = ref.read(documentsDaoProvider);
      await docsDao.updateStatus(widget.documentWithLines!.document.id, 'accepted');
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Converting Estimate to Invoice...'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Open Invoice Form pre-filled!
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => InvoiceFormScreen(
            documentWithLines: DocumentWithLines(
              document: draftDoc,
              lineItems: lineItems,
            ),
          ),
        ),
      );
    }
  }

  Future<void> _saveEstimate(String status) async {
    if (_selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a customer for this estimate')),
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
        type: const Value('estimate'),
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Estimate updated' : 'Estimate saved successfully'),
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
            content: Text('Error saving estimate: $e'),
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
        appBar: AppBar(title: const Text('New Estimate')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Estimate' : 'Create Quotation / Estimate'),
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
          IconButton(
            icon: const Icon(Icons.transform_rounded),
            tooltip: 'Convert to Invoice',
            onPressed: _convertToInvoice,
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
              // ── Convert to Invoice Banner (if creating or editing) ───────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.amberDark.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.amberDark.withAlpha(80)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.request_quote_rounded, color: AppColors.amberDark, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Quotation / Estimate mode',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.amberDark,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: _convertToInvoice,
                      icon: const Icon(Icons.transform_rounded, size: 14),
                      label: const Text('Convert to Invoice', style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Business Header & Estimate Number Banner ────────────────────
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
                                profile?.businessName ?? 'My Business',
                                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              if (profile?.gstNumber != null)
                                Text('GSTIN: ${profile!.gstNumber}', style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.amberDark.withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.amberDark.withAlpha(80)),
                          ),
                          child: Text(
                            _documentNumber,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppColors.amberDark,
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

              // ── Estimate For Customer Section ─────────────────────────────
              SectionCard(
                title: 'ESTIMATE FOR (CUSTOMER)',
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
                            const Icon(Icons.person_search_rounded, color: AppColors.amberDark),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Tap to select customer for estimate',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  color: AppColors.amberDark,
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
                                'Estimate Date',
                                style: GoogleFonts.inter(fontSize: 11, color: cs.onSurface.withAlpha(140)),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                  children: [
                                    const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.amberDark),
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

              // ── Line Items & Taxable Amounts Section ───────────────────────
              SectionCard(
                title: 'LINE ITEMS & TAXABLE AMOUNTS',
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
                            const Icon(Icons.add_shopping_cart_rounded, color: AppColors.amberDark, size: 32),
                            const SizedBox(height: 8),
                            Text(
                              'No line items added yet',
                              style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.amberDark),
                            ),
                            Text(
                              'Tap to add quotation items with taxable amounts',
                              style: theme.textTheme.bodySmall,
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
                                      Text(
                                        line.itemName,
                                        style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                      if (line.hsnSacCode != null) ...[
                                        const SizedBox(width: 6),
                                        Text('(${line.hsnSacCode})', style: theme.textTheme.bodySmall),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${line.quantity} ${line.unit} × ${CurrencyFormatter.format(line.pricePerUnit)}',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  Text(
                                    'Taxable Amount: ${CurrencyFormatter.format(line.taxableAmount)}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: cs.primary,
                                    ),
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

              // ── Summary Block ─────────────────────────────────────────────
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
                      _SummaryRow(label: 'Total Taxable Amount', value: CurrencyFormatter.format(_taxableAmount)),
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
                        label: 'Estimated Grand Total',
                        value: CurrencyFormatter.format(_grandTotal),
                        isBold: true,
                        fontSize: 18,
                      ),
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
                  color: AppColors.amberDark.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.amberDark.withAlpha(50)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount in Words',
                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.amberDark),
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

              // ── Bank Details Block (for advance transfers) ─────────────────
              profileAsync.when(
                data: (profile) {
                  if (profile == null || profile.bankName == null) return const SizedBox.shrink();
                  return SectionCard(
                    title: 'BANK DETAILS FOR ADVANCE TRANSFER',
                    icon: Icons.account_balance_rounded,
                    children: [
                      _BankDetailRow(label: 'Bank Name', value: profile.bankName ?? 'N/A'),
                      if (profile.bankAccountNo != null)
                        _BankDetailRow(label: 'Account No', value: profile.bankAccountNo!),
                      if (profile.bankIfsc != null)
                        _BankDetailRow(label: 'IFSC Code', value: profile.bankIfsc!),
                      if (profile.bankBranchAddress != null)
                        _BankDetailRow(label: 'Branch Address', value: profile.bankBranchAddress!),
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

              const SizedBox(height: 16),

              // ── Notes ─────────────────────────────────────────────────────
              AppTextField(
                label: 'Notes / Validity Terms',
                controller: _notesController,
                hint: 'e.g. Estimate valid for 30 days. Advance payment required.',
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
                        onPressed: _isSaving ? null : () => _saveEstimate('draft'),
                        child: const Text('Save Draft'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.amberDark,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _isSaving ? null : () => _saveEstimate('sent'),
                        icon: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.send_rounded, size: 18),
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(_isEditing ? 'Update Estimate' : 'Save & Send'),
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

class _BankDetailRow extends StatelessWidget {
  const _BankDetailRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: cs.onSurface.withAlpha(140)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: cs.onSurface),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
