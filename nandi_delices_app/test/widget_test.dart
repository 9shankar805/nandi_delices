import 'package:flutter_test/flutter_test.dart';
import 'package:nandi_delices/main.dart';

void main() {
  testWidgets('App launches and renders title', (WidgetTester tester) async {
    await tester.pumpWidget(const NandiDelicesApp());
    expect(find.textContaining('Nandi Delices'), findsWidgets);
  });
}
