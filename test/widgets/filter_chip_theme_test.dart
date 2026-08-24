// Filter Chip Theme & Readability Widget Test across Light & Dark themes
import 'package:billwise/core/theme/app_theme.dart';
import 'package:billwise/widgets/app_filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppFilterChip Readability & Contrast Tests', () {
    testWidgets('renders unselected and selected filter chips with readable text in Light mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Row(
              children: [
                AppFilterChip(
                  label: 'Draft',
                  isSelected: false,
                  onSelected: () {},
                ),
                AppFilterChip(
                  label: 'Sent',
                  isSelected: true,
                  onSelected: () {},
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Draft'), findsOneWidget);
      expect(find.text('Sent'), findsOneWidget);

      final draftText = tester.widget<Text>(find.text('Draft'));
      final sentText = tester.widget<Text>(find.text('Sent'));

      // Unselected label must be dark primary text (high contrast against white/light surface)
      expect(draftText.style?.color, equals(AppColors.textDarkPrimary));
      // Selected label must be solid white (high contrast against primary blue)
      expect(sentText.style?.color, equals(Colors.white));
    });

    testWidgets('renders unselected and selected filter chips with readable text in Dark mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: Row(
              children: [
                AppFilterChip(
                  label: 'Draft',
                  isSelected: false,
                  onSelected: () {},
                ),
                AppFilterChip(
                  label: 'Sent',
                  isSelected: true,
                  onSelected: () {},
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Draft'), findsOneWidget);
      expect(find.text('Sent'), findsOneWidget);

      final draftText = tester.widget<Text>(find.text('Draft'));
      final sentText = tester.widget<Text>(find.text('Sent'));

      // In dark mode, unselected text should not be transparent/white-on-white
      expect(draftText.style?.color, isNotNull);
      expect(draftText.style?.color, isNot(equals(Colors.transparent)));
      expect(sentText.style?.color, equals(Colors.white));
    });
  });
}
