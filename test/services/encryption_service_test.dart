// Unit tests for AES-256 Encryption Service
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:billwise/services/encryption_service.dart';

void main() {
  group('EncryptionService AES-256 Tests', () {
    test('Encrypt and decrypt roundtrip restores exact JSON payload', () {
      const googleUserId = 'google_user_123456789';
      final sampleJson = jsonEncode({
        'version': 1,
        'app': 'Billwise',
        'customers': [
          {'id': 1, 'name': 'Ponsri Water Tech', 'phone': '9876543210'}
        ],
        'invoices': [
          {'id': 100, 'number': 'INV-001', 'total': 8000.0}
        ]
      });

      final encrypted = EncryptionService.encryptJson(sampleJson, googleUserId);
      expect(encrypted.length, greaterThan(16));

      final decrypted = EncryptionService.decryptJson(encrypted, googleUserId);
      expect(decrypted, equals(sampleJson));
    });

    test('Decryption fails with incorrect Google User ID (key mismatch)', () {
      const googleUserId = 'user_correct_id';
      const wrongUserId = 'user_wrong_id';

      final sampleJson = jsonEncode({'secret': 'confidential_billing_data'});
      final encrypted = EncryptionService.encryptJson(sampleJson, googleUserId);

      expect(
        () => EncryptionService.decryptJson(encrypted, wrongUserId),
        throwsA(anything),
      );
    });
  });
}
