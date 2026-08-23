// Domain enums for Documents and Payments
// These mirror the text values stored in SQLite.

/// Document type discriminator.
enum DocumentType {
  invoice,
  estimate;

  String get value => name; // 'invoice' | 'estimate'

  static DocumentType fromString(String v) =>
      DocumentType.values.firstWhere((e) => e.value == v,
          orElse: () => DocumentType.invoice);
}

/// Unified status enum.
/// Invoice valid values : draft, sent, paid, partiallypaid, overdue
/// Estimate valid values: draft, sent, accepted, expired
enum DocumentStatus {
  draft,
  sent,
  paid,
  partiallyPaid,
  overdue,
  accepted,
  expired;

  String get value {
    switch (this) {
      case DocumentStatus.partiallyPaid: return 'partially_paid';
      default: return name;
    }
  }

  String get displayLabel {
    switch (this) {
      case DocumentStatus.draft: return 'Draft';
      case DocumentStatus.sent: return 'Sent';
      case DocumentStatus.paid: return 'Paid';
      case DocumentStatus.partiallyPaid: return 'Partially Paid';
      case DocumentStatus.overdue: return 'Overdue';
      case DocumentStatus.accepted: return 'Accepted';
      case DocumentStatus.expired: return 'Expired';
    }
  }

  static DocumentStatus fromString(String v) {
    if (v == 'partially_paid') return DocumentStatus.partiallyPaid;
    return DocumentStatus.values.firstWhere((e) => e.name == v,
        orElse: () => DocumentStatus.draft);
  }

  /// Valid statuses for a given document type.
  static List<DocumentStatus> forType(DocumentType type) {
    if (type == DocumentType.invoice) {
      return [
        DocumentStatus.draft,
        DocumentStatus.sent,
        DocumentStatus.paid,
        DocumentStatus.partiallyPaid,
        DocumentStatus.overdue,
      ];
    }
    return [
      DocumentStatus.draft,
      DocumentStatus.sent,
      DocumentStatus.accepted,
      DocumentStatus.expired,
    ];
  }
}

/// Payment method enum.
enum PaymentMethod {
  cash,
  upi,
  bankTransfer,
  cheque,
  other;

  String get value {
    switch (this) {
      case PaymentMethod.bankTransfer: return 'bank_transfer';
      default: return name;
    }
  }

  String get displayLabel {
    switch (this) {
      case PaymentMethod.cash: return 'Cash';
      case PaymentMethod.upi: return 'UPI';
      case PaymentMethod.bankTransfer: return 'Bank Transfer';
      case PaymentMethod.cheque: return 'Cheque';
      case PaymentMethod.other: return 'Other';
    }
  }

  static PaymentMethod fromString(String v) {
    if (v == 'bank_transfer') return PaymentMethod.bankTransfer;
    return PaymentMethod.values.firstWhere((e) => e.name == v,
        orElse: () => PaymentMethod.other);
  }
}
