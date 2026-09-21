import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizontal_credit_card/horizontal_credit_card.dart';

void main() {
  group('HorizontalCard Widget Tests', () {
    testWidgets('Renders HorizontalCard front face with expected details',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HorizontalCard(
              cardNumber: '4532 8812 9043 7721',
              cardHolder: 'Alexander Wright',
              expiryDate: '09/29',
              cvv: '842',
              brand: CardBrand.visa,
            ),
          ),
        ),
      );

      expect(find.text('ALEXANDER WRIGHT'), findsOneWidget);
      expect(find.text('09/29'), findsOneWidget);
      expect(find.text('4532  8812  9043  7721'), findsOneWidget);
      expect(find.text('VISA'), findsOneWidget);
      expect(find.byType(HorizontalEmvChip), findsOneWidget);
      expect(find.byType(HorizontalContactless), findsOneWidget);
    });

    testWidgets('Masks card number when isMasked is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HorizontalCard(
              cardNumber: '4532 8812 9043 7721',
              cardHolder: 'John Doe',
              expiryDate: '12/28',
              cvv: '999',
              isMasked: true,
            ),
          ),
        ),
      );

      expect(find.text('••••  ••••  ••••  7721'), findsOneWidget);
    });

    testWidgets('Renders Frozen overlay when isFrozen is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HorizontalCard(
              cardNumber: '4532 8812 9043 7721',
              cardHolder: 'John Doe',
              expiryDate: '12/28',
              cvv: '999',
              isFrozen: true,
            ),
          ),
        ),
      );

      expect(find.text('FROZEN'), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('Renders reverse face on tap', (WidgetTester tester) async {
      bool? flippedState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalCard(
              cardNumber: '4532 8812 9043 7721',
              cardHolder: 'John Doe',
              expiryDate: '12/28',
              cvv: '999',
              onFlip: (isFlipped) => flippedState = isFlipped,
            ),
          ),
        ),
      );

      // Tap card to flip
      await tester.tap(find.byType(HorizontalCard));
      await tester.pumpAndSettle();

      expect(flippedState, isTrue);
      expect(find.byType(HorizontalCardBack), findsOneWidget);
      expect(find.text('999'), findsOneWidget);
    });

    testWidgets('Renders custom bankLogo when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HorizontalCard(
              cardNumber: '4532 8812 9043 7721',
              cardHolder: 'Jane Doe',
              expiryDate: '10/30',
              cvv: '123',
              bankLogo: Text('NEOBANK PREMIUM'),
            ),
          ),
        ),
      );

      expect(find.text('NEOBANK PREMIUM'), findsOneWidget);
    });
  });

  group('HorizontalCardTheme Tests', () {
    test('Pre-built themes have non-null attributes', () {
      expect(HorizontalCardTheme.black.textColor, isNotNull);
      expect(HorizontalCardTheme.electricPurple.backgroundGradient, isNotNull);
      expect(HorizontalCardTheme.titanium.backgroundColor, isNotNull);
    });
  });
}
