// Indian Currency Number to Words converter
// Converts numeric amounts into Indian English format (Rupees & Paise).
// Examples:
//   8000.03 → "Eight Thousand Rupees and Three Paise Only"
//   15000   → "Fifteen Thousand Rupees Only"
//   19200.50 → "Nineteen Thousand Two Hundred Rupees and Fifty Paise Only"

abstract final class NumberToWords {
  static const List<String> _units = [
    '',
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    'Six',
    'Seven',
    'Eight',
    'Nine',
    'Ten',
    'Eleven',
    'Twelve',
    'Thirteen',
    'Fourteen',
    'Fifteen',
    'Sixteen',
    'Seventeen',
    'Eighteen',
    'Nineteen'
  ];

  static const List<String> _tens = [
    '',
    '',
    'Twenty',
    'Thirty',
    'Forty',
    'Fifty',
    'Sixty',
    'Seventy',
    'Eighty',
    'Ninety'
  ];

  /// Converts a double amount into Indian Rupees and Paise words.
  static String convert(double amount) {
    if (amount <= 0) return 'Zero Rupees Only';

    final totalPaisa = (amount * 100).round();
    final rupees = totalPaisa ~/ 100;
    final paisa = totalPaisa % 100;

    final rupeesWords = _convertRupees(rupees);
    final paisaWords = paisa > 0 ? _convertPaisa(paisa) : '';

    if (rupeesWords.isEmpty && paisaWords.isEmpty) {
      return 'Zero Rupees Only';
    }

    if (rupeesWords.isEmpty) {
      return '$paisaWords Only';
    }

    if (paisaWords.isEmpty) {
      return '$rupeesWords Rupees Only';
    }

    return '$rupeesWords Rupees and $paisaWords Only';
  }

  static String _convertPaisa(int paisa) {
    if (paisa == 0) return '';
    final words = _convertUnderHundred(paisa);
    return '$words Paise';
  }

  static String _convertRupees(int n) {
    if (n == 0) return '';

    if (n < 20) return _units[n];
    if (n < 100) {
      final unitStr = _units[n % 10];
      return '${_tens[n ~/ 10]}${unitStr.isNotEmpty ? " $unitStr" : ""}';
    }
    if (n < 1000) {
      final remStr = _convertRupees(n % 100);
      return '${_units[n ~/ 100]} Hundred${remStr.isNotEmpty ? " $remStr" : ""}';
    }
    if (n < 100000) {
      final remStr = _convertRupees(n % 1000);
      return '${_convertRupees(n ~/ 1000)} Thousand${remStr.isNotEmpty ? " $remStr" : ""}';
    }
    if (n < 10000000) {
      final remStr = _convertRupees(n % 100000);
      return '${_convertRupees(n ~/ 100000)} Lakh${remStr.isNotEmpty ? " $remStr" : ""}';
    }

    final remStr = _convertRupees(n % 10000000);
    return '${_convertRupees(n ~/ 10000000)} Crore${remStr.isNotEmpty ? " $remStr" : ""}';
  }

  static String _convertUnderHundred(int n) {
    if (n < 20) return _units[n];
    final unitStr = _units[n % 10];
    return '${_tens[n ~/ 10]}${unitStr.isNotEmpty ? " $unitStr" : ""}';
  }
}
