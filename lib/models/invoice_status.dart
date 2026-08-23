// Models directory
// Drift auto-generates data classes from table definitions in /db/tables/.
// Add manual model classes here for non-database domain objects (e.g., report
// summaries, PDF payloads, app-level enums).

/// Invoice status as a typed enum — mirrors the string constants in InvoiceStatus.
enum InvoiceStatusEnum {
  draft,
  sent,
  paid,
  overdue,
  cancelled;

  String get displayLabel {
    switch (this) {
      case InvoiceStatusEnum.draft: return 'Draft';
      case InvoiceStatusEnum.sent: return 'Sent';
      case InvoiceStatusEnum.paid: return 'Paid';
      case InvoiceStatusEnum.overdue: return 'Overdue';
      case InvoiceStatusEnum.cancelled: return 'Cancelled';
    }
  }

  static InvoiceStatusEnum fromString(String value) {
    return InvoiceStatusEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => InvoiceStatusEnum.draft,
    );
  }
}
