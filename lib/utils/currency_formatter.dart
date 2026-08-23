// Currency & Date formatters — defaults to INR (Indian Rupee)
import 'package:intl/intl.dart';

/// Formats monetary amounts in Indian Rupee (INR) by default.
class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _inrFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  /// Formats [amount] as INR. Example: `1234.5` → `₹1,234.50`
  static String format(double amount, {String? symbol, String? locale}) {
    if (symbol != null || locale != null) {
      return NumberFormat.currency(
        locale: locale ?? 'en_IN',
        symbol: symbol ?? '₹',
        decimalDigits: 2,
      ).format(amount);
    }
    return _inrFormatter.format(amount);
  }

  /// Formats [amount] for PDF rendering using ₹ (Indian Rupee).
  static String formatPdf(double amount) {
    return _inrFormatter.format(amount);
  }

  /// Formats [amount] compactly. Example: `1234567` → `₹12.35L`
  static String formatCompact(double amount) {
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(2)}Cr';
    } else if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(2)}L';
    } else if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(1)}K';
    }
    return format(amount);
  }
}
