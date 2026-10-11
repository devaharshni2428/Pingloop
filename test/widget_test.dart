
import 'package:flutter_test/flutter_test.dart';
import 'package:pingloop/main.dart';

void main() {
  testWidgets('PINGLOOP app launches', (WidgetTester tester) async {
    await tester.pumpWidget(const PingLoopApp());

    expect(find.text('Login to continue to PINGLOOP'), findsOneWidget);
  });
}
