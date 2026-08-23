// Riverpod providers for Reports & Analytics
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database.dart';
import '../services/database_provider.dart';

/// Date range filter enum for reports
enum ReportDateFilter { today, thisWeek, thisMonth, custom }

class DateRange {
  final DateTime start;
  final DateTime end;

  const DateRange(this.start, this.end);
}

class CustomerRevenue {
  final int customerId;
  final String customerName;
  final String? customerPhone;
  final double totalRevenue;
  final int invoiceCount;

  const CustomerRevenue({
    required this.customerId,
    required this.customerName,
    this.customerPhone,
    required this.totalRevenue,
    required this.invoiceCount,
  });
}

class ItemSalesSummary {
  final int? itemId;
  final String itemName;
  final double totalQuantity;
  final String unit;
  final double totalRevenue;

  const ItemSalesSummary({
    this.itemId,
    required this.itemName,
    required this.totalQuantity,
    required this.unit,
    required this.totalRevenue,
  });
}

class OutstandingCustomerReport {
  final int customerId;
  final String customerName;
  final String? customerPhone;
  final double totalOutstanding;
  final int unpaidInvoicesCount;

  const OutstandingCustomerReport({
    required this.customerId,
    required this.customerName,
    this.customerPhone,
    required this.totalOutstanding,
    required this.unpaidInvoicesCount,
  });
}

class SalesReportData {
  final double totalSales;
  final int invoiceCount;
  final double averageInvoiceValue;
  final List<Document> invoices;

  const SalesReportData({
    required this.totalSales,
    required this.invoiceCount,
    required this.averageInvoiceValue,
    required this.invoices,
  });
}

/// Provider for active date filter
class ReportDateFilterNotifier extends Notifier<ReportDateFilter> {
  @override
  ReportDateFilter build() => ReportDateFilter.thisMonth;

  void setFilter(ReportDateFilter filter) => state = filter;
}

final reportDateFilterProvider =
    NotifierProvider<ReportDateFilterNotifier, ReportDateFilter>(
  ReportDateFilterNotifier.new,
);

class ReportCustomDateRangeNotifier extends Notifier<DateRange?> {
  @override
  DateRange? build() => null;

  void setRange(DateRange? range) => state = range;
}

final reportCustomDateRangeProvider =
    NotifierProvider<ReportCustomDateRangeNotifier, DateRange?>(
  ReportCustomDateRangeNotifier.new,
);

/// Calculates active DateRange from filter
final activeDateRangeProvider = Provider<DateRange>((ref) {
  final filter = ref.watch(reportDateFilterProvider);
  final customRange = ref.watch(reportCustomDateRangeProvider);
  final now = DateTime.now();

  switch (filter) {
    case ReportDateFilter.today:
      final start = DateTime(now.year, now.month, now.day);
      final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
      return DateRange(start, end);
    case ReportDateFilter.thisWeek:
      final weekday = now.weekday;
      final start = DateTime(now.year, now.month, now.day).subtract(Duration(days: weekday - 1));
      final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
      return DateRange(start, end);
    case ReportDateFilter.thisMonth:
      final start = DateTime(now.year, now.month, 1);
      final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      return DateRange(start, end);
    case ReportDateFilter.custom:
      if (customRange != null) return customRange;
      final start = DateTime(now.year, now.month, 1);
      final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      return DateRange(start, end);
  }
});

/// Sales Report Provider
final salesReportProvider = FutureProvider<SalesReportData>((ref) async {
  final docsDao = ref.watch(documentsDaoProvider);
  final range = ref.watch(activeDateRangeProvider);

  final invoices = await docsDao.getDocumentsByType('invoice');
  final filtered = invoices.where((doc) {
    return doc.date.isAfter(range.start.subtract(const Duration(seconds: 1))) &&
        doc.date.isBefore(range.end.add(const Duration(seconds: 1)));
  }).toList();

  double totalSales = 0.0;
  for (final doc in filtered) {
    totalSales += doc.grandTotal;
  }

  final count = filtered.length;
  final avg = count > 0 ? totalSales / count : 0.0;

  return SalesReportData(
    totalSales: double.parse(totalSales.toStringAsFixed(2)),
    invoiceCount: count,
    averageInvoiceValue: double.parse(avg.toStringAsFixed(2)),
    invoices: filtered,
  );
});

/// Top Customers by Revenue Provider
final topCustomersProvider = FutureProvider<List<CustomerRevenue>>((ref) async {
  final docsDao = ref.watch(documentsDaoProvider);
  final invoices = await docsDao.getDocumentsByType('invoice');

  final Map<int, CustomerRevenue> map = {};
  for (final doc in invoices) {
    if (doc.customerId == null) continue;
    final id = doc.customerId!;
    final existing = map[id];

    if (existing == null) {
      map[id] = CustomerRevenue(
        customerId: id,
        customerName: doc.customerName,
        customerPhone: doc.customerPhone,
        totalRevenue: doc.grandTotal,
        invoiceCount: 1,
      );
    } else {
      map[id] = CustomerRevenue(
        customerId: id,
        customerName: doc.customerName,
        customerPhone: doc.customerPhone,
        totalRevenue: double.parse((existing.totalRevenue + doc.grandTotal).toStringAsFixed(2)),
        invoiceCount: existing.invoiceCount + 1,
      );
    }
  }

  final list = map.values.toList();
  list.sort((a, b) => b.totalRevenue.compareTo(a.totalRevenue));
  return list;
});

/// Outstanding Payments Report Provider (sorted highest balance due first)
final outstandingReportProvider = FutureProvider<List<OutstandingCustomerReport>>((ref) async {
  final docsDao = ref.watch(documentsDaoProvider);
  final invoices = await docsDao.getDocumentsByType('invoice');

  final Map<int, OutstandingCustomerReport> map = {};
  for (final doc in invoices) {
    if (doc.status == 'paid' || doc.customerId == null) continue;
    final due = doc.balanceDue ?? 0.0;
    if (due <= 0) continue;

    final id = doc.customerId!;
    final existing = map[id];

    if (existing == null) {
      map[id] = OutstandingCustomerReport(
        customerId: id,
        customerName: doc.customerName,
        customerPhone: doc.customerPhone,
        totalOutstanding: due,
        unpaidInvoicesCount: 1,
      );
    } else {
      map[id] = OutstandingCustomerReport(
        customerId: id,
        customerName: doc.customerName,
        customerPhone: doc.customerPhone,
        totalOutstanding: double.parse((existing.totalOutstanding + due).toStringAsFixed(2)),
        unpaidInvoicesCount: existing.unpaidInvoicesCount + 1,
      );
    }
  }

  final list = map.values.toList();
  list.sort((a, b) => b.totalOutstanding.compareTo(a.totalOutstanding));
  return list;
});
