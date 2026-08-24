// Professional light + dark theme for a business billing app
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Colour palette — slate blue primary, warm neutral surfaces.
/// Designed for a professional business utility app (not playful).
abstract final class AppColors {
  // --- Brand / Primary ---
  static const primaryBlue = Color(0xFF1E3A5F); // Deep slate blue
  static const primaryNavy = Color(0xFF1E3A5F); // Alias for primaryBlue
  static const primaryBlueMid = Color(0xFF2C5282); // Medium slate blue
  static const primarySlate = Color(0xFF2C5282); // Alias for primaryBlueMid
  static const primaryBlueLight = Color(0xFF4A90D9); // Accent blue

  // --- Secondary / Accent ---
  static const amber = Color(0xFFF6AD55); // Warm amber for CTAs / badges
  static const amberDark = Color(0xFFDD6B20);

  // --- Surfaces — Light ---
  static const surfaceLight = Color(0xFFFAFAFA); // Off-white
  static const backgroundLight = Color(0xFFF0F4F8); // Very light slate
  static const cardLight = Color(0xFFFFFFFF);

  // --- Surfaces — Dark ---
  static const surfaceDark = Color(0xFF1A202C); // Charcoal
  static const backgroundDark = Color(0xFF0F1624); // Deep navy charcoal
  static const cardDark = Color(0xFF2D3748);

  // --- Text ---
  static const textDarkPrimary = Color(0xFF1A202C);
  static const textPrimary = Color(0xFF1A202C); // Alias
  static const textDarkSecondary = Color(0xFF4A5568);
  static const textSecondary = Color(0xFF4A5568); // Alias
  static const textLightPrimary = Color(0xFFF7FAFC);
  static const textLightSecondary = Color(0xFFCBD5E0);

  // --- Status ---
  static const success = Color(0xFF38A169);
  static const warning = Color(0xFFD69E2E);
  static const error = Color(0xFFE53E3E);
  static const info = Color(0xFF3182CE);

  // --- Invoice status colours ---
  static const statusDraft = Color(0xFF718096);
  static const statusSent = Color(0xFF3182CE);
  static const statusPaid = Color(0xFF38A169);
  static const statusOverdue = Color(0xFFE53E3E);
  static const statusCancelled = Color(0xFF718096);

  // --- Dividers ---
  static const dividerLight = Color(0xFFE2E8F0);
  static const dividerDark = Color(0xFF4A5568);
}

abstract final class AppTheme {
  // ──────────────────────────── LIGHT ────────────────────────────

  static ThemeData get lightTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryBlue,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFDCEEFF),
      onPrimaryContainer: AppColors.primaryBlue,
      secondary: AppColors.amber,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFFEF3E2),
      onSecondaryContainer: AppColors.amberDark,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textDarkPrimary,
      surfaceContainerHighest: AppColors.backgroundLight,
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: Color(0xFFFFE4E4),
      onErrorContainer: AppColors.error,
      outline: AppColors.dividerLight,
      outlineVariant: Color(0xFFCBD5E0),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: _buildTextTheme(Brightness.light),
      appBarTheme: _appBarTheme(colorScheme),
      cardTheme: _cardTheme(AppColors.cardLight),
      elevatedButtonTheme: _elevatedButtonTheme(colorScheme),
      outlinedButtonTheme: _outlinedButtonTheme(colorScheme),
      textButtonTheme: _textButtonTheme(colorScheme),
      inputDecorationTheme: _inputTheme(colorScheme),
      chipTheme: _chipTheme(colorScheme),
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerLight,
        thickness: 1,
        space: 1,
      ),
      navigationBarTheme: _navBarTheme(colorScheme),
      floatingActionButtonTheme: _fabTheme(colorScheme),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  // ──────────────────────────── DARK ────────────────────────────

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryBlueLight,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryBlueMid,
      onPrimaryContainer: Color(0xFFDCEEFF),
      secondary: AppColors.amber,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFF7B3F00),
      onSecondaryContainer: Color(0xFFFEEBC8),
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textLightPrimary,
      surfaceContainerHighest: AppColors.backgroundDark,
      error: Color(0xFFFC8181),
      onError: AppColors.backgroundDark,
      errorContainer: Color(0xFF742A2A),
      onErrorContainer: Color(0xFFFEB2B2),
      outline: AppColors.dividerDark,
      outlineVariant: Color(0xFF2D3748),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: _buildTextTheme(Brightness.dark),
      appBarTheme: _appBarTheme(colorScheme),
      cardTheme: _cardTheme(AppColors.cardDark),
      elevatedButtonTheme: _elevatedButtonTheme(colorScheme),
      outlinedButtonTheme: _outlinedButtonTheme(colorScheme),
      textButtonTheme: _textButtonTheme(colorScheme),
      inputDecorationTheme: _inputTheme(colorScheme),
      chipTheme: _chipTheme(colorScheme),
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerDark,
        thickness: 1,
        space: 1,
      ),
      navigationBarTheme: _navBarTheme(colorScheme),
      floatingActionButtonTheme: _fabTheme(colorScheme),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  // ──────────────────────────── Shared builders ────────────────────────────

  static TextTheme _buildTextTheme(Brightness brightness) {
    final base = brightness == Brightness.light
        ? AppColors.textDarkPrimary
        : AppColors.textLightPrimary;
    final secondary = brightness == Brightness.light
        ? AppColors.textDarkSecondary
        : AppColors.textLightSecondary;

    return GoogleFonts.interTextTheme(
      TextTheme(
        displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: base,
            letterSpacing: -0.5),
        displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: base,
            letterSpacing: -0.5),
        displaySmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: base,
            letterSpacing: -0.3),
        headlineLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: base,
            letterSpacing: -0.2),
        headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: base),
        headlineSmall: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: base),
        titleLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: base),
        titleMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: base),
        titleSmall: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: secondary),
        bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: base),
        bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: base),
        bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: secondary),
        labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: base,
            letterSpacing: 0.1),
        labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: secondary,
            letterSpacing: 0.5),
        labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: secondary,
            letterSpacing: 0.5),
      ),
    );
  }

  static AppBarTheme _appBarTheme(ColorScheme cs) => AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: cs.outline.withAlpha(128),
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: cs.onSurface,
        ),
      );

  static CardThemeData _cardTheme(Color cardColor) => CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.dividerLight.withAlpha(180)),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      );

  static ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme cs) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          elevation: 0,
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme(ColorScheme cs) =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: cs.primary,
          side: BorderSide(color: cs.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  static TextButtonThemeData _textButtonTheme(ColorScheme cs) =>
      TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: cs.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );

  static InputDecorationTheme _inputTheme(ColorScheme cs) =>
      InputDecorationTheme(
        filled: true,
        fillColor: cs.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: cs.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: cs.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: cs.error),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(
          color: cs.onSurface.withAlpha(128),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: TextStyle(
          color: cs.onSurface.withAlpha(180),
          fontSize: 14,
        ),
      );

  static ChipThemeData _chipTheme(ColorScheme cs) => ChipThemeData(
        backgroundColor: cs.surfaceContainerHighest,
        selectedColor: AppColors.primaryBlue,
        disabledColor: cs.onSurface.withAlpha(50),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: cs.onSurface,
        ),
        secondaryLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: cs.outlineVariant),
        ),
      );

  static NavigationBarThemeData _navBarTheme(ColorScheme cs) =>
      NavigationBarThemeData(
        backgroundColor: cs.surface,
        indicatorColor: cs.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.inter(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? cs.primary : cs.onSurface.withAlpha(160),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? cs.primary : cs.onSurface.withAlpha(160),
            size: 22,
          );
        }),
        elevation: 1,
        shadowColor: cs.outline.withAlpha(64),
      );

  static FloatingActionButtonThemeData _fabTheme(ColorScheme cs) =>
      FloatingActionButtonThemeData(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      );
}
