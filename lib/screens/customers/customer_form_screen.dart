// Form screen for adding/editing a customer
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

class CustomerFormScreen extends ConsumerStatefulWidget {
  const CustomerFormScreen({super.key, this.customer});

  /// Null for creating a new customer, non-null for editing.
  final Customer? customer;

  @override
  ConsumerState<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends ConsumerState<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _emailController;
  late final TextEditingController _gstController;

  bool _isSaving = false;

  bool get _isEditing => widget.customer != null;

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    _nameController = TextEditingController(text: c?.name ?? '');
    _phoneController = TextEditingController(text: c?.phone ?? '');
    _addressController = TextEditingController(text: c?.address ?? '');
    _emailController = TextEditingController(text: c?.email ?? '');
    _gstController = TextEditingController(text: c?.gstNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _gstController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final dao = ref.read(customersDaoProvider);
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      final address = _addressController.text.trim();
      final email = _emailController.text.trim().isEmpty ? null : _emailController.text.trim();
      final gst = _gstController.text.trim().isEmpty ? null : _gstController.text.trim().toUpperCase();

      if (_isEditing) {
        final companion = widget.customer!.toCompanion(true).copyWith(
              name: Value(name),
              phone: Value(phone),
              address: Value(address),
              email: Value(email),
              gstNumber: Value(gst),
            );
        await dao.updateCustomer(companion);
      } else {
        final companion = CustomersCompanion(
          name: Value(name),
          phone: Value(phone),
          address: Value(address),
          email: Value(email),
          gstNumber: Value(gst),
          createdAt: Value(DateTime.now()),
        );
        await dao.insertCustomer(companion);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Customer updated successfully' : 'Customer added successfully'),
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
            content: Text('Error saving customer: $e'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Customer' : 'Add New Customer'),
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
                title: 'CUSTOMER INFORMATION',
                icon: Icons.person_rounded,
                children: [
                  AppTextField(
                    label: 'Customer / Business Name',
                    controller: _nameController,
                    hint: 'e.g. Aqua Solutions Pvt Ltd',
                    isRequired: true,
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => Validators.required(v, label: 'Customer name'),
                  ),
                  const FieldGap(),
                  AppTextField(
                    label: 'Phone Number',
                    controller: _phoneController,
                    hint: '10-digit mobile number',
                    isRequired: true,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) => Validators.phone(v),
                  ),
                  const FieldGap(),
                  AppTextField(
                    label: 'Billing Address',
                    controller: _addressController,
                    hint: 'Full street address, city, state & pincode',
                    isRequired: true,
                    maxLines: 3,
                    minLines: 2,
                    validator: (v) => Validators.required(v, label: 'Billing address'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SectionCard(
                title: 'ADDITIONAL DETAILS',
                icon: Icons.badge_rounded,
                trailing: const OptionalBadge(),
                children: [
                  AppTextField(
                    label: 'Email Address',
                    controller: _emailController,
                    hint: 'customer@example.com',
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    validator: Validators.email,
                  ),
                  const FieldGap(),
                  AppTextField(
                    label: 'GST Number (GSTIN)',
                    controller: _gstController,
                    hint: 'e.g. 33AAQCS1234B1Z9',
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                      LengthLimitingTextInputFormatter(15),
                    ],
                    validator: Validators.gst,
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
                    _isEditing ? 'Update Customer' : 'Save Customer',
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
