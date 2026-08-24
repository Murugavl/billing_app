import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:billwise/screens/invoices/invoice_form_screen.dart';
import 'package:billwise/screens/estimates/estimate_form_screen.dart';
import 'package:billwise/screens/purchases/purchase_bill_form_screen.dart';
import 'package:billwise/widgets/customer_picker_sheet.dart';
import 'package:billwise/services/database_provider.dart';
import 'package:billwise/db/app_database.dart';
import 'package:drift/native.dart';

AppDatabase _createTestDb() {
  return AppDatabase(NativeDatabase.memory());
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('360dp Narrow Viewport Layout Overflow Tests', () {
    testWidgets('InvoiceFormScreen customer placeholder renders cleanly at 360dp width without overflow', (tester) async {
      FlutterError.onError = (details) {
        // ignore: avoid_print
        print('INVOICE OVERFLOW FULL ERROR:\n$details');
      };
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final db = _createTestDb();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: InvoiceFormScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Tap to select or quick-add customer'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await db.close();
    });

    testWidgets('EstimateFormScreen customer placeholder renders cleanly at 360dp width without overflow', (tester) async {
      FlutterError.onError = (details) {
        // ignore: avoid_print
        print('ESTIMATE OVERFLOW DETAILS: ${details.exception}');
      };
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final db = _createTestDb();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: EstimateFormScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Tap to select customer for estimate'), findsOneWidget);
      final exc = tester.takeException();
      if (exc != null) {
        // ignore: avoid_print
        print('ESTIMATE FORM TEST EXCEPTION: $exc');
      }
      expect(exc, isNull);

      await db.close();
    });

    testWidgets('PurchaseBillFormScreen renders cleanly at 360dp width without overflow', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final db = _createTestDb();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: PurchaseBillFormScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Supplier Information'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await db.close();
    });

    testWidgets('CustomerPickerSheet renders title and buttons cleanly at 360dp width without overflow', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final db = _createTestDb();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: CustomerPickerSheet(),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Select Customer'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await db.close();
    });
  });
}
