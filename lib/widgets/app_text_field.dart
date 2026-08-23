// Reusable labelled text field for billing app forms
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.helperText,
    this.validator,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.sentences,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.minLines,
    this.inputFormatters,
    this.suffix,
    this.prefix,
    this.isRequired = false,
    this.enabled = true,
    this.onChanged,
    this.autofocus = false,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? helperText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final int? maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffix;
  final Widget? prefix;
  final bool isRequired;
  final bool enabled;
  final void Function(String)? onChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: cs.onSurface.withAlpha(200),
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 3),
              Text(
                '*',
                style: TextStyle(
                  color: cs.error,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          maxLines: maxLines,
          minLines: minLines,
          inputFormatters: inputFormatters,
          enabled: enabled,
          autofocus: autofocus,
          onChanged: onChanged,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: cs.onSurface,
            height: 1.3,
          ),
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            helperMaxLines: 2,
            suffixIcon: suffix,
            prefixIcon: prefix,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }
}

/// Spacer between form fields — standard 16px gap.
class FieldGap extends StatelessWidget {
  const FieldGap({super.key, this.height = 16});
  final double height;
  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}
