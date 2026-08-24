// Reusable labelled text field for billing app forms
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatefulWidget {
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
    this.focusNode,
    this.selectAllOnFocus,
    this.onTap,
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
  final FocusNode? focusNode;
  final bool? selectAllOnFocus;
  final VoidCallback? onTap;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  FocusNode? _internalFocusNode;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  bool get _shouldSelectAllOnFocus {
    if (widget.selectAllOnFocus != null) return widget.selectAllOnFocus!;
    final kt = widget.keyboardType;
    if (kt == TextInputType.number ||
        kt == const TextInputType.numberWithOptions() ||
        kt == const TextInputType.numberWithOptions(decimal: true) ||
        kt == const TextInputType.numberWithOptions(signed: true, decimal: true) ||
        (kt != null && (kt.toString().contains('number')))) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _effectiveFocusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _internalFocusNode)?.removeListener(_handleFocusChange);
      _effectiveFocusNode.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_handleFocusChange);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_effectiveFocusNode.hasFocus && _shouldSelectAllOnFocus) {
      _selectAll();
    }
  }

  void _selectAll() {
    Future.microtask(() {
      if (mounted && _effectiveFocusNode.hasFocus && widget.controller.text.isNotEmpty) {
        widget.controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: widget.controller.text.length,
        );
      }
    });
  }

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
              widget.label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: cs.onSurface.withAlpha(200),
              ),
            ),
            if (widget.isRequired) ...[
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
          controller: widget.controller,
          focusNode: _effectiveFocusNode,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization,
          textInputAction: widget.textInputAction,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          inputFormatters: widget.inputFormatters,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          onChanged: widget.onChanged,
          onTap: () {
            widget.onTap?.call();
            if (_shouldSelectAllOnFocus) {
              _selectAll();
            }
          },
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: cs.onSurface,
            height: 1.3,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            helperText: widget.helperText,
            helperMaxLines: 2,
            suffixIcon: widget.suffix,
            prefixIcon: widget.prefix,
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
