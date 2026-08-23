// Items List screen — searchable product & service catalog with add/edit/delete
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../db/app_database.dart';
import '../../providers/items_provider.dart';
import '../../services/database_provider.dart';
import '../../utils/currency_formatter.dart';
import 'item_form_screen.dart';

class ItemsListScreen extends ConsumerStatefulWidget {
  const ItemsListScreen({super.key});

  @override
  ConsumerState<ItemsListScreen> createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends ConsumerState<ItemsListScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(itemSearchQueryProvider),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleDelete(BuildContext context, Item item) async {
    final docsDao = ref.read(documentsDaoProvider);
    final count = await docsDao.getDocumentCountForItem(item.id);

    if (!context.mounted) return;

    if (count > 0) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: Icon(Icons.warning_amber_rounded, size: 40, color: Theme.of(ctx).colorScheme.error),
          title: const Text('Cannot Delete Item'),
          content: Text(
            '${item.name} is used in $count document line item(s).\n\nYou cannot delete an item that is linked to existing invoices or estimates.',
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
          title: const Text('Delete Item?'),
          content: Text('Are you sure you want to delete ${item.name}?'),
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
        await ref.read(itemsDaoProvider).deleteItem(item.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${item.name} deleted'),
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
    final items = ref.watch(filteredItemsProvider);
    final asyncAllItems = ref.watch(itemsStreamProvider);
    final searchQuery = ref.watch(itemSearchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Items & Services'),
      ),
      body: Column(
        children: [
          // ── Search bar ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                ref.read(itemSearchQueryProvider.notifier).setQuery(val);
              },
              decoration: InputDecoration(
                hintText: 'Search items by name or HSN code...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(itemSearchQueryProvider.notifier).clear();
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // ── Item list ───────────────────────────────────────────────────
          Expanded(
            child: asyncAllItems.when(
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
                              color: cs.secondaryContainer.withAlpha(150),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.inventory_2_outlined, size: 48, color: AppColors.success),
                          ),
                          const SizedBox(height: 16),
                          Text('No Items in Catalog', style: theme.textTheme.titleLarge),
                          const SizedBox(height: 8),
                          Text(
                            'Add items or services with pre-set prices and GST rates for quick invoicing.',
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
                                  builder: (_) => const ItemFormScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Add First Item'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off_rounded, size: 48, color: cs.onSurface.withAlpha(100)),
                        const SizedBox(height: 12),
                        Text(
                          'No items found for "$searchQuery"',
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
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = items[index];
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
                              builder: (_) => ItemFormScreen(item: item),
                            ),
                          );
                        },
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: cs.primaryContainer.withAlpha(120),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.inventory_2_rounded, color: cs.primary, size: 22),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.name,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            if (item.hsnSacCode != null && item.hsnSacCode!.isNotEmpty) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: cs.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'HSN: ${item.hsnSacCode}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: cs.onSurface.withAlpha(160),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Text(
                                '${CurrencyFormatter.format(item.defaultPrice)} / ${item.defaultUnit}',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: cs.primary,
                                ),
                              ),
                              if (item.defaultTaxPercent != null && item.defaultTaxPercent! > 0) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withAlpha(20),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'GST ${item.defaultTaxPercent}%',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.success,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert_rounded, size: 20, color: cs.onSurface.withAlpha(140)),
                          onSelected: (val) {
                            if (val == 'edit') {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ItemFormScreen(item: item),
                                ),
                              );
                            } else if (val == 'delete') {
                              _handleDelete(context, item);
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
        heroTag: 'fab_add_item',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ItemFormScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Item'),
      ),
    );
  }
}
