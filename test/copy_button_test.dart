import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizontal_credit_card/horizontal_credit_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Copy Card Number Button Tests', () {
    testWidgets('Does not render copy button when enableCopy is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HorizontalCard(
              cardNumber: '4532 8812 9043 7721',
              cardHolder: 'Alexander Wright',
              expiryDate: '09/29',
              cvv: '842',
              enableCopy: false,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.copy_rounded), findsNothing);
    });

    testWidgets('Renders copy button when enableCopy is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HorizontalCard(
              cardNumber: '4532 8812 9043 7721',
              cardHolder: 'Alexander Wright',
              expiryDate: '09/29',
              cvv: '842',
              enableCopy: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.copy_rounded), findsOneWidget);
    });

    testWidgets(
        'Tapping copy button copies clean card number and displays checkmark',
        (WidgetTester tester) async {
      String? copiedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalCard(
              cardNumber: '4532 8812 9043 7721',
              cardHolder: 'Alexander Wright',
              expiryDate: '09/29',
              cvv: '842',
              enableCopy: true,
              cleanCopiedNumber: true,
              onCardNumberCopied: (val) => copiedValue = val,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.copy_rounded), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsNothing);

      await tester.tap(find.byIcon(Icons.copy_rounded));
      await tester.pump();

      // Check callback received cleaned card number without spaces
      expect(copiedValue, equals('4532881290437721'));

      // Check visual transition to checkmark
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);

      // After 1800ms reset timer expires, returns to copy icon
      await tester.pump(const Duration(milliseconds: 2000));
      expect(find.byIcon(Icons.copy_rounded), findsOneWidget);
    });

    testWidgets(
        'Tapping copy button preserves formatted spaces when cleanCopiedNumber is false',
        (WidgetTester tester) async {
      String? copiedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalCard(
              cardNumber: '4532 8812 9043 7721',
              cardHolder: 'Alexander Wright',
              expiryDate: '09/29',
              cvv: '842',
              enableCopy: true,
              cleanCopiedNumber: false,
              onCardNumberCopied: (val) => copiedValue = val,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.copy_rounded));
      await tester.pump();

      expect(copiedValue, equals('4532 8812 9043 7721'));
    });
  });
}
