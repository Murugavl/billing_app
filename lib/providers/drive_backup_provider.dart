// Riverpod provider for Encrypted Google Drive Backup & Restore state
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/background_backup_scheduler.dart';
import '../services/backup_repository.dart';
import '../services/database_provider.dart';
import '../services/drive_service.dart';

class DriveBackupState {
  final GoogleSignInAccount? user;
  final String frequency; // 'off', 'weekly', 'monthly'
  final DateTime? lastBackupDate;
  final int? lastBackupSize;
  final bool isBackingUp;
  final bool isRestoring;
  final String? statusMessage;
  final DriveBackupMetadata? existingRemoteBackup;

  const DriveBackupState({
    this.user,
    this.frequency = 'off',
    this.lastBackupDate,
    this.lastBackupSize,
    this.isBackingUp = false,
    this.isRestoring = false,
    this.statusMessage,
    this.existingRemoteBackup,
  });

  DriveBackupState copyWith({
    GoogleSignInAccount? user,
    bool clearUser = false,
    String? frequency,
    DateTime? lastBackupDate,
    int? lastBackupSize,
    bool? isBackingUp,
    bool? isRestoring,
    String? statusMessage,
    DriveBackupMetadata? existingRemoteBackup,
    bool clearRemoteBackup = false,
  }) {
    return DriveBackupState(
      user: clearUser ? null : (user ?? this.user),
      frequency: frequency ?? this.frequency,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
      lastBackupSize: lastBackupSize ?? this.lastBackupSize,
      isBackingUp: isBackingUp ?? this.isBackingUp,
      isRestoring: isRestoring ?? this.isRestoring,
      statusMessage: statusMessage ?? this.statusMessage,
      existingRemoteBackup: clearRemoteBackup
          ? null
          : (existingRemoteBackup ?? this.existingRemoteBackup),
    );
  }
}

class DriveBackupNotifier extends Notifier<DriveBackupState> {
  @override
  DriveBackupState build() {
    _init();
    return const DriveBackupState();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final freq = prefs.getString('drive_backup_frequency') ?? 'off';
    final dateStr = prefs.getString('last_drive_backup_date');
    final size = prefs.getInt('last_drive_backup_size');

    DateTime? lastDate;
    if (dateStr != null) {
      lastDate = DateTime.tryParse(dateStr);
    }

    final user = await DriveService.getSignedInUser();

    state = state.copyWith(
      user: user,
      frequency: freq,
      lastBackupDate: lastDate,
      lastBackupSize: size,
    );

    if (user != null) {
      await checkForRemoteBackup();
    }
  }

  Future<void> signIn() async {
    try {
      final user = await DriveService.signIn();
      if (user != null) {
        state = state.copyWith(user: user, statusMessage: 'Signed in successfully');
        await checkForRemoteBackup();
      }
    } catch (e) {
      state = state.copyWith(statusMessage: 'Google Sign-In failed: $e');
    }
  }

  Future<void> signOut() async {
    await DriveService.signOut();
    await BackgroundBackupScheduler.updateSchedule('off');
    state = state.copyWith(
      clearUser: true,
      frequency: 'off',
      clearRemoteBackup: true,
      statusMessage: 'Signed out of Google Drive',
    );
  }

  Future<void> setFrequency(String frequency) async {
    state = state.copyWith(frequency: frequency);
    await BackgroundBackupScheduler.updateSchedule(frequency);
  }

  Future<DriveBackupMetadata?> checkForRemoteBackup() async {
    if (state.user == null) return null;
    try {
      final meta = await DriveService.findBackupMetadata(state.user!);
      state = state.copyWith(existingRemoteBackup: meta);
      return meta;
    } catch (e) {
      return null;
    }
  }

  Future<bool> performManualBackup() async {
    if (state.user == null) {
      await signIn();
      if (state.user == null) return false;
    }

    state = state.copyWith(isBackingUp: true, statusMessage: 'Encrypting & uploading backup...');

    try {
      final db = ref.read(databaseProvider);
      final repo = BackupRepository(db);
      final meta = await repo.performDriveBackup(state.user!);

      state = state.copyWith(
        isBackingUp: false,
        lastBackupDate: meta.modifiedTime,
        lastBackupSize: meta.sizeBytes,
        existingRemoteBackup: meta,
        statusMessage: 'Backup completed successfully',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isBackingUp: false,
        statusMessage: 'Backup failed: $e',
      );
      return false;
    }
  }

  Future<bool> performRestore([String? fileId]) async {
    if (state.user == null) {
      await signIn();
      if (state.user == null) {
        if (state.statusMessage == null || !state.statusMessage!.contains('failed')) {
          state = state.copyWith(statusMessage: 'Please sign in with Google before restoring');
        }
        return false;
      }
    }

    String? targetFileId = fileId;
    if (targetFileId == null) {
      final meta = await checkForRemoteBackup();
      targetFileId = meta?.fileId;
    }

    if (targetFileId == null) {
      state = state.copyWith(statusMessage: 'No Google Drive backup found to restore');
      return false;
    }

    state = state.copyWith(isRestoring: true, statusMessage: 'Downloading & decrypting backup...');

    try {
      final db = ref.read(databaseProvider);
      final repo = BackupRepository(db);
      await repo.performDriveRestore(state.user!, targetFileId);

      state = state.copyWith(
        isRestoring: false,
        statusMessage: 'Data restored successfully!',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isRestoring: false,
        statusMessage: 'Restore failed: $e',
      );
      return false;
    }
  }
}

final driveBackupProvider =
    NotifierProvider<DriveBackupNotifier, DriveBackupState>(
  DriveBackupNotifier.new,
);
