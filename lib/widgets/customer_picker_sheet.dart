// Customer Picker Sheet — Modal bottom sheet to pick or quick-add a customer
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/customers_provider.dart';
import '../screens/customers/customer_form_screen.dart';

class CustomerPickerSheet extends ConsumerStatefulWidget {
  const CustomerPickerSheet({super.key});

  @override
  ConsumerState<CustomerPickerSheet> createState() => _CustomerPickerSheetState();
}

class _CustomerPickerSheetState extends ConsumerState<CustomerPickerSheet> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(customerSearchQueryProvider),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final customers = ref.watch(filteredCustomersProvider);
    final searchQuery = ref.watch(customerSearchQueryProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: cs.outline.withAlpha(100),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Text(
                  'Select Customer',
                  style: theme.textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CustomerFormScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.person_add_rounded, size: 16),
                label: const Text('New Customer'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Search bar
          TextField(
            controller: _searchController,
            onChanged: (val) {
              ref.read(customerSearchQueryProvider.notifier).setQuery(val);
            },
            decoration: InputDecoration(
              hintText: 'Search customer by name or phone...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(customerSearchQueryProvider.notifier).clear();
                      },
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: customers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_search_rounded, size: 48, color: cs.onSurface.withAlpha(100)),
                        const SizedBox(height: 12),
                        Text(
                          searchQuery.isEmpty ? 'No customers in database' : 'No customers match "$searchQuery"',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const CustomerFormScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.person_add_rounded),
                          label: const Text('Add New Customer'),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: customers.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (ctx, idx) {
                      final c = customers[idx];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: cs.primaryContainer,
                          child: Text(
                            c.name.substring(0, 1).toUpperCase(),
                            style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: cs.primary),
                          ),
                        ),
                        title: Text(
                          c.name,
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          'Phone: ${c.phone ?? "N/A"}'
                          '${c.gstNumber != null ? " • GST: ${c.gstNumber}" : ""}',
                          style: theme.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => Navigator.of(context).pop(c),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
