// Shared BusinessProfile form — used by OnboardingScreen and SettingsScreen
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../db/app_database.dart';
import '../utils/validators.dart';
import '../utils/image_utils.dart';
import '../core/theme/app_theme.dart';
import '../services/document_numbering_service.dart';
import 'app_image_picker_field.dart';
import 'app_text_field.dart';
import 'section_card.dart';
import 'signature_selector_field.dart';

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

  // Invoice Numbering
  late final TextEditingController _invoicePrefix;
  late final TextEditingController _invoiceFormat;
  late int _invoicePadding;
  late final TextEditingController _invoiceSeparator;
  late final TextEditingController _invoiceNextSeq;

  // Estimate Numbering
  late final TextEditingController _estimatePrefix;
  late final TextEditingController _estimateFormat;
  late int _estimatePadding;
  late final TextEditingController _estimateSeparator;
  late final TextEditingController _estimateNextSeq;

  // Purchase Bill Numbering
  late final TextEditingController _purchasePrefix;
  late final TextEditingController _purchaseFormat;
  late int _purchasePadding;
  late final TextEditingController _purchaseSeparator;
  late final TextEditingController _purchaseNextSeq;
  // Bank Details PDF Defaults
  late bool _defaultIncludeBankDetailsInvoice;
  late bool _defaultIncludeBankDetailsEstimate;

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

    _invoicePrefix = TextEditingController(text: d?.invoiceNumberPrefix ?? 'INV');
    _invoiceFormat =
        TextEditingController(text: d?.invoiceNumberFormat ?? '{PREFIX}-{SEQ}');
    _invoicePadding = d?.invoiceNumberPadding ?? 4;
    _invoiceSeparator =
        TextEditingController(text: d?.invoiceNumberSeparator ?? '-');
    _invoiceNextSeq =
        TextEditingController(text: (d?.invoiceNextSequence ?? 1).toString());

    _estimatePrefix = TextEditingController(text: d?.estimateNumberPrefix ?? 'EST');
    _estimateFormat =
        TextEditingController(text: d?.estimateNumberFormat ?? '{PREFIX}-{SEQ}');
    _estimatePadding = d?.estimateNumberPadding ?? 4;
    _estimateSeparator =
        TextEditingController(text: d?.estimateNumberSeparator ?? '-');
    _estimateNextSeq =
        TextEditingController(text: (d?.estimateNextSequence ?? 1).toString());

    _purchasePrefix = TextEditingController(text: d?.purchaseNumberPrefix ?? 'PUR');
    _purchaseFormat =
        TextEditingController(text: d?.purchaseNumberFormat ?? '{PREFIX}-{SEQ}');
    _purchasePadding = d?.purchaseNumberPadding ?? 4;
    _purchaseSeparator =
        TextEditingController(text: d?.purchaseNumberSeparator ?? '-');
    _purchaseNextSeq =
        TextEditingController(text: (d?.purchaseNextSequence ?? 1).toString());

    _defaultIncludeBankDetailsInvoice =
        d?.defaultIncludeBankDetailsInvoice ?? true;
    _defaultIncludeBankDetailsEstimate =
        d?.defaultIncludeBankDetailsEstimate ?? true;
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

    _invoicePrefix.dispose();
    _invoiceFormat.dispose();
    _invoiceSeparator.dispose();
    _invoiceNextSeq.dispose();

    _estimatePrefix.dispose();
    _estimateFormat.dispose();
    _estimateSeparator.dispose();
    _estimateNextSeq.dispose();

    _purchasePrefix.dispose();
    _purchaseFormat.dispose();
    _purchaseSeparator.dispose();
    _purchaseNextSeq.dispose();
    super.dispose();
  }

  Future<void> _handleLogoPickedRaw(String rawPath) async {
    final saved = await ImageUtils.saveLogo(rawPath);
    setState(() => _logoPath = saved);
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
        invoiceNumberPrefix: Value(_invoicePrefix.text.trim().isEmpty
            ? 'INV'
            : _invoicePrefix.text.trim()),
        invoiceNumberFormat: Value(_invoiceFormat.text.trim().isEmpty
            ? '{PREFIX}-{SEQ}'
            : _invoiceFormat.text.trim()),
        invoiceNumberPadding: Value(_invoicePadding),
        invoiceNumberSeparator: Value(_invoiceSeparator.text.isEmpty
            ? '-'
            : _invoiceSeparator.text),
        invoiceNextSequence: Value(
            int.tryParse(_invoiceNextSeq.text.trim()) ?? 1),
        estimateNumberPrefix: Value(_estimatePrefix.text.trim().isEmpty
            ? 'EST'
            : _estimatePrefix.text.trim()),
        estimateNumberFormat: Value(_estimateFormat.text.trim().isEmpty
            ? '{PREFIX}-{SEQ}'
            : _estimateFormat.text.trim()),
        estimateNumberPadding: Value(_estimatePadding),
        estimateNumberSeparator: Value(_estimateSeparator.text.isEmpty
            ? '-'
            : _estimateSeparator.text),
        estimateNextSequence: Value(
            int.tryParse(_estimateNextSeq.text.trim()) ?? 1),
        purchaseNumberPrefix: Value(_purchasePrefix.text.trim().isEmpty
            ? 'PUR'
            : _purchasePrefix.text.trim()),
        purchaseNumberFormat: Value(_purchaseFormat.text.trim().isEmpty
            ? '{PREFIX}-{SEQ}'
            : _purchaseFormat.text.trim()),
        purchaseNumberPadding: Value(_purchasePadding),
        purchaseNumberSeparator: Value(_purchaseSeparator.text.isEmpty
            ? '-'
            : _purchaseSeparator.text),
        purchaseNextSequence: Value(
            int.tryParse(_purchaseNextSeq.text.trim()) ?? 1),
        defaultIncludeBankDetailsInvoice:
            Value(_defaultIncludeBankDetailsInvoice),
        defaultIncludeBankDetailsEstimate:
            Value(_defaultIncludeBankDetailsEstimate),
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
          const SizedBox(height: 16),
          _documentNumberingSection(),
          const SizedBox(height: 28),
          _submitButton(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ── Section builders ────────────────────────────────────────────────────────

  Widget _documentNumberingSection() {
    return SectionCard(
      title: 'DOCUMENT NUMBERING',
      icon: Icons.pin_rounded,
      children: [
        DefaultTabController(
          length: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  labelColor: AppColors.primaryBlue,
                  unselectedLabelColor: Colors.grey.shade700,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  tabs: const [
                    Tab(text: 'Invoices'),
                    Tab(text: 'Estimates'),
                    Tab(text: 'Purchase Bills'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 380,
                child: TabBarView(
                  children: [
                    _numberingTabConfig(
                      docName: 'Invoice',
                      prefixCtrl: _invoicePrefix,
                      formatCtrl: _invoiceFormat,
                      paddingVal: _invoicePadding,
                      onPaddingChanged: (v) =>
                          setState(() => _invoicePadding = v),
                      separatorCtrl: _invoiceSeparator,
                      nextSeqCtrl: _invoiceNextSeq,
                    ),
                    _numberingTabConfig(
                      docName: 'Estimate',
                      prefixCtrl: _estimatePrefix,
                      formatCtrl: _estimateFormat,
                      paddingVal: _estimatePadding,
                      onPaddingChanged: (v) =>
                          setState(() => _estimatePadding = v),
                      separatorCtrl: _estimateSeparator,
                      nextSeqCtrl: _estimateNextSeq,
                    ),
                    _numberingTabConfig(
                      docName: 'Purchase Bill',
                      prefixCtrl: _purchasePrefix,
                      formatCtrl: _purchaseFormat,
                      paddingVal: _purchasePadding,
                      onPaddingChanged: (v) =>
                          setState(() => _purchasePadding = v),
                      separatorCtrl: _purchaseSeparator,
                      nextSeqCtrl: _purchaseNextSeq,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _numberingTabConfig({
    required String docName,
    required TextEditingController prefixCtrl,
    required TextEditingController formatCtrl,
    required int paddingVal,
    required ValueChanged<int> onPaddingChanged,
    required TextEditingController separatorCtrl,
    required TextEditingController nextSeqCtrl,
  }) {
    final preview = DocumentNumberingService.formatDocumentNumber(
      template: formatCtrl.text,
      prefix: prefixCtrl.text.isEmpty
          ? docName.substring(0, 3).toUpperCase()
          : prefixCtrl.text,
      sequence: int.tryParse(nextSeqCtrl.text) ?? 1,
      padding: paddingVal,
      separator: separatorCtrl.text.isEmpty ? '-' : separatorCtrl.text,
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Live Preview Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.visibility_rounded,
                    color: AppColors.primaryBlue, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next $docName Number Preview:',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      SelectableText(
                        preview,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Prefix field
          AppTextField(
            label: '$docName Prefix',
            controller: prefixCtrl,
            hint: 'e.g. GE, INV, EST, PUR',
            onChanged: (_) => setState(() {}),
          ),
          const FieldGap(),

          // Format template field
          AppTextField(
            label: 'Format Template',
            controller: formatCtrl,
            hint: 'e.g. {PREFIX}/{FY}/{SEQ}',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 6),

          // Placeholder shortcut chips
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              _placeholderChip('{PREFIX}', formatCtrl),
              _placeholderChip('{FY}', formatCtrl),
              _placeholderChip('{SEQ}', formatCtrl),
              _placeholderChip('{SEP}', formatCtrl),
            ],
          ),
          const FieldGap(),

          // Row for Padding, Separator, Next Sequence
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Digit Padding',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<int>(
                      value: paddingVal,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 12),
                      ),
                      items: const [
                        DropdownMenuItem(value: 2, child: Text('2 (01)')),
                        DropdownMenuItem(value: 3, child: Text('3 (001)')),
                        DropdownMenuItem(value: 4, child: Text('4 (0001)')),
                        DropdownMenuItem(value: 5, child: Text('5 (00001)')),
                      ],
                      onChanged: (v) {
                        if (v != null) onPaddingChanged(v);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppTextField(
                  label: 'Separator',
                  controller: separatorCtrl,
                  hint: '/',
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppTextField(
                  label: 'Next Seq #',
                  controller: nextSeqCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _placeholderChip(String tag, TextEditingController controller) {
    return ActionChip(
      visualDensity: VisualDensity.compact,
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      label: Text(tag,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      onPressed: () {
        final text = controller.text;
        final sel = controller.selection;
        if (sel.start >= 0 && sel.end >= 0) {
          final newText = text.replaceRange(sel.start, sel.end, tag);
          controller.text = newText;
          controller.selection =
              TextSelection.collapsed(offset: sel.start + tag.length);
        } else {
          controller.text = text + tag;
        }
        setState(() {});
      },
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
            hint: 'e.g. Acme Traders',
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
          SignatureSelectorField(
            label: 'Authorised Signature',
            currentPath: _signaturePath,
            hint: 'Printed at the bottom of invoices and bills.',
            onSaved: (path) => setState(() => _signaturePath = path),
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
          const Divider(height: 24),
          Text(
            'PDF DISPLAY DEFAULTS FOR NEW DOCUMENTS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Show bank details on new Invoices by default',
                style: TextStyle(fontSize: 13)),
            value: _defaultIncludeBankDetailsInvoice,
            onChanged: (val) =>
                setState(() => _defaultIncludeBankDetailsInvoice = val),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Show bank details on new Estimates by default',
                style: TextStyle(fontSize: 13)),
            value: _defaultIncludeBankDetailsEstimate,
            onChanged: (val) =>
                setState(() => _defaultIncludeBankDetailsEstimate = val),
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
