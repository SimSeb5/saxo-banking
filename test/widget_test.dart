import 'package:flutter_test/flutter_test.dart';
import 'package:saxo_banking/app.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const SaxoBankingApp());

    // Verify splash screen shows SAXO text
    expect(find.text('SAXO'), findsOneWidget);
  });
}
