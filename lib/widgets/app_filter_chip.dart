import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_theme.dart';

/// App-wide standardized Filter Chip widget.
/// Ensures consistent, high-contrast readability in both selected and unselected states across Light and Dark themes.
class AppFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;
  final IconData? icon;

  const AppFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final selectedBg = AppColors.primaryBlue;
    final unselectedBg = isDark ? cs.surfaceContainerHighest : Colors.white;

    final selectedText = Colors.white;
    final unselectedText = isDark ? cs.onSurface : AppColors.textDarkPrimary;

    final borderColor = isSelected
        ? AppColors.primaryBlue
        : (isDark ? cs.outline.withAlpha(100) : Colors.grey.shade300);

    return FilterChip(
      avatar: icon != null
          ? Icon(
              icon,
              size: 14,
              color: isSelected ? selectedText : unselectedText,
            )
          : null,
      label: Text(
        label,
        style: GoogleFonts.inter(
          color: isSelected ? selectedText : unselectedText,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: 12,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: selectedBg,
      backgroundColor: unselectedBg,
      showCheckmark: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: borderColor),
      ),
    );
  }
}
