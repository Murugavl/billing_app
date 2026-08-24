// Google Drive API Service — appDataFolder scope storage for encrypted backups
import 'dart:async';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:shared_preferences/shared_preferences.dart';

class DriveBackupMetadata {
  final String fileId;
  final DateTime modifiedTime;
  final int sizeBytes;

  const DriveBackupMetadata({
    required this.fileId,
    required this.modifiedTime,
    required this.sizeBytes,
  });
}

class DriveService {
  static const String backupFileName = 'billwise_backup.enc';
  static const String appDataFolderScope = 'https://www.googleapis.com/auth/drive.appdata';

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
      appDataFolderScope,
    ],
  );

  /// Returns currently signed in Google Account user (silently checks cached sign-in).
  static Future<GoogleSignInAccount?> getSignedInUser() async {
    return _googleSignIn.signInSilently();
  }

  /// Triggers Google Sign-In interactive popup.
  static Future<GoogleSignInAccount?> signIn() async {
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('drive_user_email', user.email);
        await prefs.setString('drive_user_id', user.id);
        if (user.displayName != null) {
          await prefs.setString('drive_user_name', user.displayName!);
        }
      }
      return user;
    } on PlatformException catch (e) {
      final detailStr = e.toString();
      if (detailStr.contains('10') || detailStr.contains('sign_in_failed')) {
        throw Exception(
          'Google Sign-In configuration error (10: DEVELOPER_ERROR). '
          'Please ensure the SHA-1 fingerprint and package name (com.ponsri.billwise) '
          'are registered in Google Cloud / Firebase Console.',
        );
      }
      throw Exception('Google Sign-In failed: ${e.message ?? e.code}');
    } catch (e) {
      throw Exception('Google Sign-In failed: $e');
    }
  }

  /// Signs out current Google Account.
  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('drive_user_email');
    await prefs.remove('drive_user_id');
    await prefs.remove('drive_user_name');
  }

  /// Authenticates an HTTP client for Google Drive API v3 calls.
  static Future<drive.DriveApi?> _getDriveApi(GoogleSignInAccount user) async {
    final httpClient = await _googleSignIn.authenticatedClient();
    if (httpClient == null) return null;
    return drive.DriveApi(httpClient);
  }

  /// Finds existing backup file metadata in `appDataFolder`.
  static Future<DriveBackupMetadata?> findBackupMetadata(GoogleSignInAccount user) async {
    final driveApi = await _getDriveApi(user);
    if (driveApi == null) return null;

    final fileList = await driveApi.files.list(
      spaces: 'appDataFolder',
      q: "name = '$backupFileName' and trashed = false",
      $fields: 'files(id, name, modifiedTime, size)',
    );

    if (fileList.files == null || fileList.files!.isEmpty) {
      return null;
    }

    final file = fileList.files!.first;
    return DriveBackupMetadata(
      fileId: file.id ?? '',
      modifiedTime: file.modifiedTime ?? DateTime.now(),
      sizeBytes: int.tryParse(file.size ?? '0') ?? 0,
    );
  }

  /// Uploads encrypted byte payload to `appDataFolder`, overwriting existing file if present.
  static Future<DriveBackupMetadata> uploadEncryptedBackup({
    required GoogleSignInAccount user,
    required Uint8List bytes,
  }) async {
    final driveApi = await _getDriveApi(user);
    if (driveApi == null) {
      throw Exception('Failed to authenticate Google Drive HTTP client.');
    }

    final existing = await findBackupMetadata(user);
    final media = drive.Media(
      Stream.value(bytes),
      bytes.length,
    );

    if (existing != null) {
      // Overwrite existing file
      final updatedFile = await driveApi.files.update(
        drive.File()..modifiedTime = DateTime.now().toUtc(),
        existing.fileId,
        uploadMedia: media,
      );
      return DriveBackupMetadata(
        fileId: updatedFile.id ?? existing.fileId,
        modifiedTime: updatedFile.modifiedTime ?? DateTime.now(),
        sizeBytes: bytes.length,
      );
    } else {
      // Create new file inside appDataFolder
      final driveFile = drive.File()
        ..name = backupFileName
        ..parents = ['appDataFolder']
        ..description = 'Billwise Encrypted Database Backup';

      final createdFile = await driveApi.files.create(
        driveFile,
        uploadMedia: media,
      );

      return DriveBackupMetadata(
        fileId: createdFile.id ?? '',
        modifiedTime: createdFile.modifiedTime ?? DateTime.now(),
        sizeBytes: bytes.length,
      );
    }
  }

  /// Downloads encrypted backup payload bytes from `appDataFolder`.
  static Future<Uint8List> downloadEncryptedBackup({
    required GoogleSignInAccount user,
    required String fileId,
  }) async {
    final driveApi = await _getDriveApi(user);
    if (driveApi == null) {
      throw Exception('Failed to authenticate Google Drive HTTP client.');
    }

    final drive.Media media = await driveApi.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    final List<int> byteList = [];
    await for (final data in media.stream) {
      byteList.addAll(data);
    }

    return Uint8List.fromList(byteList);
  }
}
