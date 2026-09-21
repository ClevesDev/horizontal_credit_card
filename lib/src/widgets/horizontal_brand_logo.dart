import 'package:flutter/material.dart';
import '../models/card_brand.dart';

/// Renders crisp vector payment network brand marks for horizontal cards.
class HorizontalBrandLogo extends StatelessWidget {
  /// The payment network brand to render.
  final CardBrand brand;

  /// The rendering height of the logo widget.
  final double height;

  /// Creates a [HorizontalBrandLogo].
  const HorizontalBrandLogo({
    super.key,
    required this.brand,
    this.height = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    switch (brand) {
      case CardBrand.visa:
        return SizedBox(
          height: height,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              'VISA',
              style: TextStyle(
                fontFamily: 'sans-serif',
                fontSize: height * 0.9,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                letterSpacing: 1.5,
                color: Colors.white,
              ),
            ),
          ),
        );

      case CardBrand.mastercard:
        final circleRadius = height * 0.45;
        return SizedBox(
          height: height,
          width: height * 1.5,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                child: Container(
                  width: circleRadius * 2,
                  height: circleRadius * 2,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEB001B),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: Container(
                  width: circleRadius * 2,
                  height: circleRadius * 2,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF79E1B).withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        );

      case CardBrand.americanExpress:
        return Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF006FCF),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              'AMEX',
              style: TextStyle(
                fontSize: height * 0.48,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.8,
              ),
            ),
          ),
        );

      case CardBrand.discover:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'DISC',
              style: TextStyle(
                fontSize: height * 0.6,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Container(
              width: height * 0.5,
              height: height * 0.5,
              decoration: const BoxDecoration(
                color: Color(0xFFFF6000),
                shape: BoxShape.circle,
              ),
            ),
            Text(
              'VER',
              style: TextStyle(
                fontSize: height * 0.6,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        );

      case CardBrand.generic:
        return Icon(
          Icons.credit_card,
          color: Colors.white.withValues(alpha: 0.8),
          size: height,
        );
    }
  }
}
