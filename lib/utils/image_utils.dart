// Image file utilities — copy picked images to persistent app storage
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

abstract final class ImageUtils {
  /// Copies [sourcePath] to `<appDocuments>/business_assets/<filename>`.
  /// Returns the destination path. Safe to call multiple times — overwrites.
  static Future<String> saveBusinessAsset(
    String sourcePath, {
    required String filename,
  }) async {
    final appDir = await getApplicationDocumentsDirectory();
    final destDir = Directory(p.join(appDir.path, 'business_assets'));
    await destDir.create(recursive: true);
    final ext = p.extension(sourcePath);
    final destPath = p.join(destDir.path, '$filename$ext');
    await File(sourcePath).copy(destPath);
    return destPath;
  }

  /// Writes [bytes] to `<appDocuments>/business_assets/<filename>.<extension>`.
  /// Returns the destination path.
  static Future<String> saveBusinessAssetBytes(
    Uint8List bytes, {
    required String filename,
    String extension = '.png',
  }) async {
    final appDir = await getApplicationDocumentsDirectory();
    final destDir = Directory(p.join(appDir.path, 'business_assets'));
    await destDir.create(recursive: true);
    final destPath = p.join(destDir.path, '$filename$extension');
    await File(destPath).writeAsBytes(bytes, flush: true);
    return destPath;
  }

  /// Saves a picked logo image. Uses a stable filename so repeated saves
  /// overwrite rather than accumulate.
  static Future<String> saveLogo(String sourcePath) =>
      saveBusinessAsset(sourcePath, filename: 'logo');

  /// Saves a picked signature image.
  static Future<String> saveSignature(String sourcePath) =>
      saveBusinessAsset(sourcePath, filename: 'signature');

  /// Saves signature PNG bytes.
  static Future<String> saveSignatureBytes(Uint8List bytes) =>
      saveBusinessAssetBytes(bytes, filename: 'signature', extension: '.png');

  /// Returns true if [path] is non-null and points to an existing file.
  static bool exists(String? path) =>
      path != null && File(path).existsSync();
}

