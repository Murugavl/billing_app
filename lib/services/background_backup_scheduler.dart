// Background Task Scheduler for Periodic Google Drive Backups using WorkManager
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../db/app_database.dart';
import 'backup_repository.dart';
import 'drive_service.dart';

const String driveBackupTaskName = 'billwise_google_drive_backup_task';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == driveBackupTaskName) {
      try {
        final user = await DriveService.getSignedInUser();
        if (user != null) {
          final db = AppDatabase();
          final repo = BackupRepository(db);
          await repo.performDriveBackup(user);
          await db.close();
        }
        return Future.value(true);
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Background backup execution failed: $e');
        }
        return Future.value(false);
      }
    }
    return Future.value(true);
  });
}

class BackgroundBackupScheduler {
  static Future<void> initialize() async {
    try {
      await Workmanager().initialize(
        callbackDispatcher,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('WorkManager init error: $e');
    }
  }

  static Future<void> updateSchedule(String frequency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('drive_backup_frequency', frequency);

    await Workmanager().cancelByUniqueName(driveBackupTaskName);

    if (frequency == 'weekly') {
      await Workmanager().registerPeriodicTask(
        driveBackupTaskName,
        driveBackupTaskName,
        frequency: const Duration(days: 7),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
      );
    } else if (frequency == 'monthly') {
      await Workmanager().registerPeriodicTask(
        driveBackupTaskName,
        driveBackupTaskName,
        frequency: const Duration(days: 30),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
      );
    }
  }
}
