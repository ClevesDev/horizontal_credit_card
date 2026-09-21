import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizontal_credit_card/horizontal_credit_card.dart';

void main() {
  group('DynamicCvvConfig and DynamicCvvController Tests', () {
    test('Default config has 60 seconds duration and 3 digits', () {
      const config = DynamicCvvConfig();
      expect(config.duration, const Duration(seconds: 60));
      expect(config.digitsLength, 3);
      expect(config.showTimer, isTrue);
      expect(config.showRemainingSeconds, isTrue);
      expect(config.tapToRefresh, isTrue);
      expect(config.warningThreshold, const Duration(seconds: 10));
    });

    test('Controller initializes with fallback CVV and counts down', () async {
      final controller = DynamicCvvController(
        config: const DynamicCvvConfig(duration: Duration(seconds: 60)),
        initialCvv: '789',
      );

      expect(controller.currentCvv, '789');
      expect(controller.remainingSeconds, 60);
      expect(controller.progress, 1.0);

      controller.start();
      expect(controller.isRunning, isTrue);

      controller.dispose();
    });

    test('Controller regenerate creates new code and notifies listeners',
        () async {
      String? callbackCode;
      final controller = DynamicCvvController(
        config: DynamicCvvConfig(
          duration: const Duration(seconds: 60),
          onCvvChanged: (code) => callbackCode = code,
        ),
        initialCvv: '123',
      );

      bool notified = false;
      controller.addListener(() {
        notified = true;
      });

      await controller.regenerate();

      expect(notified, isTrue);
      expect(controller.currentCvv.length, 3);
      expect(callbackCode, equals(controller.currentCvv));

      controller.dispose();
    });
  });

  group('HorizontalDynamicCvv Widget Tests', () {
    testWidgets('Renders dynamic CVV digits and circular progress ring',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: HorizontalDynamicCvv(
                initialCvv: '842',
              ),
            ),
          ),
        ),
      );

      expect(find.text('842'), findsOneWidget);
      expect(find.byType(HorizontalDynamicCvv), findsOneWidget);
      expect(find.text('60'), findsOneWidget);
    });

    testWidgets('Renders masked digits when isMasked is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: HorizontalDynamicCvv(
                initialCvv: '842',
                isMasked: true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('•••'), findsOneWidget);
      expect(find.text('842'), findsNothing);
    });

    testWidgets('Tap to refresh regenerates CVV code',
        (WidgetTester tester) async {
      String? newCvv;
      final controller = DynamicCvvController(
        config: DynamicCvvConfig(
          onCvvChanged: (val) => newCvv = val,
        ),
        initialCvv: '555',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: HorizontalDynamicCvv(
                controller: controller,
              ),
            ),
          ),
        ),
      );

      expect(find.text('555'), findsOneWidget);

      await tester.tap(find.byType(HorizontalDynamicCvv));
      await tester.pumpAndSettle();

      expect(newCvv, isNotNull);
      expect(controller.currentCvv, isNot('555'));

      controller.dispose();
    });
  });

  group('HorizontalCard with Dynamic CVV Integration Tests', () {
    testWidgets(
        'Card renders dynamic CVV widget when isDynamicCvv is true on back',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HorizontalCard(
              cardNumber: '4532 8812 9043 7721',
              cardHolder: 'Alexander Wright',
              expiryDate: '09/29',
              cvv: '739',
              isFlipped: true,
              isDynamicCvv: true,
            ),
          ),
        ),
      );

      expect(find.byType(HorizontalDynamicCvv), findsOneWidget);
      expect(find.text('739'), findsOneWidget);
    });

    testWidgets(
        'Card renders static CVV box when isDynamicCvv is false on back',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HorizontalCard(
              cardNumber: '4532 8812 9043 7721',
              cardHolder: 'Alexander Wright',
              expiryDate: '09/29',
              cvv: '739',
              isFlipped: true,
              isDynamicCvv: false,
            ),
          ),
        ),
      );

      expect(find.byType(HorizontalDynamicCvv), findsNothing);
      expect(find.text('739'), findsOneWidget);
    });
  });
}
