// PDF Preview Screen — Interactive PDF viewer, printing, sharing & downloading
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../db/daos/documents_dao.dart';
import '../../services/database_provider.dart';
import '../../services/pdf_service.dart';

class PdfPreviewScreen extends ConsumerStatefulWidget {
  const PdfPreviewScreen({super.key, required this.documentId});

  final int documentId;

  @override
  ConsumerState<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends ConsumerState<PdfPreviewScreen> {
  DocumentWithLines? _docWithLines;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDocument();
  }

  Future<void> _loadDocument() async {
    final docsDao = ref.read(documentsDaoProvider);
    final data = await docsDao.getDocumentWithLines(widget.documentId);
    setState(() {
      _docWithLines = data;
      _isLoading = false;
    });
  }

  Future<void> _sharePdf() async {
    if (_docWithLines == null) return;
    final profile = await ref.read(businessProfileDaoProvider).getProfile();
    final pdfBytes = await PdfService.generateDocumentPdf(
      documentWithLines: _docWithLines!,
      profile: profile,
    );

    final filename = '${_docWithLines!.document.documentNumber}.pdf';
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$filename');
    await file.writeAsBytes(pdfBytes);

    if (mounted) {
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: '${_docWithLines!.document.documentNumber} from Billwise',
        text: 'Please find attached ${_docWithLines!.document.type == "invoice" ? "Invoice" : "Estimate"} ${_docWithLines!.document.documentNumber}.',
      );
    }
  }

  Future<void> _downloadPdf() async {
    if (_docWithLines == null) return;
    final profile = await ref.read(businessProfileDaoProvider).getProfile();
    final pdfBytes = await PdfService.generateDocumentPdf(
      documentWithLines: _docWithLines!,
      profile: profile,
    );

    final filename = '${_docWithLines!.document.documentNumber}.pdf';
    Directory? dir;

    if (Platform.isAndroid) {
      dir = await getExternalStorageDirectory();
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    final savePath = '${dir?.path ?? ""}/$filename';
    final file = File(savePath);
    await file.writeAsBytes(pdfBytes);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text('PDF saved to $savePath')),
            ],
          ),
          backgroundColor: const Color(0xFF38A169),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('PDF Preview')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_docWithLines == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('PDF Preview')),
        body: const Center(child: Text('Document not found')),
      );
    }

    final doc = _docWithLines!.document;

    return Scaffold(
      appBar: AppBar(
        title: Text('${doc.documentNumber} PDF'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            tooltip: 'Share PDF via WhatsApp / Email',
            onPressed: _sharePdf,
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded),
            tooltip: 'Download PDF',
            onPressed: _downloadPdf,
          ),
        ],
      ),
      body: PdfPreview(
        build: (format) async {
          final profile = await ref.read(businessProfileDaoProvider).getProfile();
          return PdfService.generateDocumentPdf(
            documentWithLines: _docWithLines!,
            profile: profile,
          );
        },
        allowPrinting: true,
        allowSharing: true,
        canChangePageFormat: false,
        canChangeOrientation: false,
        pdfFileName: '${doc.documentNumber}.pdf',
      ),
    );
  }
}
