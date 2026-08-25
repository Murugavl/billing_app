// PDF Generation Service for Invoices and Estimates — Noto Sans Unicode & Proportional Logo Box
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../db/app_database.dart';
import '../db/daos/documents_dao.dart';
import '../utils/currency_formatter.dart';
import '../utils/date_formatter.dart';
import '../utils/number_to_words.dart';

class PdfService {
  /// Loads Noto Sans TTF font supporting Unicode U+20B9 (₹ Rupee symbol)
  static Future<pw.Font> _loadFont(String assetPath, {required bool isBold}) async {
    try {
      final byteData = await rootBundle.load(assetPath);
      return pw.Font.ttf(byteData);
    } catch (_) {
      try {
        final file = File(assetPath);
        if (file.existsSync()) {
          final bytes = file.readAsBytesSync();
          return pw.Font.ttf(bytes.buffer.asByteData());
        }
      } catch (_) {}
      return isBold ? pw.Font.helveticaBold() : pw.Font.helvetica();
    }
  }

  /// Generates a PDF byte array for a given DocumentWithLines and BusinessProfile
  static Future<Uint8List> generateDocumentPdf({
    required DocumentWithLines documentWithLines,
    required BusinessProfileData? profile,
  }) async {
    final ttfRegular = await _loadFont('assets/fonts/NotoSans-Regular.ttf', isBold: false);
    final ttfBold = await _loadFont('assets/fonts/NotoSans-Bold.ttf', isBold: true);

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: ttfRegular,
        bold: ttfBold,
      ),
    );

    final doc = documentWithLines.document;
    final lines = documentWithLines.lineItems;
    final isInvoice = doc.type == 'invoice';

    // Theme colors
    final primaryColor = isInvoice ? PdfColor.fromHex('#1E3A5F') : PdfColor.fromHex('#D69E2E');
    final headerBgColor = isInvoice ? PdfColor.fromHex('#1E3A5F') : PdfColor.fromHex('#B7791F');
    final tableHeaderTextColor = PdfColors.white;

    // Load logo image if present
    pw.MemoryImage? logoImage;
    if (profile?.logoPath != null && File(profile!.logoPath!).existsSync()) {
      try {
        final bytes = File(profile.logoPath!).readAsBytesSync();
        logoImage = pw.MemoryImage(bytes);
      } catch (_) {}
    }

    // Load signature image if present
    pw.MemoryImage? signatureImage;
    if (profile?.signaturePath != null && File(profile!.signaturePath!).existsSync()) {
      try {
        final bytes = File(profile.signaturePath!).readAsBytesSync();
        signatureImage = pw.MemoryImage(bytes);
      } catch (_) {}
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          // ── Company Header & Document Title ─────────────────────────────────
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (logoImage != null) ...[
                pw.ConstrainedBox(
                  constraints: const pw.BoxConstraints(
                    maxHeight: 65,
                    maxWidth: 140,
                  ),
                  child: pw.Image(
                    logoImage,
                    fit: pw.BoxFit.contain,
                  ),
                ),
                pw.SizedBox(width: 14),
              ],
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      profile?.businessName ?? 'My Business',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    if (profile?.addressLine != null)
                      pw.Text(profile!.addressLine!, style: const pw.TextStyle(fontSize: 9)),
                    if (profile?.phone != null)
                      pw.Text('Phone: ${profile!.phone!}', style: const pw.TextStyle(fontSize: 9)),
                    if (profile?.email != null)
                      pw.Text('Email: ${profile!.email!}', style: const pw.TextStyle(fontSize: 9)),
                    if (profile?.gstNumber != null)
                      pw.Text('GSTIN: ${profile!.gstNumber!}', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: pw.BoxDecoration(
                      color: primaryColor,
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Text(
                      isInvoice ? 'TAX INVOICE' : 'ESTIMATE / QUOTATION',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    '${isInvoice ? "Invoice No:" : "Estimate No:"} ${doc.documentNumber}',
                    style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text('Date: ${DateFormatter.display(doc.date)}', style: const pw.TextStyle(fontSize: 9)),
                  if (doc.placeOfSupply != null)
                    pw.Text('Place of Supply: ${doc.placeOfSupply!}', style: const pw.TextStyle(fontSize: 9)),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 16),
          pw.Divider(thickness: 1, color: PdfColors.grey300),
          pw.SizedBox(height: 12),

          // ── Bill To / Customer Details Block ────────────────────────────────
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(6),
              border: pw.Border.all(color: PdfColors.grey300),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        isInvoice ? 'BILL TO:' : 'ESTIMATE FOR:',
                        style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: primaryColor),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(doc.customerName, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                      if (doc.customerPhone != null)
                        pw.Text('Phone: ${doc.customerPhone!}', style: const pw.TextStyle(fontSize: 9)),
                      if (doc.customerAddress != null)
                        pw.Text('Address: ${doc.customerAddress!}', style: const pw.TextStyle(fontSize: 9)),
                      if (doc.customerGstNumber != null)
                        pw.Text('GSTIN: ${doc.customerGstNumber!}', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 16),

          // ── Line Items Table ────────────────────────────────────────────────
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            columnWidths: {
              0: const pw.FixedColumnWidth(24),  // #
              1: const pw.FlexColumnWidth(3.5),  // Item
              2: const pw.FlexColumnWidth(1.2),  // HSN
              3: const pw.FlexColumnWidth(1),    // Qty
              4: const pw.FlexColumnWidth(1.5),  // Price
              5: const pw.FlexColumnWidth(1.2),  // Discount
              6: const pw.FlexColumnWidth(1.5),  // Line Total
            },
            children: [
              // Header Row
              pw.TableRow(
                decoration: pw.BoxDecoration(color: headerBgColor),
                children: [
                  _tableCell('#', isHeader: true, textColor: tableHeaderTextColor),
                  _tableCell('Item & Description', isHeader: true, textColor: tableHeaderTextColor),
                  _tableCell('HSN/SAC', isHeader: true, textColor: tableHeaderTextColor),
                  _tableCell('Qty', isHeader: true, textColor: tableHeaderTextColor, align: pw.Alignment.centerRight),
                  _tableCell('Price (₹)', isHeader: true, textColor: tableHeaderTextColor, align: pw.Alignment.centerRight),
                  _tableCell('Disc (₹)', isHeader: true, textColor: tableHeaderTextColor, align: pw.Alignment.centerRight),
                  _tableCell('Amount (₹)', isHeader: true, textColor: tableHeaderTextColor, align: pw.Alignment.centerRight),
                ],
              ),
              // Items Rows
              for (var i = 0; i < lines.length; i++)
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: i % 2 == 0 ? PdfColors.white : PdfColors.grey50,
                  ),
                  children: [
                    _tableCell('${i + 1}', align: pw.Alignment.center),
                    _tableCell(lines[i].itemName),
                    _tableCell(lines[i].hsnSacCode ?? '-'),
                    _tableCell('${lines[i].quantity} ${lines[i].unit}', align: pw.Alignment.centerRight),
                    _tableCell(CurrencyFormatter.format(lines[i].pricePerUnit), align: pw.Alignment.centerRight),
                    _tableCell(lines[i].discountAmount > 0 ? CurrencyFormatter.format(lines[i].discountAmount) : '-', align: pw.Alignment.centerRight),
                    _tableCell(CurrencyFormatter.format(lines[i].lineTotal), align: pw.Alignment.centerRight, isBold: true),
                  ],
                ),
            ],
          ),

          pw.SizedBox(height: 12),

          // ── Totals & Summary Block ──────────────────────────────────────────
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Left side: Amount in Words & Bank Details
              pw.Expanded(
                flex: 3,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey100,
                        borderRadius: pw.BorderRadius.circular(4),
                        border: pw.Border.all(color: PdfColors.grey300),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Amount in Words:',
                            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: primaryColor),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            NumberToWords.convert(doc.grandTotal),
                            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    if (!isInvoice || (profile?.bankName != null)) ...[
                      pw.SizedBox(height: 8),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.grey50,
                          borderRadius: pw.BorderRadius.circular(4),
                          border: pw.Border.all(color: PdfColors.grey300),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Bank Details for Transfer:',
                              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: primaryColor),
                            ),
                            if (profile?.bankName != null)
                              pw.Text('Bank: ${profile!.bankName!}', style: const pw.TextStyle(fontSize: 8)),
                            if (profile?.bankAccountNo != null)
                              pw.Text('A/C No: ${profile!.bankAccountNo!}', style: const pw.TextStyle(fontSize: 8)),
                            if (profile?.bankIfsc != null)
                              pw.Text('IFSC: ${profile!.bankIfsc!}', style: const pw.TextStyle(fontSize: 8)),
                            if (profile?.bankBranchAddress != null)
                              pw.Text('Branch: ${profile!.bankBranchAddress!}', style: const pw.TextStyle(fontSize: 8)),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              pw.SizedBox(width: 16),

              // Right side: Financial Totals
              pw.Expanded(
                flex: 2,
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Column(
                    children: [
                      _summaryPdfRow('Subtotal', CurrencyFormatter.formatPdf(doc.subtotal)),
                      if (doc.totalDiscount > 0)
                        _summaryPdfRow('Discount', '- ${CurrencyFormatter.formatPdf(doc.totalDiscount)}'),
                      if (doc.totalTax > 0)
                        _summaryPdfRow('Tax (GST)', '+ ${CurrencyFormatter.formatPdf(doc.totalTax)}'),
                      pw.Divider(thickness: 0.5),
                      _summaryPdfRow('Grand Total', CurrencyFormatter.formatPdf(doc.grandTotal), isBold: true, fontSize: 11),
                      if (isInvoice && doc.amountReceived != null && doc.amountReceived! > 0) ...[
                        _summaryPdfRow('Amount Paid', CurrencyFormatter.formatPdf(doc.amountReceived!)),
                        _summaryPdfRow('Balance Due', CurrencyFormatter.formatPdf(doc.balanceDue ?? 0.0), isBold: true),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 24),

          // ── Notes & Signature Footer ────────────────────────────────────────
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (doc.notes != null && doc.notes!.isNotEmpty) ...[
                      pw.Text('Terms & Notes:', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                      pw.Text(doc.notes!, style: const pw.TextStyle(fontSize: 8)),
                    ],
                  ],
                ),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  if (signatureImage != null) ...[
                    pw.ConstrainedBox(
                      constraints: const pw.BoxConstraints(
                        maxHeight: 40,
                        maxWidth: 100,
                      ),
                      child: pw.Image(
                        signatureImage,
                        fit: pw.BoxFit.contain,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                  ] else ...[
                    pw.SizedBox(height: 30),
                  ],
                  pw.Container(
                    width: 130,
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(top: pw.BorderSide(color: PdfColors.grey400, width: 0.5)),
                    ),
                    child: pw.Text(
                      'Authorized Signatory\n${profile?.businessName ?? ""}',
                      style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _tableCell(
    String text, {
    bool isHeader = false,
    bool isBold = false,
    PdfColor textColor = PdfColors.black,
    pw.Alignment align = pw.Alignment.centerLeft,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      alignment: align,
      child: pw.Text(
        text,
        softWrap: true,
        style: pw.TextStyle(
          fontSize: isHeader ? 8 : 8,
          fontWeight: isHeader || isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: textColor,
        ),
      ),
    );
  }

  static pw.Widget _summaryPdfRow(String label, String value, {bool isBold = false, double fontSize = 9}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(fontSize: fontSize, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: fontSize, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
