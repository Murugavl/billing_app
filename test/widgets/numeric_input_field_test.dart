import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:billwise/widgets/app_text_field.dart';

void main() {
  group('Numeric Input Field UX Tests', () {
    testWidgets('Tapping into numeric AppTextField with pre-filled text selects all text so typing replaces it', (tester) async {
      final controller = TextEditingController(text: '0');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: 'Price per Unit',
              controller: controller,
              hint: '0.00',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ),
        ),
      );

      // Focus the text field by tapping it
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      // Controller selection should be range [0, 1] selecting '0'
      expect(controller.selection.baseOffset, equals(0));
      expect(controller.selection.extentOffset, equals(1));

      // Type '5'
      await tester.enterText(find.byType(TextField), '5');
      await tester.pumpAndSettle();

      // Text should be '5' instead of '05'
      expect(controller.text, equals('5'));
    });

    testWidgets('Numeric AppTextField initialized empty shows hint and accepts input', (tester) async {
      final controller = TextEditingController(text: '');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: 'Quantity',
              controller: controller,
              hint: '1',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ),
        ),
      );

      expect(controller.text, equals(''));

      // Tap into the text field
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      // Type '3'
      await tester.enterText(find.byType(TextField), '3');
      await tester.pumpAndSettle();

      expect(controller.text, equals('3'));
    });
  });
}
