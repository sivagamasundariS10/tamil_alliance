import 'package:flutter_test/flutter_test.dart';
import 'package:tamil_alliance/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TamilAllianceApp());
    expect(find.text('TAMIL ALLIANCE'), findsOneWidget);
  });
}
