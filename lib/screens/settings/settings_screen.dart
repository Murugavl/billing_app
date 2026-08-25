// Settings Screen — Business Profile editor & Data Safety / Local Backup settings
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/business_profile_provider.dart';
import '../../services/backup_service.dart';
import '../../services/database_provider.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/business_profile_form.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  DateTime? _lastBackupDate;

  @override
  void initState() {
    super.initState();
    _loadBackupDate();
  }

  Future<void> _loadBackupDate() async {
    final date = await BackupService.getLastBackupDate();
    setState(() => _lastBackupDate = date);
  }

  Future<void> _handleExportBackup() async {
    try {
      final db = ref.read(databaseProvider);
      await BackupService.exportAndShareBackup(db);
      await _loadBackupDate();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Backup exported successfully'),
            backgroundColor: Color(0xFF38A169),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e'), backgroundColor: Theme.of(context).colorScheme.error),
        );
      }
    }
  }

  Future<void> _handleRestoreBackup() async {
    final controller = TextEditingController();
    final restored = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.restore_rounded, color: AppColors.primaryBlue),
            const SizedBox(width: 8),
            Text('Restore Backup', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paste your backup JSON string below to restore all customers, items, invoices, estimates, and payment history.',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Paste {"app": "rasidhu"...} JSON here',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final jsonStr = controller.text.trim();
              if (jsonStr.isEmpty) return;
              try {
                final db = ref.read(databaseProvider);
                final ok = await BackupService.restoreFromBackupJson(db, jsonStr);
                if (ctx.mounted) Navigator.of(ctx).pop(ok);
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text('Restore error: $e')),
                  );
                }
              }
            },
            child: const Text('Restore Data'),
          ),
        ],
      ),
    );

    if (restored == true && mounted) {
      ref.invalidate(businessProfileProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All business data restored successfully'),
          backgroundColor: Color(0xFF38A169),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final profileAsync = ref.watch(businessProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Data Safety'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Data Backup & Safety Section ────────────────────────────────
            Text('DATA SAFETY & BACKUP', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: cs.primary)),
            const SizedBox(height: 8),

            Card(
              elevation: 0,
              color: cs.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: cs.outline.withAlpha(60)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shield_rounded, color: AppColors.success, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Offline-First Local Storage', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
                              Text(
                                _lastBackupDate == null
                                    ? 'No backup taken yet. Export now to keep your data safe.'
                                    : 'Last Backup: ${DateFormatter.full(_lastBackupDate!)}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: _handleExportBackup,
                            icon: const Icon(Icons.download_rounded, size: 16),
                            label: const Text('Export Backup File'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _handleRestoreBackup,
                            icon: const Icon(Icons.restore_rounded, size: 16),
                            label: const Text('Restore Backup'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Business Profile Form Section ───────────────────────────────
            Text('BUSINESS PROFILE & INVOICE DETAILS', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: cs.primary)),
            const SizedBox(height: 8),

            profileAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (profile) => BusinessProfileForm(
                initialData: profile,
                submitLabel: 'Save Changes',
                onSubmit: (companion) async {
                  final dao = ref.read(businessProfileDaoProvider);
                  await dao.upsertProfile(companion);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text('Business profile saved', style: GoogleFonts.inter(fontSize: 13)),
                          ],
                        ),
                        backgroundColor: const Color(0xFF38A169),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
