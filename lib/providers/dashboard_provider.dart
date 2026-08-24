// Dashboard statistics & Sales vs Purchases analytics provider
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/database_provider.dart';

enum DashboardDateRange { today, thisWeek, thisMonth, thisYear, all }

class DashboardDateRangeNotifier extends Notifier<DashboardDateRange> {
  @override
  DashboardDateRange build() => DashboardDateRange.thisMonth;

  void setDateRange(DashboardDateRange range) => state = range;
}

final dashboardDateRangeProvider =
    NotifierProvider<DashboardDateRangeNotifier, DashboardDateRange>(
  DashboardDateRangeNotifier.new,
);

class DashboardStats {
  final double totalOutstanding;
  final double totalSales;
  final double totalPurchases;
  final double netMargin;
  final int draftEstimatesCount;
  final DashboardDateRange dateRange;

  const DashboardStats({
    required this.totalOutstanding,
    required this.totalSales,
    required this.totalPurchases,
    required this.netMargin,
    required this.draftEstimatesCount,
    required this.dateRange,
  });
}

final dashboardStatsProvider = StreamProvider<DashboardStats>((ref) {
  final db = ref.watch(databaseProvider);
  final range = ref.watch(dashboardDateRangeProvider);

  final docsStream = db.select(db.documents).watch();
  final billsStream = db.select(db.purchaseBills).watch();

  return docsStream.asyncExpand((documents) {
    return billsStream.map((purchaseBills) {
      final now = DateTime.now();

      DateTime start = DateTime(2000);
      DateTime end = DateTime(2100);

      switch (range) {
        case DashboardDateRange.today:
          start = DateTime(now.year, now.month, now.day);
          end = DateTime(now.year, now.month, now.day, 23, 59, 59);
          break;
        case DashboardDateRange.thisWeek:
          final monday = now.subtract(Duration(days: now.weekday - 1));
          start = DateTime(monday.year, monday.month, monday.day);
          end = DateTime(now.year, now.month, now.day, 23, 59, 59);
          break;
        case DashboardDateRange.thisMonth:
          start = DateTime(now.year, now.month, 1);
          end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
          break;
        case DashboardDateRange.thisYear:
          start = DateTime(now.year, 1, 1);
          end = DateTime(now.year, 12, 31, 23, 59, 59);
          break;
        case DashboardDateRange.all:
          start = DateTime(2000);
          end = DateTime(2100);
          break;
      }

      double outstanding = 0.0;
      double salesSum = 0.0;
      int draftEstimates = 0;

      for (final doc in documents) {
        if (doc.type == 'invoice') {
          if (doc.status != 'paid') {
            outstanding += doc.balanceDue ?? 0.0;
          }
          if (doc.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
              doc.date.isBefore(end.add(const Duration(seconds: 1))) &&
              doc.status != 'cancelled') {
            salesSum += doc.grandTotal;
          }
        } else if (doc.type == 'estimate') {
          if (doc.status == 'draft') {
            draftEstimates++;
          }
        }
      }

      double purchasesSum = 0.0;
      for (final bill in purchaseBills) {
        if (bill.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
            bill.date.isBefore(end.add(const Duration(seconds: 1)))) {
          purchasesSum += bill.grandTotal;
        }
      }

      final margin = salesSum - purchasesSum;

      return DashboardStats(
        totalOutstanding: double.parse(outstanding.toStringAsFixed(2)),
        totalSales: double.parse(salesSum.toStringAsFixed(2)),
        totalPurchases: double.parse(purchasesSum.toStringAsFixed(2)),
        netMargin: double.parse(margin.toStringAsFixed(2)),
        draftEstimatesCount: draftEstimates,
        dateRange: range,
      );
    });
  });
});
