import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizontal_credit_card/horizontal_credit_card.dart';

void main() {
  group('HoloFoilConfig Tests', () {
    test('Default configuration attributes are properly initialized', () {
      const config = HoloFoilConfig();
      expect(config.enabled, isTrue);
      expect(config.style, HoloStyle.full);
      expect(config.intensity, 0.35);
      expect(config.badgeAlignment, const Alignment(0.68, -0.62));
      expect(config.badgeSize, const Size(38.0, 26.0));
      expect(config.stripeWidth, 32.0);
      expect(HoloFoilConfig.defaultSpectrum.length, 8);
    });

    test('copyWith properly overrides properties', () {
      const config = HoloFoilConfig();
      final updated = config.copyWith(
        style: HoloStyle.securityBadge,
        intensity: 0.5,
        stripeWidth: 40.0,
      );

      expect(updated.style, HoloStyle.securityBadge);
      expect(updated.intensity, 0.5);
      expect(updated.stripeWidth, 40.0);
      expect(updated.enabled, isTrue);
    });
  });

  group('HorizontalHoloFoilPainter Widget Integration Tests', () {
    testWidgets('Does not render holo foil layer when isHolographic is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HorizontalCard(
              cardNumber: '4532 8812 9043 7721',
              cardHolder: 'Alexander Wright',
              expiryDate: '09/29',
              cvv: '842',
              isHolographic: false,
            ),
          ),
        ),
      );

      final customPaintFinder = find.byWidgetPredicate((widget) {
        return widget is CustomPaint &&
            widget.painter is HorizontalHoloFoilPainter;
      });

      expect(customPaintFinder, findsNothing);
    });

    testWidgets('Renders full holo foil layer when isHolographic is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HorizontalCard(
              cardNumber: '4532 8812 9043 7721',
              cardHolder: 'Alexander Wright',
              expiryDate: '09/29',
              cvv: '842',
              isHolographic: true,
            ),
          ),
        ),
      );

      final customPaintFinder = find.byWidgetPredicate((widget) {
        return widget is CustomPaint &&
            widget.painter is HorizontalHoloFoilPainter;
      });

      expect(customPaintFinder, findsOneWidget);
    });

    testWidgets('Renders security badge style when configured',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HorizontalCard(
              cardNumber: '4532 8812 9043 7721',
              cardHolder: 'Alexander Wright',
              expiryDate: '09/29',
              cvv: '842',
              isHolographic: true,
              holoConfig: HoloFoilConfig(
                style: HoloStyle.securityBadge,
                intensity: 0.6,
              ),
            ),
          ),
        ),
      );

      final customPaintFinder = find.byWidgetPredicate((widget) {
        if (widget is CustomPaint &&
            widget.painter is HorizontalHoloFoilPainter) {
          final painter = widget.painter as HorizontalHoloFoilPainter;
          return painter.config.style == HoloStyle.securityBadge &&
              painter.config.intensity == 0.6;
        }
        return false;
      });

      expect(customPaintFinder, findsOneWidget);
    });

    testWidgets('Renders security stripe style when configured',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HorizontalCard(
              cardNumber: '4532 8812 9043 7721',
              cardHolder: 'Alexander Wright',
              expiryDate: '09/29',
              cvv: '842',
              isHolographic: true,
              holoConfig: HoloFoilConfig(
                style: HoloStyle.securityStripe,
                stripeWidth: 28.0,
              ),
            ),
          ),
        ),
      );

      final customPaintFinder = find.byWidgetPredicate((widget) {
        if (widget is CustomPaint &&
            widget.painter is HorizontalHoloFoilPainter) {
          final painter = widget.painter as HorizontalHoloFoilPainter;
          return painter.config.style == HoloStyle.securityStripe &&
              painter.config.stripeWidth == 28.0;
        }
        return false;
      });

      expect(customPaintFinder, findsOneWidget);
    });
  });
}
