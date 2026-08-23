// Shared BusinessProfile form — used by OnboardingScreen and SettingsScreen
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../db/app_database.dart';
import '../utils/validators.dart';
import '../utils/image_utils.dart';
import 'app_text_field.dart';
import 'app_image_picker_field.dart';
import 'section_card.dart';

/// Wraps all business profile fields. Handles form state, image picking,
/// and produces a [BusinessProfileCompanion] on submit.
class BusinessProfileForm extends StatefulWidget {
  const BusinessProfileForm({
    super.key,
    this.initialData,
    required this.onSubmit,
    this.submitLabel = 'Save',
    this.isInCard = false,
  });

  /// Pre-fills all fields when editing an existing profile.
  final BusinessProfileData? initialData;

  /// Called with the completed companion when the form is valid.
  final Future<void> Function(BusinessProfileCompanion data) onSubmit;

  final String submitLabel;

  /// If true, wraps content in a Card (used from Settings). Otherwise bare.
  final bool isInCard;

  @override
  State<BusinessProfileForm> createState() => _BusinessProfileFormState();
}

class _BusinessProfileFormState extends State<BusinessProfileForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _businessName;
  late final TextEditingController _addressLine;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _panNumber;
  late final TextEditingController _gstNumber;
  late final TextEditingController _bankName;
  late final TextEditingController _bankAccountNo;
  late final TextEditingController _bankIfsc;
  late final TextEditingController _bankBranchAddress;

  String? _logoPath;
  String? _signaturePath;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final d = widget.initialData;
    _businessName =
        TextEditingController(text: d?.businessName ?? '');
    _addressLine = TextEditingController(text: d?.addressLine ?? '');
    _phone = TextEditingController(text: d?.phone ?? '');
    _email = TextEditingController(text: d?.email ?? '');
    _panNumber = TextEditingController(text: d?.panNumber ?? '');
    _gstNumber = TextEditingController(text: d?.gstNumber ?? '');
    _bankName = TextEditingController(text: d?.bankName ?? '');
    _bankAccountNo =
        TextEditingController(text: d?.bankAccountNo ?? '');
    _bankIfsc = TextEditingController(text: d?.bankIfsc ?? '');
    _bankBranchAddress =
        TextEditingController(text: d?.bankBranchAddress ?? '');
    _logoPath = d?.logoPath;
    _signaturePath = d?.signaturePath;
  }

  @override
  void dispose() {
    _businessName.dispose();
    _addressLine.dispose();
    _phone.dispose();
    _email.dispose();
    _panNumber.dispose();
    _gstNumber.dispose();
    _bankName.dispose();
    _bankAccountNo.dispose();
    _bankIfsc.dispose();
    _bankBranchAddress.dispose();
    super.dispose();
  }

  Future<void> _handleLogoPickedRaw(String rawPath) async {
    final saved = await ImageUtils.saveLogo(rawPath);
    setState(() => _logoPath = saved);
  }

  Future<void> _handleSignaturePickedRaw(String rawPath) async {
    final saved = await ImageUtils.saveSignature(rawPath);
    setState(() => _signaturePath = saved);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Scroll to first error — handled by Form widget automatically
      return;
    }
    setState(() => _isSaving = true);
    try {
      final companion = BusinessProfileCompanion(
        businessName: Value(_businessName.text.trim()),
        addressLine: Value(
            _addressLine.text.trim().isEmpty ? null : _addressLine.text.trim()),
        phone:
            Value(_phone.text.trim().isEmpty ? null : _phone.text.trim()),
        email:
            Value(_email.text.trim().isEmpty ? null : _email.text.trim()),
        panNumber: Value(
            _panNumber.text.trim().isEmpty
                ? null
                : _panNumber.text.trim().toUpperCase()),
        gstNumber: Value(
            _gstNumber.text.trim().isEmpty
                ? null
                : _gstNumber.text.trim().toUpperCase()),
        logoPath: Value(_logoPath),
        signaturePath: Value(_signaturePath),
        bankName: Value(
            _bankName.text.trim().isEmpty ? null : _bankName.text.trim()),
        bankAccountNo: Value(
            _bankAccountNo.text.trim().isEmpty
                ? null
                : _bankAccountNo.text.trim()),
        bankIfsc: Value(
            _bankIfsc.text.trim().isEmpty
                ? null
                : _bankIfsc.text.trim().toUpperCase()),
        bankBranchAddress: Value(
            _bankBranchAddress.text.trim().isEmpty
                ? null
                : _bankBranchAddress.text.trim()),
        updatedAt: Value(DateTime.now()),
      );
      await widget.onSubmit(companion);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: $e'),
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _basicInfoSection(),
          const SizedBox(height: 16),
          _taxInfoSection(),
          const SizedBox(height: 16),
          _identitySection(),
          const SizedBox(height: 16),
          _bankDetailsSection(),
          const SizedBox(height: 28),
          _submitButton(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ── Section builders ────────────────────────────────────────────────────────

  Widget _basicInfoSection() => SectionCard(
        title: 'BUSINESS DETAILS',
        icon: Icons.business_rounded,
        children: [
          AppTextField(
            label: 'Business Name',
            controller: _businessName,
            hint: 'e.g. Ponsri Enterprises',
            isRequired: true,
            textCapitalization: TextCapitalization.words,
            validator: (v) => Validators.required(v, label: 'Business name'),
          ),
          const FieldGap(),
          AppTextField(
            label: 'Address',
            controller: _addressLine,
            hint: 'Full business address',
            isRequired: true,
            maxLines: 3,
            minLines: 2,
            validator: (v) => Validators.required(v, label: 'Address'),
          ),
          const FieldGap(),
          AppTextField(
            label: 'Phone Number',
            controller: _phone,
            hint: '9XXXXXXXXX',
            isRequired: true,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) => Validators.phone(v),
          ),
          const FieldGap(),
          AppTextField(
            label: 'Email Address',
            controller: _email,
            hint: 'billing@yourbusiness.com',
            keyboardType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            validator: Validators.email,
          ),
        ],
      );

  Widget _taxInfoSection() => SectionCard(
        title: 'TAX INFORMATION',
        icon: Icons.receipt_long_rounded,
        trailing: const OptionalBadge(),
        children: [
          AppTextField(
            label: 'GST Number (GSTIN)',
            controller: _gstNumber,
            hint: '33AABCP1234A1Z5',
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
              LengthLimitingTextInputFormatter(15),
            ],
            validator: Validators.gst,
          ),
          const FieldGap(),
          AppTextField(
            label: 'PAN Number',
            controller: _panNumber,
            hint: 'AABCP1234A',
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
              LengthLimitingTextInputFormatter(10),
            ],
            validator: Validators.pan,
          ),
        ],
      );

  Widget _identitySection() => SectionCard(
        title: 'LOGO & SIGNATURE',
        icon: Icons.image_rounded,
        trailing: const OptionalBadge(),
        children: [
          AppImagePickerField(
            label: 'Business Logo',
            currentPath: _logoPath,
            hint: 'Shown on invoice header. Recommended: square PNG, min 300×300px.',
            isCircle: false,
            previewSize: 90,
            onPicked: (rawPath) => _handleLogoPickedRaw(rawPath),
            onClear: () => setState(() => _logoPath = null),
          ),
          const SizedBox(height: 20),
          AppImagePickerField(
            label: 'Authorised Signature',
            currentPath: _signaturePath,
            hint: 'Shown at the bottom of invoices. PNG with transparent background works best.',
            isCircle: false,
            previewSize: 90,
            onPicked: (rawPath) => _handleSignaturePickedRaw(rawPath),
            onClear: () => setState(() => _signaturePath = null),
          ),
        ],
      );

  Widget _bankDetailsSection() => SectionCard(
        title: 'BANK DETAILS',
        icon: Icons.account_balance_rounded,
        trailing: const OptionalBadge(),
        children: [
          AppTextField(
            label: 'Bank Name',
            controller: _bankName,
            hint: 'e.g. State Bank of India',
            textCapitalization: TextCapitalization.words,
          ),
          const FieldGap(),
          AppTextField(
            label: 'Account Number',
            controller: _bankAccountNo,
            hint: 'e.g. 1234567890',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: Validators.bankAccount,
          ),
          const FieldGap(),
          AppTextField(
            label: 'IFSC Code',
            controller: _bankIfsc,
            hint: 'e.g. SBIN0001234',
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
              LengthLimitingTextInputFormatter(11),
            ],
            validator: Validators.ifsc,
          ),
          const FieldGap(),
          AppTextField(
            label: 'Branch Address',
            controller: _bankBranchAddress,
            hint: 'Bank branch address',
            maxLines: 2,
            minLines: 2,
          ),
        ],
      );

  Widget _submitButton() {
    final theme = Theme.of(context);
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _submit,
        child: _isSaving
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.onPrimary,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.submitLabel,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
      ),
    );
  }
}
