import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';
import 'package:horizontal_credit_card/horizontal_credit_card.dart';

void main() {
  testWidgets('Smoke test: HorizontalCardDemoApp renders card and controls',
      (WidgetTester tester) async {
    await tester.pumpWidget(const HorizontalCardDemoApp());

    expect(find.text('Horizontal Card 3D Studio'), findsOneWidget);
    expect(find.byType(HorizontalCard), findsOneWidget);
    expect(find.text('Geometric Patterns'), findsOneWidget);
    expect(find.text('Solid Colors'), findsOneWidget);
    expect(find.text('Luxury Metals'), findsOneWidget);
  });
}
