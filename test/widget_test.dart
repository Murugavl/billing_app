// Widget tests for Billwise
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:billwise/app.dart';

void main() {
  testWidgets('BillingApp smoke test — renders without crashing', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: BillingApp(),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(BillingApp), findsOneWidget);
  });
}
