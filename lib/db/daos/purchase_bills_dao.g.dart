// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_bills_dao.dart';

// ignore_for_file: type=lint
mixin _$PurchaseBillsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SuppliersTable get suppliers => attachedDatabase.suppliers;
  $PurchaseBillsTable get purchaseBills => attachedDatabase.purchaseBills;
  $ItemsTable get items => attachedDatabase.items;
  $PurchaseLineItemsTable get purchaseLineItems =>
      attachedDatabase.purchaseLineItems;
  $PurchasePaymentsTable get purchasePayments =>
      attachedDatabase.purchasePayments;
  $DocumentsTable get documents => attachedDatabase.documents;
  PurchaseBillsDaoManager get managers => PurchaseBillsDaoManager(this);
}

class PurchaseBillsDaoManager {
  final _$PurchaseBillsDaoMixin _db;
  PurchaseBillsDaoManager(this._db);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db.attachedDatabase, _db.suppliers);
  $$PurchaseBillsTableTableManager get purchaseBills =>
      $$PurchaseBillsTableTableManager(_db.attachedDatabase, _db.purchaseBills);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db.attachedDatabase, _db.items);
  $$PurchaseLineItemsTableTableManager get purchaseLineItems =>
      $$PurchaseLineItemsTableTableManager(
          _db.attachedDatabase, _db.purchaseLineItems);
  $$PurchasePaymentsTableTableManager get purchasePayments =>
      $$PurchasePaymentsTableTableManager(
          _db.attachedDatabase, _db.purchasePayments);
  $$DocumentsTableTableManager get documents =>
      $$DocumentsTableTableManager(_db.attachedDatabase, _db.documents);
}
