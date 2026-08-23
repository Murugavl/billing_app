// Riverpod providers for database + all DAOs
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database.dart';
import '../db/daos/business_profile_dao.dart';
import '../db/daos/customers_dao.dart';
import '../db/daos/items_dao.dart';
import '../db/daos/documents_dao.dart';
import '../db/daos/payments_dao.dart';
import '../db/daos/suppliers_dao.dart';
import '../db/daos/purchase_bills_dao.dart';

/// Singleton AppDatabase — disposed when ProviderScope is torn down.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final businessProfileDaoProvider = Provider<BusinessProfileDao>((ref) =>
    ref.watch(databaseProvider).businessProfileDao);

final customersDaoProvider = Provider<CustomersDao>((ref) =>
    ref.watch(databaseProvider).customersDao);

final itemsDaoProvider = Provider<ItemsDao>((ref) =>
    ref.watch(databaseProvider).itemsDao);

final documentsDaoProvider = Provider<DocumentsDao>((ref) =>
    ref.watch(databaseProvider).documentsDao);

final paymentsDaoProvider = Provider<PaymentsDao>((ref) =>
    ref.watch(databaseProvider).paymentsDao);

final suppliersDaoProvider = Provider<SuppliersDao>((ref) =>
    ref.watch(databaseProvider).suppliersDao);

final purchaseBillsDaoProvider = Provider<PurchaseBillsDao>((ref) =>
    ref.watch(databaseProvider).purchaseBillsDao);
