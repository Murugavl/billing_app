// Restore Prompt Dialog shown when an existing Drive backup is found
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../providers/drive_backup_provider.dart';
import '../services/drive_service.dart';
import '../utils/date_formatter.dart';

class RestorePromptDialog extends ConsumerWidget {
  final DriveBackupMetadata backupMetadata;

  const RestorePromptDialog({super.key, required this.backupMetadata});

  static void checkAndShow(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(driveBackupProvider.notifier);
    final meta = await notifier.checkForRemoteBackup();

    if (meta != null && context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => RestorePromptDialog(backupMetadata: meta),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: const [
          Icon(Icons.cloud_download_rounded, color: AppColors.primaryBlue),
          SizedBox(width: 10),
          Text('Google Drive Backup Found'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'We found an encrypted backup from ${DateFormatter.display(backupMetadata.modifiedTime)} on your Google Drive account.',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          const Text(
            'Would you like to restore your customers, invoices, items, and purchase history now?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Skip'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            Navigator.pop(context);
            final success = await ref
                .read(driveBackupProvider.notifier)
                .performRestore(backupMetadata.fileId);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? 'Database restored successfully!'
                        : 'Failed to restore backup.',
                  ),
                ),
              );
            }
          },
          child: const Text('Restore Data'),
        ),
      ],
    );
  }
}
