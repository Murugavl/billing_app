// Data Safety & Local Backup Service
import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/app_database.dart';

class BackupService {
  static const String _keyLastBackup = 'last_backup_timestamp';

  /// Serializes all database tables to a single JSON string
  static Future<String> generateBackupJson(AppDatabase db) async {
    final profile = await db.businessProfileDao.getProfile();
    final customers = await db.customersDao.getAllCustomers();
    final items = await db.itemsDao.getAllItems();
    final docs = await db.documentsDao.getAllDocuments();
    final payments = await (db.select(db.payments)).get();

    final List<Map<String, dynamic>> lineItemsList = [];
    for (final doc in docs) {
      final docWithLines = await db.documentsDao.getDocumentWithLines(doc.id);
      if (docWithLines != null) {
        for (final line in docWithLines.lineItems) {
          lineItemsList.add({
            'id': line.id,
            'documentId': line.documentId,
            'itemId': line.itemId,
            'itemName': line.itemName,
            'hsnSacCode': line.hsnSacCode,
            'quantity': line.quantity,
            'unit': line.unit,
            'pricePerUnit': line.pricePerUnit,
            'discountPercent': line.discountPercent,
            'discountAmount': line.discountAmount,
            'taxableAmount': line.taxableAmount,
            'taxPercent': line.taxPercent,
            'taxAmount': line.taxAmount,
            'lineTotal': line.lineTotal,
            'sortOrder': line.sortOrder,
          });
        }
      }
    }

    final backupData = {
      'app': 'rasidhu',
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'businessProfile': profile == null ? null : {
        'id': profile.id,
        'businessName': profile.businessName,
        'addressLine': profile.addressLine,
        'phone': profile.phone,
        'email': profile.email,
        'panNumber': profile.panNumber,
        'gstNumber': profile.gstNumber,
        'logoPath': profile.logoPath,
        'signaturePath': profile.signaturePath,
        'bankName': profile.bankName,
        'bankAccountNo': profile.bankAccountNo,
        'bankIfsc': profile.bankIfsc,
        'bankBranchAddress': profile.bankBranchAddress,
      },
      'customers': customers.map((c) => {
        'id': c.id,
        'name': c.name,
        'phone': c.phone,
        'email': c.email,
        'address': c.address,
        'gstNumber': c.gstNumber,
        'createdAt': c.createdAt.toIso8601String(),
      }).toList(),
      'items': items.map((i) => {
        'id': i.id,
        'name': i.name,
        'hsnSacCode': i.hsnSacCode,
        'defaultUnit': i.defaultUnit,
        'defaultPrice': i.defaultPrice,
        'defaultTaxPercent': i.defaultTaxPercent,
        'createdAt': i.createdAt.toIso8601String(),
      }).toList(),
      'documents': docs.map((d) => {
        'id': d.id,
        'documentNumber': d.documentNumber,
        'type': d.type,
        'customerId': d.customerId,
        'customerName': d.customerName,
        'customerPhone': d.customerPhone,
        'customerAddress': d.customerAddress,
        'customerGstNumber': d.customerGstNumber,
        'date': d.date.toIso8601String(),
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
      }).toList(),
      'lineItems': lineItemsList,
      'payments': payments.map((p) => {
        'id': p.id,
        'documentId': p.documentId,
        'amount': p.amount,
        'date': p.date.toIso8601String(),
        'method': p.method,
        'notes': p.notes,
        'createdAt': p.createdAt.toIso8601String(),
      }).toList(),
    };

    return jsonEncode(backupData);
  }

  /// Exports backup JSON to file and invokes share_plus
  static Future<void> exportAndShareBackup(AppDatabase db) async {
    final jsonStr = await generateBackupJson(db);
    final dateSuffix = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
    final filename = 'rasidhu_backup_$dateSuffix.json';

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$filename');
    await file.writeAsString(jsonStr);

    // ignore: deprecated_member_use
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Rasidhu Data Backup ($filename)',
    );

    await recordBackupDone();
  }

  /// Restores entire database state from a backup JSON string
  static Future<bool> restoreFromBackupJson(AppDatabase db, String jsonStr) async {
    final Map<String, dynamic> data = jsonDecode(jsonStr);
    if (data['app'] != 'rasidhu' && data['app'] != 'Rasidhu' && data['app'] != 'ponsri_billing') {
      throw FormatException('Invalid backup payload file');
    }

    return db.transaction(() async {
      // 1. Clear existing database tables
      await (db.delete(db.payments)).go();
      await (db.delete(db.documentLineItems)).go();
      await (db.delete(db.documents)).go();
      await (db.delete(db.items)).go();
      await (db.delete(db.customers)).go();
      await (db.delete(db.businessProfile)).go();

      // 2. Restore Business Profile
      final prof = data['businessProfile'];
      if (prof != null) {
        await db.into(db.businessProfile).insert(
          BusinessProfileCompanion.insert(
            businessName: prof['businessName'],
            addressLine: Value(prof['addressLine']),
            phone: Value(prof['phone']),
            email: Value(prof['email']),
            panNumber: Value(prof['panNumber']),
            gstNumber: Value(prof['gstNumber']),
            logoPath: Value(prof['logoPath']),
            signaturePath: Value(prof['signaturePath']),
            bankName: Value(prof['bankName']),
            bankAccountNo: Value(prof['bankAccountNo']),
            bankIfsc: Value(prof['bankIfsc']),
            bankBranchAddress: Value(prof['bankBranchAddress']),
          ),
        );
      }

      // 3. Restore Customers
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

      // 4. Restore Items
      final List items = data['items'] ?? [];
      for (final i in items) {
        await db.into(db.items).insert(
          ItemsCompanion(
            id: Value(i['id']),
            name: Value(i['name']),
            hsnSacCode: Value(i['hsnSacCode']),
            defaultUnit: Value(i['defaultUnit']),
            defaultPrice: Value(i['defaultPrice']),
            defaultTaxPercent: Value(i['defaultTaxPercent']),
            createdAt: Value(DateTime.parse(i['createdAt'])),
          ),
        );
      }

      // 5. Restore Documents
      final List docs = data['documents'] ?? [];
      for (final d in docs) {
        await db.into(db.documents).insert(
          DocumentsCompanion(
            id: Value(d['id']),
            documentNumber: Value(d['documentNumber']),
            type: Value(d['type']),
            customerId: Value(d['customerId']),
            customerName: Value(d['customerName']),
            customerPhone: Value(d['customerPhone']),
            customerAddress: Value(d['customerAddress']),
            customerGstNumber: Value(d['customerGstNumber']),
            date: Value(DateTime.parse(d['date'])),
            placeOfSupply: Value(d['placeOfSupply']),
            subtotal: Value(d['subtotal']),
            totalDiscount: Value(d['totalDiscount']),
            totalTax: Value(d['totalTax']),
            grandTotal: Value(d['grandTotal']),
            amountReceived: Value(d['amountReceived']),
            balanceDue: Value(d['balanceDue']),
            amountInWords: Value(d['amountInWords']),
            status: Value(d['status']),
            notes: Value(d['notes']),
            createdAt: Value(DateTime.parse(d['createdAt'])),
            updatedAt: Value(DateTime.parse(d['updatedAt'])),
          ),
        );
      }

      // 6. Restore Document Line Items
      final List lineItems = data['lineItems'] ?? [];
      for (final l in lineItems) {
        await db.into(db.documentLineItems).insert(
          DocumentLineItemsCompanion(
            id: Value(l['id']),
            documentId: Value(l['documentId']),
            itemId: Value(l['itemId']),
            itemName: Value(l['itemName']),
            hsnSacCode: Value(l['hsnSacCode']),
            quantity: Value(l['quantity']),
            unit: Value(l['unit']),
            pricePerUnit: Value(l['pricePerUnit']),
            discountPercent: Value(l['discountPercent']),
            discountAmount: Value(l['discountAmount']),
            taxableAmount: Value(l['taxableAmount']),
            taxPercent: Value(l['taxPercent']),
            taxAmount: Value(l['taxAmount']),
            lineTotal: Value(l['lineTotal']),
            sortOrder: Value(l['sortOrder']),
          ),
        );
      }

      // 7. Restore Payments
      final List payments = data['payments'] ?? [];
      for (final p in payments) {
        await db.into(db.payments).insert(
          PaymentsCompanion(
            id: Value(p['id']),
            documentId: Value(p['documentId']),
            amount: Value(p['amount']),
            date: Value(DateTime.parse(p['date'])),
            method: Value(p['method']),
            notes: Value(p['notes']),
            createdAt: Value(DateTime.parse(p['createdAt'])),
          ),
        );
      }

      return true;
    });
  }

  static Future<void> recordBackupDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastBackup, DateTime.now().toIso8601String());
  }

  static Future<DateTime?> getLastBackupDate() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_keyLastBackup);
    if (str == null) return null;
    return DateTime.tryParse(str);
  }
}
