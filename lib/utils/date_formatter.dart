// Date formatter utilities
import 'package:intl/intl.dart';

/// Formats dates for display in the billing app.
class DateFormatter {
  DateFormatter._();

  static final DateFormat _displayFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _shortFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _monthYearFormat = DateFormat('MMM yyyy');
  static final DateFormat _fullFormat =
      DateFormat('dd MMM yyyy, hh:mm a');
  static final DateFormat _invoiceFormat = DateFormat('dd-MM-yyyy');

  /// Example: `22 Aug 2026`
  static String display(DateTime date) => _displayFormat.format(date);

  /// Example: `22/08/2026`
  static String short(DateTime date) => _shortFormat.format(date);

  /// Example: `Aug 2026`
  static String monthYear(DateTime date) => _monthYearFormat.format(date);

  /// Example: `22 Aug 2026, 04:06 PM`
  static String full(DateTime date) => _fullFormat.format(date);

  /// Example: `22-08-2026` (for invoice number suffixes)
  static String invoice(DateTime date) => _invoiceFormat.format(date);

  /// Returns `Overdue` / `Due today` / `Due in N days`
  static String dueDateLabel(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final diff = due.difference(today).inDays;

    if (diff < 0) return 'Overdue by ${-diff} day${diff == -1 ? '' : 's'}';
    if (diff == 0) return 'Due today';
    return 'Due in $diff day${diff == 1 ? '' : 's'}';
  }
}
