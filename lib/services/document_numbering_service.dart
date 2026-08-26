// Document Numbering Service — Calculates Financial Year & Formats Document Numbers
class DocumentNumberingService {
  /// Calculates Financial Year string (e.g. "26-27" for April 2026 to March 2027).
  static String calculateFinancialYear(DateTime date) {
    final int startYear;
    final int endYear;

    if (date.month >= 4) {
      startYear = date.year % 100;
      endYear = (date.year + 1) % 100;
    } else {
      startYear = (date.year - 1) % 100;
      endYear = date.year % 100;
    }

    final startStr = startYear.toString().padLeft(2, '0');
    final endStr = endYear.toString().padLeft(2, '0');

    return '$startStr-$endStr';
  }

  /// Formats a document number using template placeholders ({PREFIX}, {FY}, {SEQ}, {SEP}).
  static String formatDocumentNumber({
    required String template,
    required String prefix,
    required int sequence,
    int padding = 4,
    String separator = '-',
    DateTime? date,
  }) {
    final targetDate = date ?? DateTime.now();
    final fy = calculateFinancialYear(targetDate);
    final validPadding = padding < 1 ? 1 : padding;
    final paddedSeq = sequence.toString().padLeft(validPadding, '0');

    var fmt = template.trim();
    if (fmt.isEmpty) {
      fmt = '{PREFIX}-{SEQ}';
    }

    return fmt
        .replaceAll('{PREFIX}', prefix)
        .replaceAll('{FY}', fy)
        .replaceAll('{SEQ}', paddedSeq)
        .replaceAll('{SEP}', separator);
  }
}
