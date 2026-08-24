// Global Search Screen — Instant search across Customers, Invoices, and Estimates
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../db/app_database.dart';
import '../../services/database_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';
import '../customers/customer_detail_screen.dart';
import '../invoices/invoice_detail_screen.dart';
import '../pdf/pdf_preview_screen.dart';

class GlobalSearchScreen extends ConsumerStatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  ConsumerState<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends ConsumerState<GlobalSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  List<Customer> _matchingCustomers = [];
  List<Document> _matchingInvoices = [];
  List<Document> _matchingEstimates = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    final q = query.trim().toLowerCase();
    setState(() => _query = q);

    if (q.isEmpty) {
      setState(() {
        _matchingCustomers = [];
        _matchingInvoices = [];
        _matchingEstimates = [];
      });
      return;
    }

    setState(() => _isSearching = true);
    final custDao = ref.read(customersDaoProvider);
    final docsDao = ref.read(documentsDaoProvider);

    final customers = await custDao.searchCustomers(q);
    final invoices = await docsDao.getDocumentsByType('invoice');
    final estimates = await docsDao.getDocumentsByType('estimate');

    final matchInv = invoices.where((doc) {
      return doc.documentNumber.toLowerCase().contains(q) ||
          doc.customerName.toLowerCase().contains(q) ||
          (doc.customerPhone != null && doc.customerPhone!.contains(q));
    }).toList();

    final matchEst = estimates.where((doc) {
      return doc.documentNumber.toLowerCase().contains(q) ||
          doc.customerName.toLowerCase().contains(q) ||
          (doc.customerPhone != null && doc.customerPhone!.contains(q));
    }).toList();

    if (mounted) {
      setState(() {
        _matchingCustomers = customers;
        _matchingInvoices = matchInv;
        _matchingEstimates = matchEst;
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final totalResults = _matchingCustomers.length + _matchingInvoices.length + _matchingEstimates.length;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: _performSearch,
          decoration: InputDecoration(
            hintText: 'Search customers, invoices, estimates...',
            border: InputBorder.none,
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      _controller.clear();
                      _performSearch('');
                    },
                  )
                : null,
          ),
        ),
      ),
      body: _query.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search_rounded, size: 64, color: cs.onSurface.withAlpha(80)),
                  const SizedBox(height: 12),
                  Text(
                    'Search anything across your business',
                    style: theme.textTheme.titleMedium?.copyWith(color: cs.onSurface.withAlpha(140)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Type customer name, phone number, invoice #, or estimate #',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            )
          : _isSearching
              ? const Center(child: CircularProgressIndicator())
              : totalResults == 0
                  ? Center(
                      child: Text(
                        'No results found for "$_query"',
                        style: theme.textTheme.titleMedium?.copyWith(color: cs.onSurface.withAlpha(140)),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // ── Customers Section ──────────────────────────────
                        if (_matchingCustomers.isNotEmpty) ...[
                          _SectionHeader(title: 'CUSTOMERS (${_matchingCustomers.length})', icon: Icons.people_rounded),
                          const SizedBox(height: 6),
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: cs.outline.withAlpha(60)),
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _matchingCustomers.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (ctx, idx) {
                                final cust = _matchingCustomers[idx];
                                return ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => CustomerDetailScreen(customerId: cust.id),
                                      ),
                                    );
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: cs.primaryContainer,
                                    child: Icon(Icons.person_rounded, color: cs.primary, size: 20),
                                  ),
                                  title: Text(cust.name, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                                  subtitle: Text(cust.phone ?? cust.email ?? 'No contact info'),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 18),
                        ],

                        // ── Invoices Section ───────────────────────────────
                        if (_matchingInvoices.isNotEmpty) ...[
                          _SectionHeader(title: 'INVOICES (${_matchingInvoices.length})', icon: Icons.receipt_long_rounded),
                          const SizedBox(height: 6),
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: cs.outline.withAlpha(60)),
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _matchingInvoices.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (ctx, idx) {
                                final doc = _matchingInvoices[idx];
                                return ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => InvoiceDetailScreen(documentId: doc.id),
                                      ),
                                    );
                                  },
                                  title: Row(
                                    children: [
                                      Expanded(child: Text(doc.documentNumber, style: GoogleFonts.inter(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                                      const SizedBox(width: 8),
                                      Text(CurrencyFormatter.format(doc.grandTotal), style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  subtitle: Text('${doc.customerName} • ${DateFormatter.display(doc.date)}', maxLines: 1, overflow: TextOverflow.ellipsis),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 18),
                        ],

                        // ── Estimates Section ──────────────────────────────
                        if (_matchingEstimates.isNotEmpty) ...[
                          _SectionHeader(title: 'ESTIMATES (${_matchingEstimates.length})', icon: Icons.description_rounded),
                          const SizedBox(height: 6),
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: cs.outline.withAlpha(60)),
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _matchingEstimates.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (ctx, idx) {
                                final doc = _matchingEstimates[idx];
                                return ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => PdfPreviewScreen(documentId: doc.id),
                                      ),
                                    );
                                  },
                                  title: Row(
                                    children: [
                                      Expanded(child: Text(doc.documentNumber, style: GoogleFonts.inter(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                                      const SizedBox(width: 8),
                                      Text(CurrencyFormatter.format(doc.grandTotal), style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  subtitle: Text('${doc.customerName} • ${DateFormatter.display(doc.date)}', maxLines: 1, overflow: TextOverflow.ellipsis),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 16, color: cs.primary),
        const SizedBox(width: 6),
        Text(
          title,
          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: cs.primary),
        ),
      ],
    );
  }
}
