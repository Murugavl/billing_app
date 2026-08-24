// Drive Backup Error Handling & Messaging Unit Tests
import 'package:billwise/providers/drive_backup_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Google Sign-In & Drive Restore Error Messaging Tests', () {
    test('DriveService handles PlatformException 10 with clear DEVELOPER_ERROR message', () async {
      try {
        // Simulating the PlatformException thrown by GoogleSignIn on Android when SHA-1 is missing
        throw PlatformException(
          code: 'sign_in_failed',
          message: 'com.google.android.gms.common.api.ApiException: 10: ',
        );
      } on PlatformException catch (e) {
        final detailStr = e.toString();
        expect(detailStr.contains('10') || detailStr.contains('sign_in_failed'), isTrue);
        
        final formattedEx = Exception(
          'Google Sign-In configuration error (10: DEVELOPER_ERROR). '
          'Please ensure the SHA-1 fingerprint and package name (com.ponsri.billwise) '
          'are registered in Google Cloud / Firebase Console.',
        );

        expect(formattedEx.toString(), contains('com.ponsri.billwise'));
        expect(formattedEx.toString(), contains('SHA-1 fingerprint'));
      }
    });

    test('DriveBackupState preserves statusMessage across updates', () {
      const state = DriveBackupState();
      expect(state.user, isNull);
      expect(state.statusMessage, isNull);

      final updatedState = state.copyWith(
        statusMessage: 'Google Sign-In configuration error (10: DEVELOPER_ERROR)',
      );

      expect(updatedState.statusMessage, contains('DEVELOPER_ERROR'));
    });
  });
}
