import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/image_utils.dart';

enum SignatureMode { upload, draw, type }

/// Comprehensive signature creation widget supporting:
/// 1. Upload Image (gallery / camera)
/// 2. Draw Signature (CustomPainter drawing canvas with clear & save)
/// 3. Type to Sign (cursive text rendering with clear & save)
class SignatureSelectorField extends StatefulWidget {
  const SignatureSelectorField({
    super.key,
    required this.label,
    required this.currentPath,
    required this.onSaved,
    this.onClear,
    this.hint = 'Choose how to add your authorised signature for invoices',
  });

  final String label;
  final String? currentPath;
  final void Function(String path) onSaved;
  final VoidCallback? onClear;
  final String hint;

  @override
  State<SignatureSelectorField> createState() => _SignatureSelectorFieldState();
}

class _SignatureSelectorFieldState extends State<SignatureSelectorField> {
  SignatureMode _selectedMode = SignatureMode.upload;

  // Drawing state
  final List<List<Offset>> _strokes = [];
  List<Offset>? _currentStroke;

  // Type to Sign state
  final TextEditingController _typeController = TextEditingController();
  bool _isExporting = false;

  @override
  void dispose() {
    _typeController.dispose();
    super.dispose();
  }

  // ── Image Picker Handler (Mode 1) ──────────────────────────────────────────
  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final xFile = await picker.pickImage(
        source: source,
        imageQuality: 90,
        maxWidth: 1200,
      );
      if (xFile != null) {
        final savedPath = await ImageUtils.saveSignature(xFile.path);
        widget.onSaved(savedPath);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not pick signature image: $e')),
        );
      }
    }
  }

  void _showUploadSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: Text('Choose from Gallery',
                    style: GoogleFonts.inter(fontSize: 14)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded),
                title: Text('Take a Photo',
                    style: GoogleFonts.inter(fontSize: 14)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Save Drawn Signature (Mode 2) ──────────────────────────────────────────
  Future<void> _saveDrawnSignature(Size displaySize) async {
    if (_strokes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please draw your signature first')),
      );
      return;
    }

    setState(() => _isExporting = true);
    try {
      // Export resolution: 600 x 220 transparent PNG
      const exportWidth = 600.0;
      const exportHeight = 220.0;
      final scaleX = exportWidth / displaySize.width;
      final scaleY = exportHeight / displaySize.height;

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(
        recorder,
        Rect.fromLTWH(0, 0, exportWidth, exportHeight),
      );

      final strokePaint = Paint()
        ..color = const Color(0xFF1E293B) // Dark Navy ink
        ..strokeWidth = 5.0 * ((scaleX + scaleY) / 2)
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      final dotPaint = Paint()
        ..color = const Color(0xFF1E293B)
        ..style = PaintingStyle.fill;

      for (final stroke in _strokes) {
        if (stroke.length > 1) {
          final path = Path();
          path.moveTo(stroke.first.dx * scaleX, stroke.first.dy * scaleY);
          for (int i = 1; i < stroke.length; i++) {
            path.lineTo(stroke[i].dx * scaleX, stroke[i].dy * scaleY);
          }
          canvas.drawPath(path, strokePaint);
        } else if (stroke.length == 1) {
          final center = Offset(stroke.first.dx * scaleX, stroke.first.dy * scaleY);
          canvas.drawCircle(center, 3.0 * scaleX, dotPaint);
        }
      }

      final picture = recorder.endRecording();
      final image = await picture.toImage(exportWidth.toInt(), exportHeight.toInt());
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        final bytes = byteData.buffer.asUint8List();
        final savedPath = await ImageUtils.saveSignatureBytes(bytes);
        widget.onSaved(savedPath);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Drawn signature saved!')),
          );
        }
      }
    } catch (e, stack) {
      debugPrint('Failed to save drawn signature error: $e\n$stack');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save drawn signature: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  // ── Save Typed Signature (Mode 3) ──────────────────────────────────────────
  Future<void> _saveTypedSignature() async {
    final text = _typeController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter text to create your signature')),
      );
      return;
    }

    setState(() => _isExporting = true);
    try {
      const exportWidth = 600.0;
      const exportHeight = 220.0;

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(
        recorder,
        Rect.fromLTWH(0, 0, exportWidth, exportHeight),
      );

      final textStyle = TextStyle(
        fontFamily: 'DancingScript',
        fontSize: 64,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1E293B),
      );

      final textSpan = TextSpan(text: text, style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      textPainter.layout(maxWidth: exportWidth - 40);

      final x = (exportWidth - textPainter.width) / 2;
      final y = (exportHeight - textPainter.height) / 2;

      textPainter.paint(canvas, Offset(x, y));

      final picture = recorder.endRecording();
      final image = await picture.toImage(exportWidth.toInt(), exportHeight.toInt());
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        final bytes = byteData.buffer.asUint8List();
        final savedPath = await ImageUtils.saveSignatureBytes(bytes);
        widget.onSaved(savedPath);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Typed signature saved!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save typed signature: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final hasActiveSignature =
        widget.currentPath != null && File(widget.currentPath!).existsSync();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: cs.onSurface.withAlpha(220),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.hint,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: cs.onSurface.withAlpha(150),
          ),
        ),
        const SizedBox(height: 12),

        // Active signature status banner
        if (hasActiveSignature) ...[
          _activeSignatureCard(cs),
          const SizedBox(height: 16),
        ],

        // Mode Segmented Button
        SegmentedButton<SignatureMode>(
          segments: const [
            ButtonSegment<SignatureMode>(
              value: SignatureMode.upload,
              label: Text('Upload Image'),
              icon: Icon(Icons.upload_file_rounded, size: 18),
            ),
            ButtonSegment<SignatureMode>(
              value: SignatureMode.draw,
              label: Text('Draw'),
              icon: Icon(Icons.draw_rounded, size: 18),
            ),
            ButtonSegment<SignatureMode>(
              value: SignatureMode.type,
              label: Text('Type to Sign'),
              icon: Icon(Icons.text_fields_rounded, size: 18),
            ),
          ],
          selected: {_selectedMode},
          onSelectionChanged: (newSelection) {
            setState(() {
              _selectedMode = newSelection.first;
            });
          },
          style: ButtonStyle(
            visualDensity: VisualDensity.compact,
            textStyle: WidgetStateProperty.all(
              GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Tab Content view
        switch (_selectedMode) {
          SignatureMode.upload => _buildUploadTab(cs),
          SignatureMode.draw => _buildDrawTab(cs),
          SignatureMode.type => _buildTypeTab(cs),
        },
      ],
    );
  }

  // ── Active Signature Preview Box ───────────────────────────────────────────
  Widget _activeSignatureCard(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withAlpha(100),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.primary.withAlpha(80)),
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: cs.outline.withAlpha(80)),
            ),
            padding: const EdgeInsets.all(4),
            child: Image.file(
              File(widget.currentPath!),
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_rounded),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle_rounded,
                        size: 16, color: Colors.green.shade600),
                    const SizedBox(width: 4),
                    Text(
                      'Current Active Signature',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Will be printed on invoice footer',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: cs.onSurface.withAlpha(140),
                  ),
                ),
              ],
            ),
          ),
          if (widget.onClear != null)
            IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: cs.error),
              tooltip: 'Remove Signature',
              onPressed: widget.onClear,
            ),
        ],
      ),
    );
  }

  // ── Tab 1: Upload Image ──────────────────────────────────────────────────
  Widget _buildUploadTab(ColorScheme cs) {
    return Container(
      key: const ValueKey('upload_tab'),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withAlpha(60),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline.withAlpha(60)),
      ),
      child: Column(
        children: [
          Icon(Icons.cloud_upload_outlined, size: 40, color: cs.primary),
          const SizedBox(height: 8),
          Text(
            'Upload a signature image file',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Supports PNG, JPG (transparent PNG recommended)',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: cs.onSurface.withAlpha(140),
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: _showUploadSourceSheet,
            icon: const Icon(Icons.folder_open_rounded, size: 18),
            label: Text(
              widget.currentPath != null ? 'Choose New File' : 'Browse File',
              style: GoogleFonts.inter(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab 2: Draw Signature Pad ─────────────────────────────────────────────
  Widget _buildDrawTab(ColorScheme cs) {
    return LayoutBuilder(
      key: const ValueKey('draw_tab'),
      builder: (context, constraints) {
        final canvasWidth = constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : 350.0;
        const canvasHeight = 160.0;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withAlpha(50),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outline.withAlpha(80)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Draw using finger or stylus',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: cs.onSurface.withAlpha(180),
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _strokes.isEmpty
                        ? null
                        : () {
                            setState(() {
                              _strokes.clear();
                              _currentStroke = null;
                            });
                          },
                    icon: const Icon(Icons.clear_rounded, size: 16),
                    label: Text('Clear Canvas',
                        style: GoogleFonts.inter(fontSize: 12)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Drawing Canvas Box
              Container(
                height: canvasHeight,
                width: canvasWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _strokes.isNotEmpty
                        ? cs.primary.withAlpha(160)
                        : cs.outline.withAlpha(120),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Baseline guide line
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 35,
                        child: Container(
                          height: 1,
                          color: Colors.grey.withAlpha(80),
                        ),
                      ),
                      Positioned(
                        right: 12,
                        bottom: 8,
                        child: Text(
                          'Sign above line',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: Colors.grey.withAlpha(140),
                          ),
                        ),
                      ),
                      // Interactive gesture painter
                      Positioned.fill(
                        child: Listener(
                          key: const ValueKey('draw_canvas_gesture'),
                          behavior: HitTestBehavior.opaque,
                          onPointerDown: (event) {
                            setState(() {
                              _currentStroke = [event.localPosition];
                              _strokes.add(_currentStroke!);
                            });
                          },
                          onPointerMove: (event) {
                            setState(() {
                              _currentStroke?.add(event.localPosition);
                            });
                          },
                          onPointerUp: (_) {
                            _currentStroke = null;
                          },
                          child: CustomPaint(
                            size: Size(canvasWidth, canvasHeight),
                            painter: _SignaturePainter(_strokes),
                            child: Container(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 42,
                child: ElevatedButton.icon(
                  onPressed: _isExporting || _strokes.isEmpty
                      ? null
                      : () => _saveDrawnSignature(Size(canvasWidth, canvasHeight)),
                  icon: _isExporting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check_rounded, size: 18),
                  label: Text(
                    'Save Drawn Signature',
                    style: GoogleFonts.inter(
                        fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Tab 3: Type to Sign ──────────────────────────────────────────────────
  Widget _buildTypeTab(ColorScheme cs) {
    final hasText = _typeController.text.trim().isNotEmpty;

    return Container(
      key: const ValueKey('type_tab'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withAlpha(50),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _typeController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Enter Full Name',
              hintText: 'e.g. Authorized Signatory',
              prefixIcon: const Icon(Icons.edit_note_rounded),
              suffixIcon: hasText
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _typeController.clear();
                        setState(() {});
                      },
                    )
                  : null,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: const OutlineInputBorder(),
            ),
            style: GoogleFonts.inter(fontSize: 14),
          ),
          const SizedBox(height: 12),
          Text(
            'Handwriting Preview:',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: cs.onSurface.withAlpha(160),
            ),
          ),
          const SizedBox(height: 6),
          // Cursive Font Live Preview Box
          Container(
            height: 100,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: hasText
                    ? cs.primary.withAlpha(160)
                    : cs.outline.withAlpha(100),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: hasText
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        _typeController.text.trim(),
                        key: ValueKey(_typeController.text),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'DancingScript',
                          fontSize: 38,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    )
                  : Text(
                      'Signature preview will appear here',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade400,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 42,
            child: ElevatedButton.icon(
              onPressed: _isExporting || !hasText
                  ? null
                  : _saveTypedSignature,
              icon: _isExporting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_rounded, size: 18),
              label: Text(
                'Save Typed Signature',
                style: GoogleFonts.inter(
                    fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── CustomPainter for Drawing Surface ────────────────────────────────────────
class _SignaturePainter extends CustomPainter {
  _SignaturePainter(this.strokes);

  final List<List<Offset>> strokes;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E293B) // Slate Navy Ink
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.length > 1) {
        final path = Path();
        path.moveTo(stroke.first.dx, stroke.first.dy);
        for (int i = 1; i < stroke.length; i++) {
          path.lineTo(stroke[i].dx, stroke[i].dy);
        }
        canvas.drawPath(path, paint);
      } else if (stroke.length == 1) {
        canvas.drawCircle(stroke.first, 2.0, paint..style = PaintingStyle.fill);
        paint.style = PaintingStyle.stroke;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) {
    return oldDelegate.strokes != strokes;
  }
}
