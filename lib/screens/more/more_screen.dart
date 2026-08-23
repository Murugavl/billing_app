// More tab — hub for Customers, Suppliers, Items, Settings, and app info
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/business_profile_provider.dart';
import '../reports/reports_screen.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final profileAsync = ref.watch(businessProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Business info card ────────────────────────────────────────────
          profileAsync.when(
            data: (profile) => _BusinessCard(
              businessName: profile?.businessName ?? 'Your Business',
              gstNumber: profile?.gstNumber,
              onEdit: () => context.push('/settings'),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 20),

          // ── Catalogue section ──────────────────────────────────────────────
          _SectionHeader('CATALOGUE & MASTERS'),
          const SizedBox(height: 8),
          _MenuTile(
            icon: Icons.people_rounded,
            label: 'Customers',
            subtitle: 'Manage customer directory',
            iconColor: const Color(0xFF3182CE),
            onTap: () => context.push('/customers'),
          ),
          _MenuTile(
            icon: Icons.storefront_rounded,
            label: 'Suppliers',
            subtitle: 'Manage supplier directory',
            iconColor: Colors.purple,
            onTap: () => context.push('/suppliers'),
          ),
          _MenuTile(
            icon: Icons.inventory_2_rounded,
            label: 'Items & Services',
            subtitle: 'Products and service catalogue',
            iconColor: const Color(0xFF38A169),
            onTap: () => context.push('/items'),
          ),
          const SizedBox(height: 20),

          // ── Analytics section ─────────────────────────────────────────────
          _SectionHeader('ANALYTICS & REPORTS'),
          const SizedBox(height: 8),
          _MenuTile(
            icon: Icons.analytics_rounded,
            label: 'Reports & Analytics',
            subtitle: 'Sales vs Purchases, supplier reports, CSV export',
            iconColor: const Color(0xFFD69E2E),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ReportsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // ── Data & Backup section ─────────────────────────────────────────
          _SectionHeader('DATA & CLOUD BACKUP'),
          const SizedBox(height: 8),
          _MenuTile(
            icon: Icons.cloud_done_rounded,
            label: 'Google Drive Backup',
            subtitle: 'Encrypted automatic cloud backup & restore',
            iconColor: Colors.teal,
            onTap: () => context.push('/settings/drive-backup'),
          ),
          const SizedBox(height: 20),

          // ── Business section ───────────────────────────────────────────────
          _SectionHeader('BUSINESS'),
          const SizedBox(height: 8),
          _MenuTile(
            icon: Icons.business_rounded,
            label: 'Business Profile',
            subtitle: 'Logo, GST, bank details',
            iconColor: const Color(0xFF1E3A5F),
            onTap: () => context.push('/settings'),
          ),
          const SizedBox(height: 20),

          // ── App section ────────────────────────────────────────────────────
          _SectionHeader('APP'),
          const SizedBox(height: 8),
          _MenuTile(
            icon: Icons.info_outline_rounded,
            label: 'About',
            subtitle: 'Billwise v1.0.0',
            iconColor: cs.onSurface.withAlpha(120),
            onTap: () => _showAbout(context),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Billwise',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2026 Billwise Invoicing',
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────────

class _BusinessCard extends StatelessWidget {
  const _BusinessCard({
    required this.businessName,
    required this.onEdit,
    this.gstNumber,
  });
  final String businessName;
  final String? gstNumber;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: cs.outline.withAlpha(80)),
      ),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.business_rounded,
                    size: 24, color: cs.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(businessName,
                        style: theme.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    if (gstNumber != null) ...[
                      const SizedBox(height: 2),
                      Text('GST: $gstNumber',
                          style: theme.textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: cs.onSurface.withAlpha(120)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: cs.onSurface.withAlpha(140),
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.iconColor,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.outline.withAlpha(60)),
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withAlpha(25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        title: Text(label, style: theme.textTheme.titleSmall),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurface.withAlpha(120),
          ),
        ),
        trailing: Icon(Icons.chevron_right_rounded,
            size: 18, color: cs.onSurface.withAlpha(100)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }
}
