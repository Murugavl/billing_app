// Encryption Service — Client-side AES-256-CBC encryption with SHA-256 key derivation
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class EncryptionService {
  static const String _salt = 'RasidhuEncryptedDriveBackupSalt2026_v1';

  /// Derives a 256-bit (32 bytes) AES Key from Google User ID and app salt using SHA-256.
  static Key _deriveKey(String googleUserId) {
    final combined = '$googleUserId:$_salt';
    final digest = sha256.convert(utf8.encode(combined));
    return Key(Uint8List.fromList(digest.bytes));
  }

  /// Encrypts JSON string payload into AES-256-CBC encrypted byte array.
  /// Prepends 16-byte IV to the ciphertext output.
  static Uint8List encryptJson(String jsonPayload, String googleUserId) {
    final key = _deriveKey(googleUserId);
    final iv = IV.fromSecureRandom(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(jsonPayload, iv: iv);

    // Output layout: [16 bytes IV][Ciphertext bytes]
    final result = Uint8List(iv.bytes.length + encrypted.bytes.length);
    result.setRange(0, iv.bytes.length, iv.bytes);
    result.setRange(iv.bytes.length, result.length, encrypted.bytes);

    return result;
  }

  /// Decrypts AES-256-CBC encrypted byte array back into JSON string payload.
  static String decryptJson(Uint8List encryptedData, String googleUserId) {
    if (encryptedData.length <= 16) {
      throw Exception('Invalid encrypted data payload — length too short');
    }

    final key = _deriveKey(googleUserId);
    final ivBytes = encryptedData.sublist(0, 16);
    final cipherBytes = encryptedData.sublist(16);

    final iv = IV(ivBytes);
    final encrypted = Encrypted(cipherBytes);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final decryptedString = encrypter.decrypt(encrypted, iv: iv);

    return decryptedString;
  }
}
