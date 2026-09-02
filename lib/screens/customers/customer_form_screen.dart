// Form screen for adding/editing a customer
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

import '../../db/app_database.dart';
import '../../services/contact_picker_service.dart';
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
  bool _isPickingContact = false;

  final _contactService = ContactPickerService();

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

  // ── Contact Picker ────────────────────────────────────────────────────────

  Future<void> _pickFromContacts() async {
    if (_isPickingContact) return;
    setState(() => _isPickingContact = true);

    try {
      // ① Check whether we already have permission.
      //    We peek using a lightweight platform channel call. If the
      //    permission is already granted we skip the rationale dialog and go
      //    straight to the picker.  flutter_contacts exposes
      //    requestPermission() which returns immediately (true) when already
      //    granted, but we want to avoid *silently* triggering the OS dialog,
      //    so we first show our own rationale dialog when the status is
      //    unknown / denied.
      final alreadyGranted = await _contactService.hasPermission();
      if (!mounted) return;

      if (!alreadyGranted) {
        // ② Show our rationale dialog before triggering the OS prompt.
        final proceedToRequest = await _showRationaleDialog();
        if (!mounted) return;
        if (!proceedToRequest) {
          // User dismissed rationale — do nothing; form is still usable.
          return;
        }

        // ③ Request the system permission.
        final granted = await _contactService.requestPermission();
        if (!mounted) return;

        if (!granted) {
          // ④ Permission denied — show a friendly snackbar.
          _showDeniedSnackBar();
          return;
        }
      }

      // ⑤ Open the native contact picker.
      final picked = await _contactService.pickContact();
      if (!mounted) return;

      if (picked == null) {
        // User cancelled the picker — nothing to do.
        return;
      }

      if (picked.phones.isEmpty) {
        _showSnackBar('This contact has no phone number saved.');
        return;
      }

      // ⑥ Resolve which phone number to use.
      final String? phone;
      if (picked.phones.length == 1) {
        phone = picked.phones.first;
      } else {
        // Multiple numbers — show a picker sheet.
        phone = await _showPhonePickerSheet(picked.phones);
        if (!mounted) return;
        if (phone == null) return; // user dismissed sheet
      }

      // ⑦ Auto-fill name + phone. Leave address, email, GST for manual entry.
      setState(() {
        _nameController.text = picked.name;
        _phoneController.text = phone!.replaceAll(RegExp(r'\D'), '');
      });
    } catch (e) {
      if (mounted) {
        _showSnackBar('Could not read contacts: $e');
      }
    } finally {
      if (mounted) setState(() => _isPickingContact = false);
    }
  }

  /// Shows the rationale dialog explaining why contacts access is needed.
  /// Returns `true` if the user taps "Allow", `false` otherwise.
  Future<bool> _showRationaleDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final cs = Theme.of(ctx).colorScheme;
        return AlertDialog(
          icon: Icon(Icons.contacts_rounded, color: cs.primary, size: 36),
          title: Text(
            'Allow Contacts Access',
            style: GoogleFonts.inter(fontWeight: FontWeight.w700),
          ),
          content: Text(
            'Rasidhu needs access to your contacts to quickly add a '
            "customer's name and phone number.\n\n"
            'Your contact data is never stored or shared beyond '
            'filling in this form.',
            style: GoogleFonts.inter(fontSize: 14, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Allow'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  /// Shows a bottom sheet listing multiple phone numbers for the user to pick.
  /// Returns the chosen number, or `null` if dismissed.
  Future<String?> _showPhonePickerSheet(List<String> phones) async {
    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _PhonePickerSheet(phones: phones),
    );
  }

  void _showDeniedSnackBar() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Contacts access denied — you can still type the details below.',
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        action: SnackBarAction(
          label: 'Settings',
          onPressed: () => AppSettings.openAppSettings(),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  // ── Save ─────────────────────────────────────────────────────────────────

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

  // ── Build ─────────────────────────────────────────────────────────────────

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
              // ── Pick from Contacts button (Add-only) ──────────────────
              if (!_isEditing) ...[
                _PickFromContactsButton(
                  isLoading: _isPickingContact,
                  onTap: _isPickingContact ? null : _pickFromContacts,
                ),
                const SizedBox(height: 16),
              ],

              // ── Customer Information ───────────────────────────────────
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

              // ── Additional Details ────────────────────────────────────
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

// ── Private widgets ───────────────────────────────────────────────────────────

/// Full-width "Pick from Contacts" button shown at the top of the Add form.
class _PickFromContactsButton extends StatelessWidget {
  const _PickFromContactsButton({
    required this.isLoading,
    required this.onTap,
  });

  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        side: BorderSide(color: cs.primary.withAlpha(180), width: 1.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        foregroundColor: cs.primary,
        backgroundColor: cs.primaryContainer.withAlpha(80),
      ),
      icon: isLoading
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: cs.primary,
              ),
            )
          : const Icon(Icons.contacts_rounded, size: 20),
      label: Text(
        'Pick from Contacts',
        style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }
}

/// Bottom sheet listing multiple phone numbers so the user can choose one.
class _PhonePickerSheet extends StatelessWidget {
  const _PhonePickerSheet({required this.phones});

  final List<String> phones;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              'Choose a phone number',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: phones.length,
            separatorBuilder: (_, __) => const Divider(height: 1, indent: 20),
            itemBuilder: (ctx, i) {
              final number = phones[i];
              return ListTile(
                leading: Icon(Icons.phone_rounded, color: cs.primary, size: 22),
                title: Text(
                  number,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () => Navigator.of(ctx).pop(number),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── AppSettings helper ────────────────────────────────────────────────────────
// Opens the OS app-settings page via permission_handler so a permanently-denied
// user can grant contacts access manually.
class AppSettings {
  static Future<void> openAppSettings() => ph.openAppSettings();
}
