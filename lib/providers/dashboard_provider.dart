// Dashboard statistics provider
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/database_provider.dart';

class DashboardStats {
  final double totalOutstanding;
  final double thisMonthSales;
  final int draftEstimatesCount;

  const DashboardStats({
    required this.totalOutstanding,
    required this.thisMonthSales,
    required this.draftEstimatesCount,
  });
}

final dashboardStatsProvider = StreamProvider<DashboardStats>((ref) {
  final db = ref.watch(databaseProvider);

  // Watch all documents to re-compute stats dynamically
  return (db.select(db.documents)).watch().map((documents) {
    final now = DateTime.now();

    double outstanding = 0.0;
    double monthSales = 0.0;
    int draftEstimates = 0;

    for (final doc in documents) {
      if (doc.type == 'invoice') {
        if (doc.status != 'paid') {
          outstanding += doc.balanceDue ?? 0.0;
        }
        if (doc.date.year == now.year && doc.date.month == now.month) {
          monthSales += doc.grandTotal;
        }
      } else if (doc.type == 'estimate') {
        if (doc.status == 'draft') {
          draftEstimates++;
        }
      }
    }

    return DashboardStats(
      totalOutstanding: double.parse(outstanding.toStringAsFixed(2)),
      thisMonthSales: double.parse(monthSales.toStringAsFixed(2)),
      draftEstimatesCount: draftEstimates,
    );
  });
});
