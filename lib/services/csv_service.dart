// CSV Export Service — Generates and shares CSV files for accountant reports
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../db/app_database.dart';
import '../providers/reports_provider.dart';
import '../utils/date_formatter.dart';

class CsvService {
  /// Export Sales Report to CSV
  static Future<void> shareSalesReport(List<Document> invoices, String rangeLabel) async {
    final buffer = StringBuffer();
    buffer.writeln('Sales Report ($rangeLabel)');
    buffer.writeln('Invoice Number,Date,Customer Name,Customer GSTIN,Grand Total,Status');

    for (final doc in invoices) {
      final line = [
        '"${doc.documentNumber}"',
        '"${DateFormatter.display(doc.date)}"',
        '"${doc.customerName.replaceAll('"', '""')}"',
        '"${doc.customerGstNumber ?? ''}"',
        doc.grandTotal.toStringAsFixed(2),
        '"${doc.status}"',
      ].join(',');
      buffer.writeln(line);
    }

    await _shareCsvFile(buffer.toString(), 'sales_report_$rangeLabel.csv');
  }

  /// Export Purchase Report to CSV
  static Future<void> sharePurchaseReport(List<PurchaseBill> bills, String rangeLabel) async {
    final buffer = StringBuffer();
    buffer.writeln('Purchase Report ($rangeLabel)');
    buffer.writeln('Bill Number,Date,Supplier ID,Subtotal,Total Tax,Grand Total,Amount Paid,Balance Due,Status');

    for (final bill in bills) {
      final line = [
        '"${bill.billNumber}"',
        '"${DateFormatter.display(bill.date)}"',
        bill.supplierId,
        bill.subtotal.toStringAsFixed(2),
        bill.totalTax.toStringAsFixed(2),
        bill.grandTotal.toStringAsFixed(2),
        bill.amountPaid.toStringAsFixed(2),
        bill.balanceDue.toStringAsFixed(2),
        '"${bill.status}"',
      ].join(',');
      buffer.writeln(line);
    }

    await _shareCsvFile(buffer.toString(), 'purchase_report_$rangeLabel.csv');
  }

  /// Export Outstanding Payments Report to CSV
  static Future<void> shareOutstandingReport(List<OutstandingCustomerReport> report) async {
    final buffer = StringBuffer();
    buffer.writeln('Outstanding Payments Report');
    buffer.writeln('Customer Name,Phone,Unpaid Invoices Count,Total Outstanding (INR)');

    for (final item in report) {
      final line = [
        '"${item.customerName.replaceAll('"', '""')}"',
        '"${item.customerPhone ?? ''}"',
        item.unpaidInvoicesCount,
        item.totalOutstanding.toStringAsFixed(2),
      ].join(',');
      buffer.writeln(line);
    }

    await _shareCsvFile(buffer.toString(), 'outstanding_payments_report.csv');
  }

  /// Export Top Customers Report to CSV
  static Future<void> shareTopCustomersReport(List<CustomerRevenue> report) async {
    final buffer = StringBuffer();
    buffer.writeln('Top Customers Revenue Report');
    buffer.writeln('Customer Name,Phone,Invoices Count,Total Revenue (INR)');

    for (final item in report) {
      final line = [
        '"${item.customerName.replaceAll('"', '""')}"',
        '"${item.customerPhone ?? ''}"',
        item.invoiceCount,
        item.totalRevenue.toStringAsFixed(2),
      ].join(',');
      buffer.writeln(line);
    }

    await _shareCsvFile(buffer.toString(), 'top_customers_report.csv');
  }

  static Future<void> _shareCsvFile(String csvContent, String filename) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$filename');
    await file.writeAsString(csvContent);

    // ignore: deprecated_member_use
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Billing Report: $filename',
    );
  }
}
