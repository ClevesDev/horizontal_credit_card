import 'package:flutter/material.dart';
import '../models/card_brand.dart';
import '../models/horizontal_card_theme.dart';
import 'horizontal_brand_logo.dart';

/// The landscape back face of the horizontal credit card.
class HorizontalCardBack extends StatelessWidget {
  /// 3 or 4 digit security code.
  final String cvv;

  /// Payment network brand.
  final CardBrand brand;

  /// Visual theme configuration.
  final HorizontalCardTheme cardTheme;

  /// Mask the CVV code with asterisks.
  final bool isMasked;

  /// Creates a [HorizontalCardBack] instance.
  const HorizontalCardBack({
    super.key,
    required this.cvv,
    required this.brand,
    required this.cardTheme,
    this.isMasked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Subtle Background Painter on the reverse side
        if (cardTheme.backgroundPainter != null)
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.45,
                child: CustomPaint(
                  painter: cardTheme.backgroundPainter,
                ),
              ),
            ),
          ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 18),

            // Full-width black magnetic stripe
            Container(
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFF111827),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Signature strip and CVV container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  // White signature panel with security micro-lines
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CustomPaint(
                          painter: _SignatureLinesPainter(),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // CVV security code box
                  Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: const Color(0xFFCBD5E1),
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      isMasked ? '•••' : cvv,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1.5,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Bottom row: Legal notice and brand logo
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      'This card is property of the issuer. If found, please return to any branch or call customer support.',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 7.5,
                        height: 1.2,
                        color: cardTheme.labelColor.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  HorizontalBrandLogo(
                    brand: brand,
                    height: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SignatureLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF94A3B8).withValues(alpha: 0.3)
      ..strokeWidth = 0.8;

    for (double x = -size.height; x < size.width; x += 6) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
