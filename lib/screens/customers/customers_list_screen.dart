// Customers List screen — searchable customer list with add/edit/delete
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../db/app_database.dart';
import '../../providers/customers_provider.dart';
import '../../services/database_provider.dart';
import 'customer_detail_screen.dart';
import 'customer_form_screen.dart';

class CustomersListScreen extends ConsumerStatefulWidget {
  const CustomersListScreen({super.key});

  @override
  ConsumerState<CustomersListScreen> createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends ConsumerState<CustomersListScreen> {
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

  Future<void> _handleDelete(BuildContext context, Customer customer) async {
    final docsDao = ref.read(documentsDaoProvider);
    final count = await docsDao.getDocumentCountForCustomer(customer.id);

    if (!context.mounted) return;

    if (count > 0) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: Icon(Icons.warning_amber_rounded, size: 40, color: Theme.of(ctx).colorScheme.error),
          title: const Text('Cannot Delete Customer'),
          content: Text(
            '${customer.name} has $count document(s) associated with them.\n\nYou cannot delete this customer while documents exist.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete Customer?'),
          content: Text('Are you sure you want to delete ${customer.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmed == true && context.mounted) {
        await ref.read(customersDaoProvider).deleteCustomer(customer.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${customer.name} deleted'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final customers = ref.watch(filteredCustomersProvider);
    final asyncAllCustomers = ref.watch(customersStreamProvider);
    final searchQuery = ref.watch(customerSearchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
      ),
      body: Column(
        children: [
          // ── Search bar ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                ref.read(customerSearchQueryProvider.notifier).setQuery(val);
              },
              decoration: InputDecoration(
                hintText: 'Search by name, phone, email, GST...',
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // ── Customer list ───────────────────────────────────────────────
          Expanded(
            child: asyncAllCustomers.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (allList) {
                if (allList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: cs.primaryContainer.withAlpha(100),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.people_outline_rounded, size: 48, color: cs.primary),
                          ),
                          const SizedBox(height: 16),
                          Text('No Customers Yet', style: theme.textTheme.titleLarge),
                          const SizedBox(height: 8),
                          Text(
                            'Add customers to easily issue invoices and estimates.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurface.withAlpha(140),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const CustomerFormScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.person_add_rounded),
                            label: const Text('Add First Customer'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (customers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off_rounded, size: 48, color: cs.onSurface.withAlpha(100)),
                        const SizedBox(height: 12),
                        Text(
                          'No customers found for "$searchQuery"',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: cs.onSurface.withAlpha(160),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                  itemCount: customers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: cs.outline.withAlpha(60)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CustomerDetailScreen(customerId: customer.id),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundColor: cs.primaryContainer,
                          child: Text(
                            customer.name.substring(0, 1).toUpperCase(),
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              color: cs.primary,
                            ),
                          ),
                        ),
                        title: Text(
                          customer.name,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 2),
                            if (customer.phone != null && customer.phone!.isNotEmpty)
                              Text(customer.phone!, style: theme.textTheme.bodySmall),
                            if (customer.gstNumber != null && customer.gstNumber!.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                'GSTIN: ${customer.gstNumber}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert_rounded, size: 20, color: cs.onSurface.withAlpha(140)),
                          onSelected: (val) {
                            if (val == 'edit') {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CustomerFormScreen(customer: customer),
                                ),
                              );
                            } else if (val == 'delete') {
                              _handleDelete(context, customer);
                            }
                          },
                          itemBuilder: (ctx) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit_outlined, size: 18),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline, size: 18, color: cs.error),
                                  const SizedBox(width: 8),
                                  Text('Delete', style: TextStyle(color: cs.error)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_add_customer',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const CustomerFormScreen(),
            ),
          );
        },
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add Customer'),
      ),
    );
  }
}
