// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:rasidhu/widgets/signature_selector_field.dart';
import 'package:rasidhu/utils/image_utils.dart';

class FakePathProviderPlatform extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  FakePathProviderPlatform(this.path);
  final String path;

  @override
  Future<String?> getApplicationDocumentsPath() async => path;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('rasidhu_signature_test_');
    PathProviderPlatform.instance = FakePathProviderPlatform(tempDir.path);
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('ImageUtils Signature Tests', () {
    test('saveSignatureBytes writes PNG bytes to asset directory', () async {
      final dummyPngBytes = Uint8List.fromList([
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG magic header
        0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
      ]);

      final savedPath = await ImageUtils.saveSignatureBytes(dummyPngBytes);
      expect(savedPath, contains('signature.png'));
      expect(File(savedPath).existsSync(), isTrue);
      expect(File(savedPath).readAsBytesSync(), equals(dummyPngBytes));
    });
  });

  group('SignatureSelectorField Widget Tests', () {
    testWidgets('renders all three modes (Upload, Draw, Type)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 500,
                child: SignatureSelectorField(
                  label: 'Authorised Signature',
                  currentPath: null,
                  onSaved: (_) {},
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Authorised Signature'), findsOneWidget);
      expect(find.text('Upload Image'), findsOneWidget);
      expect(find.text('Draw'), findsOneWidget);
      expect(find.text('Type to Sign'), findsOneWidget);

      // Verify Upload Tab by default
      expect(find.text('Upload a signature image file'), findsOneWidget);

      // Switch to Draw Tab
      await tester.tap(find.text('Draw'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Draw using finger or stylus'), findsOneWidget);
      expect(find.text('Clear Canvas'), findsOneWidget);
      expect(find.text('Save Drawn Signature'), findsOneWidget);

      // Switch to Type to Sign Tab
      await tester.tap(find.text('Type to Sign'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Enter Full Name'), findsOneWidget);
      expect(find.text('Handwriting Preview:'), findsOneWidget);
      expect(find.text('Save Typed Signature'), findsOneWidget);
    });

    testWidgets('Type to Sign updates preview and saves signature', (tester) async {
      String? savedPath;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 500,
                child: SignatureSelectorField(
                  label: 'Authorised Signature',
                  currentPath: null,
                  onSaved: (path) => savedPath = path,
                ),
              ),
            ),
          ),
        ),
      );

      // Navigate to Type to Sign
      await tester.tap(find.text('Type to Sign'));
      await tester.pump(const Duration(milliseconds: 300));

      // Enter name
      await tester.enterText(find.byType(TextField), 'John Doe');
      await tester.pump(const Duration(milliseconds: 300));

      // Verify text preview appears
      expect(find.text('John Doe'), findsNWidgets(2)); // Input + Cursive Preview

      // Tap Save Typed Signature
      final saveButton = find.text('Save Typed Signature');
      await tester.runAsync(() async {
        await tester.tap(saveButton);
        await Future.delayed(const Duration(milliseconds: 500));
      });
      await tester.pump();

      expect(savedPath, isNotNull);
      expect(File(savedPath!).existsSync(), isTrue);
    });

    testWidgets('Draw Signature saves PNG when user draws strokes', (tester) async {
      String? savedPath;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 500,
                child: SignatureSelectorField(
                  label: 'Authorised Signature',
                  currentPath: null,
                  onSaved: (path) => savedPath = path,
                ),
              ),
            ),
          ),
        ),
      );

      // Navigate to Draw
      await tester.tap(find.text('Draw'));
      await tester.pump(const Duration(milliseconds: 300));

      // Draw stroke on canvas Listener widget
      final listenerFinder = find.byKey(const ValueKey('draw_canvas_gesture'));
      final listener = tester.widget<Listener>(listenerFinder);
      listener.onPointerDown?.call(const PointerDownEvent(position: Offset(50, 50)));
      listener.onPointerMove?.call(const PointerMoveEvent(position: Offset(100, 50)));
      await tester.pump();

      // Tap Save Drawn Signature
      final saveButton = find.text('Save Drawn Signature');
      await tester.runAsync(() async {
        await tester.tap(saveButton);
        await Future.delayed(const Duration(milliseconds: 500));
      });
      await tester.pump();

      expect(savedPath, isNotNull);
      expect(File(savedPath!).existsSync(), isTrue);
    });
  });
}


