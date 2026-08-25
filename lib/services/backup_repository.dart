// Backup Repository — Handles full JSON export/import and Google Drive backup/restore cycle
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/app_database.dart';
import 'drive_service.dart';
import 'encryption_service.dart';

class BackupRepository {
  final AppDatabase db;

  BackupRepository(this.db);

  /// Exports all 10 tables into a structured JSON payload string.
  Future<String> exportDatabaseToJson() async {
    final profile = await db.businessProfileDao.getProfile();
    final customers = await db.select(db.customers).get();
    final items = await db.select(db.items).get();
    final documents = await db.select(db.documents).get();
    final docLines = await db.select(db.documentLineItems).get();
    final payments = await db.select(db.payments).get();
    final suppliers = await db.select(db.suppliers).get();
    final purchaseBills = await db.select(db.purchaseBills).get();
    final purchaseLines = await db.select(db.purchaseLineItems).get();
    final purchasePayments = await db.select(db.purchasePayments).get();

    final Map<String, dynamic> exportMap = {
      'schemaVersion': 3,
      'app': 'Rasidhu',
      'exportedAt': DateTime.now().toIso8601String(),
      'businessProfile': profile == null
          ? null
          : {
              'id': profile.id,
              'businessName': profile.businessName,
              'addressLine': profile.addressLine,
              'phone': profile.phone,
              'email': profile.email,
              'panNumber': profile.panNumber,
              'gstNumber': profile.gstNumber,
              'bankName': profile.bankName,
              'bankAccountNo': profile.bankAccountNo,
              'bankIfsc': profile.bankIfsc,
              'bankBranchAddress': profile.bankBranchAddress,
              'logoPath': profile.logoPath,
              'signaturePath': profile.signaturePath,
              'updatedAt': profile.updatedAt.toIso8601String(),
            },
      'customers': customers
          .map((c) => {
                'id': c.id,
                'name': c.name,
                'phone': c.phone,
                'email': c.email,
                'address': c.address,
                'gstNumber': c.gstNumber,
                'createdAt': c.createdAt.toIso8601String(),
              })
          .toList(),
      'items': items
          .map((i) => {
                'id': i.id,
                'name': i.name,
                'hsnSacCode': i.hsnSacCode,
                'defaultUnit': i.defaultUnit,
                'defaultPrice': i.defaultPrice,
                'defaultTaxPercent': i.defaultTaxPercent,
                'createdAt': i.createdAt.toIso8601String(),
              })
          .toList(),
      'documents': documents
          .map((d) => {
                'id': d.id,
                'type': d.type,
                'documentNumber': d.documentNumber,
                'customerId': d.customerId,
                'customerName': d.customerName,
                'customerPhone': d.customerPhone,
                'customerAddress': d.customerAddress,
                'customerGstNumber': d.customerGstNumber,
                'date': d.date.toIso8601String(),
                'dueDate': d.dueDate?.toIso8601String(),
                'placeOfSupply': d.placeOfSupply,
                'subtotal': d.subtotal,
                'totalDiscount': d.totalDiscount,
                'totalTax': d.totalTax,
                'grandTotal': d.grandTotal,
                'amountReceived': d.amountReceived,
                'balanceDue': d.balanceDue,
                'amountInWords': d.amountInWords,
                'status': d.status,
                'notes': d.notes,
                'createdAt': d.createdAt.toIso8601String(),
                'updatedAt': d.updatedAt.toIso8601String(),
              })
          .toList(),
      'documentLineItems': docLines
          .map((l) => {
                'id': l.id,
                'documentId': l.documentId,
                'itemId': l.itemId,
                'itemName': l.itemName,
                'hsnSacCode': l.hsnSacCode,
                'quantity': l.quantity,
                'unit': l.unit,
                'pricePerUnit': l.pricePerUnit,
                'discountPercent': l.discountPercent,
                'discountAmount': l.discountAmount,
                'taxableAmount': l.taxableAmount,
                'taxPercent': l.taxPercent,
                'taxAmount': l.taxAmount,
                'lineTotal': l.lineTotal,
                'sortOrder': l.sortOrder,
              })
          .toList(),
      'payments': payments
          .map((p) => {
                'id': p.id,
                'documentId': p.documentId,
                'amount': p.amount,
                'date': p.date.toIso8601String(),
                'method': p.method,
                'notes': p.notes,
                'createdAt': p.createdAt.toIso8601String(),
              })
          .toList(),
      'suppliers': suppliers
          .map((s) => {
                'id': s.id,
                'name': s.name,
                'phone': s.phone,
                'address': s.address,
                'gstNumber': s.gstNumber,
                'createdAt': s.createdAt.toIso8601String(),
              })
          .toList(),
      'purchaseBills': purchaseBills
          .map((b) => {
                'id': b.id,
                'billNumber': b.billNumber,
                'supplierId': b.supplierId,
                'date': b.date.toIso8601String(),
                'subtotal': b.subtotal,
                'totalTax': b.totalTax,
                'grandTotal': b.grandTotal,
                'amountPaid': b.amountPaid,
                'balanceDue': b.balanceDue,
                'status': b.status,
                'notes': b.notes,
                'createdAt': b.createdAt.toIso8601String(),
              })
          .toList(),
      'purchaseLineItems': purchaseLines
          .map((pl) => {
                'id': pl.id,
                'purchaseBillId': pl.purchaseBillId,
                'itemId': pl.itemId,
                'itemName': pl.itemName,
                'hsnSacCode': pl.hsnSacCode,
                'quantity': pl.quantity,
                'unit': pl.unit,
                'pricePerUnit': pl.pricePerUnit,
                'taxAmount': pl.taxAmount,
                'lineTotal': pl.lineTotal,
              })
          .toList(),
      'purchasePayments': purchasePayments
          .map((pp) => {
                'id': pp.id,
                'purchaseBillId': pp.purchaseBillId,
                'amount': pp.amount,
                'date': pp.date.toIso8601String(),
                'method': pp.method,
                'notes': pp.notes,
              })
          .toList(),
    };

    return jsonEncode(exportMap);
  }

  /// Repopulates all 10 tables from a JSON string inside an atomic Drift transaction.
  Future<void> restoreDatabaseFromJson(String jsonString) async {
    final Map<String, dynamic> data = jsonDecode(jsonString);

    if (data['app'] != 'Rasidhu') {
      throw Exception('Invalid backup file — missing Rasidhu signature.');
    }

    await db.transaction(() async {
      // Clear existing records across all 10 tables
      await db.delete(db.purchasePayments).go();
      await db.delete(db.purchaseLineItems).go();
      await db.delete(db.purchaseBills).go();
      await db.delete(db.suppliers).go();
      await db.delete(db.payments).go();
      await db.delete(db.documentLineItems).go();
      await db.delete(db.documents).go();
      await db.delete(db.items).go();
      await db.delete(db.customers).go();
      await db.delete(db.businessProfile).go();

      // 1. Business Profile
      if (data['businessProfile'] != null) {
        final bp = data['businessProfile'];
        await db.into(db.businessProfile).insert(
              BusinessProfileCompanion(
                id: Value(bp['id'] ?? 1),
                businessName: Value(bp['businessName']),
                addressLine: Value(bp['addressLine']),
                phone: Value(bp['phone']),
                email: Value(bp['email']),
                panNumber: Value(bp['panNumber']),
                gstNumber: Value(bp['gstNumber']),
                bankName: Value(bp['bankName']),
                bankAccountNo: Value(bp['bankAccountNo']),
                bankIfsc: Value(bp['bankIfsc']),
                bankBranchAddress: Value(bp['bankBranchAddress']),
                logoPath: Value(bp['logoPath']),
                signaturePath: Value(bp['signaturePath']),
                updatedAt: Value(DateTime.parse(bp['updatedAt'])),
              ),
            );
      }

      // 2. Customers
      final List customers = data['customers'] ?? [];
      for (final c in customers) {
        await db.into(db.customers).insert(
              CustomersCompanion(
                id: Value(c['id']),
                name: Value(c['name']),
                phone: Value(c['phone']),
                email: Value(c['email']),
                address: Value(c['address']),
                gstNumber: Value(c['gstNumber']),
                createdAt: Value(DateTime.parse(c['createdAt'])),
              ),
            );
      }

      // 3. Items
      final List items = data['items'] ?? [];
      for (final i in items) {
        await db.into(db.items).insert(
              ItemsCompanion(
                id: Value(i['id']),
                name: Value(i['name']),
                hsnSacCode: Value(i['hsnSacCode']),
                defaultUnit: Value(i['defaultUnit'] ?? 'Pcs'),
                defaultPrice: Value((i['defaultPrice'] as num).toDouble()),
                defaultTaxPercent: Value((i['defaultTaxPercent'] as num?)?.toDouble()),
                createdAt: Value(DateTime.parse(i['createdAt'])),
              ),
            );
      }

      // 4. Documents
      final List documents = data['documents'] ?? [];
      for (final d in documents) {
        await db.into(db.documents).insert(
              DocumentsCompanion(
                id: Value(d['id']),
                type: Value(d['type']),
                documentNumber: Value(d['documentNumber']),
                customerId: Value(d['customerId']),
                customerName: Value(d['customerName']),
                customerPhone: Value(d['customerPhone']),
                customerAddress: Value(d['customerAddress']),
                customerGstNumber: Value(d['customerGstNumber']),
                date: Value(DateTime.parse(d['date'])),
                dueDate: Value(d['dueDate'] != null ? DateTime.parse(d['dueDate']) : null),
                placeOfSupply: Value(d['placeOfSupply']),
                subtotal: Value((d['subtotal'] as num).toDouble()),
                totalDiscount: Value((d['totalDiscount'] as num?)?.toDouble() ?? 0.0),
                totalTax: Value((d['totalTax'] as num?)?.toDouble() ?? 0.0),
                grandTotal: Value((d['grandTotal'] as num).toDouble()),
                amountReceived: Value((d['amountReceived'] as num?)?.toDouble() ?? 0.0),
                balanceDue: Value((d['balanceDue'] as num?)?.toDouble() ?? 0.0),
                amountInWords: Value(d['amountInWords']),
                status: Value(d['status']),
                notes: Value(d['notes']),
                createdAt: Value(DateTime.parse(d['createdAt'])),
                updatedAt: Value(DateTime.parse(d['updatedAt'] ?? d['createdAt'])),
              ),
            );
      }

      // 5. Document Line Items
      final List docLines = data['documentLineItems'] ?? [];
      for (final l in docLines) {
        await db.into(db.documentLineItems).insert(
              DocumentLineItemsCompanion(
                id: Value(l['id']),
                documentId: Value(l['documentId']),
                itemId: Value(l['itemId']),
                itemName: Value(l['itemName']),
                hsnSacCode: Value(l['hsnSacCode']),
                quantity: Value((l['quantity'] as num).toDouble()),
                unit: Value(l['unit'] ?? 'Pcs'),
                pricePerUnit: Value((l['pricePerUnit'] as num).toDouble()),
                discountPercent: Value((l['discountPercent'] as num?)?.toDouble() ?? 0.0),
                discountAmount: Value((l['discountAmount'] as num?)?.toDouble() ?? 0.0),
                taxableAmount: Value((l['taxableAmount'] as num?)?.toDouble() ?? 0.0),
                taxPercent: Value((l['taxPercent'] as num?)?.toDouble() ?? 0.0),
                taxAmount: Value((l['taxAmount'] as num?)?.toDouble() ?? 0.0),
                lineTotal: Value((l['lineTotal'] as num).toDouble()),
                sortOrder: Value(l['sortOrder'] ?? 0),
              ),
            );
      }

      // 6. Payments
      final List payments = data['payments'] ?? [];
      for (final p in payments) {
        await db.into(db.payments).insert(
              PaymentsCompanion(
                id: Value(p['id']),
                documentId: Value(p['documentId']),
                amount: Value((p['amount'] as num).toDouble()),
                date: Value(DateTime.parse(p['date'])),
                method: Value(p['method']),
                notes: Value(p['notes']),
                createdAt: Value(DateTime.parse(p['createdAt'])),
              ),
            );
      }

      // 7. Suppliers
      final List suppliers = data['suppliers'] ?? [];
      for (final s in suppliers) {
        await db.into(db.suppliers).insert(
              SuppliersCompanion(
                id: Value(s['id']),
                name: Value(s['name']),
                phone: Value(s['phone']),
                address: Value(s['address']),
                gstNumber: Value(s['gstNumber']),
                createdAt: Value(DateTime.parse(s['createdAt'])),
              ),
            );
      }

      // 8. Purchase Bills
      final List purchaseBills = data['purchaseBills'] ?? [];
      for (final b in purchaseBills) {
        await db.into(db.purchaseBills).insert(
              PurchaseBillsCompanion(
                id: Value(b['id']),
                billNumber: Value(b['billNumber']),
                supplierId: Value(b['supplierId']),
                date: Value(DateTime.parse(b['date'])),
                subtotal: Value((b['subtotal'] as num).toDouble()),
                totalTax: Value((b['totalTax'] as num).toDouble()),
                grandTotal: Value((b['grandTotal'] as num).toDouble()),
                amountPaid: Value((b['amountPaid'] as num?)?.toDouble() ?? 0.0),
                balanceDue: Value((b['balanceDue'] as num).toDouble()),
                status: Value(b['status']),
                notes: Value(b['notes']),
                createdAt: Value(DateTime.parse(b['createdAt'])),
              ),
            );
      }

      // 9. Purchase Line Items
      final List purchaseLines = data['purchaseLineItems'] ?? [];
      for (final pl in purchaseLines) {
        await db.into(db.purchaseLineItems).insert(
              PurchaseLineItemsCompanion(
                id: Value(pl['id']),
                purchaseBillId: Value(pl['purchaseBillId']),
                itemId: Value(pl['itemId']),
                itemName: Value(pl['itemName']),
                hsnSacCode: Value(pl['hsnSacCode']),
                quantity: Value((pl['quantity'] as num).toDouble()),
                unit: Value(pl['unit'] ?? 'Pcs'),
                pricePerUnit: Value((pl['pricePerUnit'] as num).toDouble()),
                taxAmount: Value((pl['taxAmount'] as num?)?.toDouble() ?? 0.0),
                lineTotal: Value((pl['lineTotal'] as num).toDouble()),
              ),
            );
      }

      // 10. Purchase Payments
      final List purchasePayments = data['purchasePayments'] ?? [];
      for (final pp in purchasePayments) {
        await db.into(db.purchasePayments).insert(
              PurchasePaymentsCompanion(
                id: Value(pp['id']),
                purchaseBillId: Value(pp['purchaseBillId']),
                amount: Value((pp['amount'] as num).toDouble()),
                date: Value(DateTime.parse(pp['date'])),
                method: Value(pp['method']),
                notes: Value(pp['notes']),
              ),
            );
      }
    });
  }

  /// Checks if the local database already contains user data.
  Future<bool> hasLocalData() async {
    final customers = await db.select(db.customers).get();
    final documents = await db.select(db.documents).get();
    final purchases = await db.select(db.purchaseBills).get();
    return customers.isNotEmpty || documents.isNotEmpty || purchases.isNotEmpty;
  }

  /// Perform complete encrypted backup pass to Google Drive.
  Future<DriveBackupMetadata> performDriveBackup(GoogleSignInAccount user) async {
    final jsonString = await exportDatabaseToJson();
    final encryptedBytes = EncryptionService.encryptJson(jsonString, user.id);

    final metadata = await DriveService.uploadEncryptedBackup(
      user: user,
      bytes: encryptedBytes,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_drive_backup_date', metadata.modifiedTime.toIso8601String());
    await prefs.setInt('last_drive_backup_size', metadata.sizeBytes);

    return metadata;
  }

  /// Perform complete encrypted restore pass from Google Drive.
  Future<void> performDriveRestore(GoogleSignInAccount user, String fileId) async {
    final encryptedBytes = await DriveService.downloadEncryptedBackup(
      user: user,
      fileId: fileId,
    );

    final decryptedJson = EncryptionService.decryptJson(encryptedBytes, user.id);
    await restoreDatabaseFromJson(decryptedJson);
  }
}
