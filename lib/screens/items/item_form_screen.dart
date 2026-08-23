// Form screen for adding/editing an item/service catalog entry
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../db/app_database.dart';
import '../../services/database_provider.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/section_card.dart';

class ItemFormScreen extends ConsumerStatefulWidget {
  const ItemFormScreen({super.key, this.item});

  /// Null for creating a new item, non-null for editing.
  final Item? item;

  @override
  ConsumerState<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends ConsumerState<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _hsnController;
  late final TextEditingController _customUnitController;
  late final TextEditingController _priceController;
  late final TextEditingController _taxController;

  static const List<String> _standardUnits = ['Pcs', 'Nos', 'Kg', 'Ltr', 'Hrs', 'Box', 'Set', 'Custom'];
  static const List<double> _standardTaxes = [0.0, 5.0, 12.0, 18.0, 28.0];

  late String _selectedUnit;
  bool _isCustomUnit = false;
  double? _selectedTax;
  bool _isCustomTax = false;
  bool _isSaving = false;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _nameController = TextEditingController(text: item?.name ?? '');
    _hsnController = TextEditingController(text: item?.hsnSacCode ?? '');
    _priceController = TextEditingController(
      text: item != null ? item.defaultPrice.toStringAsFixed(2) : '',
    );

    final currentUnit = item?.defaultUnit ?? 'Pcs';
    if (_standardUnits.contains(currentUnit) && currentUnit != 'Custom') {
      _selectedUnit = currentUnit;
      _customUnitController = TextEditingController();
      _isCustomUnit = false;
    } else {
      _selectedUnit = 'Custom';
      _customUnitController = TextEditingController(text: currentUnit);
      _isCustomUnit = true;
    }

    final currentTax = item?.defaultTaxPercent;
    _taxController = TextEditingController(
      text: currentTax != null ? currentTax.toStringAsFixed(1) : '',
    );

    if (currentTax != null && _standardTaxes.contains(currentTax)) {
      _selectedTax = currentTax;
      _isCustomTax = false;
    } else if (currentTax != null) {
      _selectedTax = -1; // custom code
      _isCustomTax = true;
    } else {
      _selectedTax = null;
      _isCustomTax = false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hsnController.dispose();
    _customUnitController.dispose();
    _priceController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final unit = _isCustomUnit ? _customUnitController.text.trim() : _selectedUnit;
    if (_isCustomUnit && unit.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a custom unit name')),
      );
      return;
    }

    final price = double.tryParse(_priceController.text.trim());
    if (price == null || price < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price')),
      );
      return;
    }

    double? tax;
    if (_isCustomTax) {
      tax = double.tryParse(_taxController.text.trim());
    } else {
      tax = _selectedTax;
    }

    setState(() => _isSaving = true);
    try {
      final dao = ref.read(itemsDaoProvider);
      final name = _nameController.text.trim();
      final hsn = _hsnController.text.trim().isEmpty ? null : _hsnController.text.trim();

      if (_isEditing) {
        final companion = widget.item!.toCompanion(true).copyWith(
              name: Value(name),
              hsnSacCode: Value(hsn),
              defaultUnit: Value(unit),
              defaultPrice: Value(price),
              defaultTaxPercent: Value(tax),
            );
        await dao.updateItem(companion);
      } else {
        final companion = ItemsCompanion(
          name: Value(name),
          hsnSacCode: Value(hsn),
          defaultUnit: Value(unit),
          defaultPrice: Value(price),
          defaultTaxPercent: Value(tax),
          createdAt: Value(DateTime.now()),
        );
        await dao.insertItem(companion);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Item updated successfully' : 'Item added successfully'),
            backgroundColor: const Color(0xFF38A169),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(12),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving item: $e'),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Item / Service' : 'Add New Item / Service'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: _isSaving ? null : _save,
              child: Text(
                'Save',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SectionCard(
                title: 'ITEM DETAILS',
                icon: Icons.inventory_2_rounded,
                children: [
                  AppTextField(
                    label: 'Item or Service Name',
                    controller: _nameController,
                    hint: 'e.g. Aqua Queen, Water Pump Service',
                    isRequired: true,
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => Validators.required(v, label: 'Item name'),
                  ),
                  const FieldGap(),
                  AppTextField(
                    label: 'HSN / SAC Code',
                    controller: _hsnController,
                    hint: 'e.g. 84818090 (Goods HSN / Service SAC)',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    helperText: 'Used for GST e-invoicing and tax reports',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SectionCard(
                title: 'PRICING & UNIT',
                icon: Icons.sell_rounded,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Default Selling Price (₹)',
                          controller: _priceController,
                          hint: '0.00',
                          isRequired: true,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          validator: (v) => Validators.required(v, label: 'Price'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Unit',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: cs.onSurface.withAlpha(200),
                                  ),
                                ),
                                Text(' *', style: TextStyle(color: cs.error, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedUnit,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                              items: _standardUnits.map((u) {
                                return DropdownMenuItem(value: u, child: Text(u));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _selectedUnit = val;
                                    _isCustomUnit = val == 'Custom';
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_isCustomUnit) ...[
                    const FieldGap(),
                    AppTextField(
                      label: 'Custom Unit Name',
                      controller: _customUnitController,
                      hint: 'e.g. Meter, Container, Shift',
                      isRequired: true,
                    ),
                  ],
                  const FieldGap(),

                  // ── GST Tax dropdown ─────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Default Tax % (GST)',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: cs.onSurface.withAlpha(200),
                              ),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<double?>(
                              initialValue: _isCustomTax ? -1 : _selectedTax,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                              items: [
                                const DropdownMenuItem<double?>(
                                  value: null,
                                  child: Text('None (0%)'),
                                ),
                                ..._standardTaxes.map(
                                  (t) => DropdownMenuItem<double?>(
                                    value: t,
                                    child: Text('$t% GST'),
                                  ),
                                ),
                                const DropdownMenuItem<double?>(
                                  value: -1,
                                  child: Text('Custom %'),
                                ),
                              ],
                              onChanged: (val) {
                                setState(() {
                                  if (val == -1) {
                                    _isCustomTax = true;
                                    _selectedTax = -1;
                                  } else {
                                    _isCustomTax = false;
                                    _selectedTax = val;
                                    _taxController.text = val != null ? val.toStringAsFixed(1) : '';
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      if (_isCustomTax) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppTextField(
                            label: 'Custom Tax %',
                            controller: _taxController,
                            hint: 'e.g. 18.0',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _save,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.check_circle_rounded),
                  label: Text(
                    _isEditing ? 'Update Item' : 'Save Item',
                    style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
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
