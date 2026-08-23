import 'package:flutter_test/flutter_test.dart';
import 'package:billwise/utils/number_to_words.dart';

void main() {
  group('NumberToWords Converter', () {
    test('converts 8000.03 correctly', () {
      expect(
        NumberToWords.convert(8000.03),
        'Eight Thousand Rupees and Three Paise Only',
      );
    });

    test('converts 15000 correctly', () {
      expect(
        NumberToWords.convert(15000.0),
        'Fifteen Thousand Rupees Only',
      );
    });

    test('converts 19200.50 correctly', () {
      expect(
        NumberToWords.convert(19200.50),
        'Nineteen Thousand Two Hundred Rupees and Fifty Paise Only',
      );
    });

    test('converts 1234567.89 (Lakhs) correctly', () {
      expect(
        NumberToWords.convert(1234567.89),
        'Twelve Lakh Thirty Four Thousand Five Hundred Sixty Seven Rupees and Eighty Nine Paise Only',
      );
    });
  });
}
