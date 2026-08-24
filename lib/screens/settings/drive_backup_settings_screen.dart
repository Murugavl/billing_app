// ignore_for_file: deprecated_member_use
// Google Drive Backup Settings Screen — Manage AES-256 Encrypted Backups
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/drive_backup_provider.dart';
import '../../services/backup_repository.dart';
import '../../services/database_provider.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/section_card.dart';

class DriveBackupSettingsScreen extends ConsumerWidget {
  const DriveBackupSettingsScreen({super.key});

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  void _showRestoreConfirmation(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final repo = BackupRepository(db);
    final hasData = await repo.hasLocalData();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore from Google Drive?'),
        content: Text(
          hasData
              ? 'WARNING: Restoring will overwrite all existing local invoices, customers, and purchase data with the backup from Google Drive. Are you sure you want to proceed?'
              : 'This will download and restore your encrypted database from Google Drive.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: hasData ? Colors.red : AppColors.primaryBlue,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final success =
                  await ref.read(driveBackupProvider.notifier).performRestore();
              if (context.mounted) {
                final statusMsg = ref.read(driveBackupProvider).statusMessage;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Database restored successfully!'
                          : (statusMsg ?? 'Restore failed.'),
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text('Restore Data'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(driveBackupProvider);
    final notifier = ref.read(driveBackupProvider.notifier);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Drive Backup'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Encryption Security Badge ─────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.security, color: Colors.green, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'End-to-End AES-256 Encrypted',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Backups are stored in Drive appDataFolder (private to you). Nobody else, including Google or Billwise, can read your business data.',
                          style: TextStyle(fontSize: 11, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── 1. Google Account Card ─────────────────────────────────────────
            SectionCard(
              title: 'Google Account',
              icon: Icons.account_circle_outlined,
              children: [
                state.user == null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sign in with your Google account to enable automatic cloud backups.',
                            style: TextStyle(fontSize: 13),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () => notifier.signIn(),
                            icon: const Icon(Icons.login),
                            label: const Text('Sign in with Google'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: cs.primaryContainer,
                            child: Text(
                              state.user!.email[0].toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: cs.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.user!.displayName ?? 'Google User',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  state.user!.email,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: cs.onSurface.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () => notifier.signOut(),
                            child: const Text('Sign Out', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
              ],
            ),

            const SizedBox(height: 16),

            // ── 2. Backup Frequency Selector ──────────────────────────────────
            SectionCard(
              title: 'Auto Backup Schedule',
              icon: Icons.schedule_rounded,
              children: [
                RadioListTile<String>(
                  title: const Text('Off'),
                  subtitle: const Text('Manual backups only'),
                  value: 'off',
                  groupValue: state.frequency,
                  onChanged: state.user == null
                      ? null
                      : (val) => notifier.setFrequency(val!),
                ),
                RadioListTile<String>(
                  title: const Text('Weekly'),
                  subtitle: const Text('Back up automatically once a week over Wi-Fi/data'),
                  value: 'weekly',
                  groupValue: state.frequency,
                  onChanged: state.user == null
                      ? null
                      : (val) => notifier.setFrequency(val!),
                ),
                RadioListTile<String>(
                  title: const Text('Monthly'),
                  subtitle: const Text('Back up automatically once a month'),
                  value: 'monthly',
                  groupValue: state.frequency,
                  onChanged: state.user == null
                      ? null
                      : (val) => notifier.setFrequency(val!),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── 3. Last Backup Status & Manual Actions ────────────────────────
            SectionCard(
              title: 'Backup Status & Actions',
              icon: Icons.cloud_done_outlined,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Last Cloud Backup:'),
                    Text(
                      state.lastBackupDate != null
                          ? DateFormatter.display(state.lastBackupDate!)
                          : 'Never',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Backup File Size:'),
                    Text(
                      state.lastBackupSize != null
                          ? _formatBytes(state.lastBackupSize!)
                          : 'N/A',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: (state.isBackingUp || state.isRestoring)
                            ? null
                            : () => notifier.performManualBackup(),
                        icon: state.isBackingUp
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.cloud_upload_outlined),
                        label: Text(state.isBackingUp ? 'Backing Up...' : 'Back up now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: (state.isBackingUp || state.isRestoring)
                            ? null
                            : () => _showRestoreConfirmation(context, ref),
                        icon: state.isRestoring
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.cloud_download_outlined),
                        label: Text(state.isRestoring ? 'Restoring...' : 'Restore from Drive'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            if (state.statusMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: state.statusMessage!.toLowerCase().contains('failed') ||
                          state.statusMessage!.toLowerCase().contains('error')
                      ? Colors.red.withValues(alpha: 0.1)
                      : cs.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: state.statusMessage!.toLowerCase().contains('failed') ||
                            state.statusMessage!.toLowerCase().contains('error')
                        ? Colors.red.withValues(alpha: 0.3)
                        : cs.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  state.statusMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: state.statusMessage!.toLowerCase().contains('failed') ||
                            state.statusMessage!.toLowerCase().contains('error')
                        ? Colors.red.shade800
                        : cs.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
