// Image picker field — shows preview + gallery/camera pick options
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AppImagePickerField extends StatelessWidget {
  const AppImagePickerField({
    super.key,
    required this.label,
    required this.currentPath,
    required this.onPicked,
    this.onClear,
    this.hint = 'Tap to pick an image',
    this.previewSize = 100,
    this.isCircle = false,
  });

  final String label;

  /// Current saved file path (null if not set).
  final String? currentPath;

  /// Called with the picked file path (already saved to app dir).
  /// The caller is responsible for saving to app storage before calling this.
  final void Function(String path) onPicked;

  final VoidCallback? onClear;
  final String hint;
  final double previewSize;
  final bool isCircle;

  Future<void> _pick(BuildContext context, ImageSource source) async {
    try {
      final picker = ImagePicker();
      final xFile = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
      );
      if (xFile != null) {
        onPicked(xFile.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not pick image: $e')),
        );
      }
    }
  }

  void _showSourceSheet(BuildContext context) {
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
                  _pick(context, ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded),
                title: Text('Take a Photo',
                    style: GoogleFonts.inter(fontSize: 14)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pick(context, ImageSource.camera);
                },
              ),
              if (currentPath != null && onClear != null)
                ListTile(
                  leading:
                      Icon(Icons.delete_outline, color: Colors.red.shade400),
                  title: Text('Remove Image',
                      style: GoogleFonts.inter(
                          fontSize: 14, color: Colors.red.shade400)),
                  onTap: () {
                    Navigator.pop(ctx);
                    onClear!();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final hasImage =
        currentPath != null && File(currentPath!).existsSync();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: cs.onSurface.withAlpha(200),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            // Preview box
            GestureDetector(
              onTap: () => _showSourceSheet(context),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: previewSize,
                height: previewSize,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: isCircle
                      ? BorderRadius.circular(previewSize / 2)
                      : BorderRadius.circular(12),
                  border: Border.all(
                    color: hasImage
                        ? cs.primary.withAlpha(120)
                        : cs.outline.withAlpha(120),
                    width: hasImage ? 2 : 1,
                  ),
                  image: hasImage
                      ? DecorationImage(
                          image: FileImage(File(currentPath!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: hasImage
                    ? null
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 30,
                            color: cs.onSurface.withAlpha(100),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap to add',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: cs.onSurface.withAlpha(120),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(width: 16),
            // Action buttons
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hint,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: cs.onSurface.withAlpha(150),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () => _showSourceSheet(context),
                    icon: const Icon(Icons.upload_rounded, size: 16),
                    label: Text(
                        hasImage ? 'Change Image' : 'Upload Image',
                        style: GoogleFonts.inter(fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                    ),
                  ),
                  if (hasImage && onClear != null) ...[
                    const SizedBox(height: 6),
                    TextButton.icon(
                      onPressed: onClear,
                      icon: Icon(Icons.close,
                          size: 14, color: cs.error.withAlpha(180)),
                      label: Text(
                        'Remove',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: cs.error.withAlpha(180),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
