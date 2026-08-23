// Supplier Add/Edit Form Screen
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../db/app_database.dart';
import '../../providers/suppliers_provider.dart';
import '../../services/database_provider.dart';
import '../../widgets/app_text_field.dart';

class SupplierFormScreen extends ConsumerStatefulWidget {
  final Supplier? supplier;

  const SupplierFormScreen({super.key, this.supplier});

  @override
  ConsumerState<SupplierFormScreen> createState() => _SupplierFormScreenState();
}

class _SupplierFormScreenState extends ConsumerState<SupplierFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _gstController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.supplier != null) {
      _nameController.text = widget.supplier!.name;
      _phoneController.text = widget.supplier!.phone;
      _addressController.text = widget.supplier!.address ?? '';
      _gstController.text = widget.supplier!.gstNumber ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _gstController.dispose();
    super.dispose();
  }

  Future<void> _saveSupplier() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      final companion = SuppliersCompanion(
        id: widget.supplier != null
            ? drift.Value(widget.supplier!.id)
            : const drift.Value.absent(),
        name: drift.Value(_nameController.text.trim()),
        phone: drift.Value(_phoneController.text.trim()),
        address: drift.Value(_addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim()),
        gstNumber: drift.Value(_gstController.text.trim().isEmpty
            ? null
            : _gstController.text.trim()),
      );

      if (widget.supplier != null) {
        await ref.read(suppliersDaoProvider).updateSupplier(companion);
      } else {
        await ref.read(suppliersDaoProvider).insertSupplier(companion);
      }

      ref.invalidate(suppliersStreamProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.supplier != null
                ? 'Supplier updated'
                : 'Supplier created successfully'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving supplier: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.supplier != null ? 'Edit Supplier' : 'Add Supplier'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: 'Supplier Name *',
                controller: _nameController,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Phone Number *',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'GSTIN / Tax ID (Optional)',
                controller: _gstController,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Address (Optional)',
                controller: _addressController,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveSupplier,
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
                    : Text(
                        widget.supplier != null
                            ? 'UPDATE SUPPLIER'
                            : 'SAVE SUPPLIER',
                        style: const TextStyle(
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
