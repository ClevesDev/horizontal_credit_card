import 'package:flutter/material.dart';
import '../models/card_brand.dart';
import '../models/card_text_finish.dart';
import '../models/horizontal_card_theme.dart';
import 'horizontal_brand_logo.dart';
import 'horizontal_contactless.dart';
import 'horizontal_emv_chip.dart';

/// The landscape front face of the horizontal credit card.
class HorizontalCardFront extends StatelessWidget {
  /// 16-digit (or 15-digit) card number.
  final String cardNumber;

  /// Cardholder name.
  final String cardHolder;

  /// Expiry date formatted as MM/YY.
  final String expiryDate;

  /// Payment network brand.
  final CardBrand brand;

  /// Visual theme configuration.
  final HorizontalCardTheme cardTheme;

  /// Tactile physical typography finish.
  final CardTextFinish textFinish;

  /// 3D perspective horizontal tilt coordinate for dynamic specular highlights.
  final double tiltX;

  /// 3D perspective vertical tilt coordinate for dynamic specular highlights.
  final double tiltY;

  /// Mask sensitive card number characters.
  final bool isMasked;

  /// Optional bank branding logo widget injected at the top-right.
  final Widget? bankLogo;

  /// Creates a [HorizontalCardFront] instance.
  const HorizontalCardFront({
    super.key,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.brand,
    required this.cardTheme,
    this.textFinish = CardTextFinish.flat,
    this.tiltX = 0.0,
    this.tiltY = 0.0,
    this.isMasked = false,
    this.bankLogo,
  });

  @override
  Widget build(BuildContext context) {
    final formattedNumber = isMasked
        ? _formatMaskedCardNumber(cardNumber)
        : _formatCardNumber(cardNumber);

    final textShadows = _getTextShadows(
      textFinish,
      cardTheme.textColor,
      tiltX,
      tiltY,
    );

    return Stack(
      children: [
        // Optional Background Painter (e.g. Banknote Guilloche / Watermark)
        if (cardTheme.backgroundPainter != null)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: cardTheme.backgroundPainter,
              ),
            ),
          ),

        // Foreground Card Elements
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Row: EMV Chip & Contactless on left, Bank Logo on right
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const HorizontalEmvChip(width: 42, height: 32),
                      const SizedBox(width: 14),
                      HorizontalContactless(
                        size: 18,
                        color: cardTheme.textColor.withValues(alpha: 0.8),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: bankLogo ??
                            (brand == CardBrand.americanExpress
                                ? Text(
                                    'AMERICAN EXPRESS',
                                    style: TextStyle(
                                      fontFamily: 'sans-serif',
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2.0,
                                      color: cardTheme.textColor
                                          .withValues(alpha: 0.95),
                                    ),
                                  )
                                : Text(
                                    'GLOBAL BANK',
                                    style: TextStyle(
                                      fontFamily: 'sans-serif',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2.0,
                                      color: cardTheme.textColor
                                          .withValues(alpha: 0.9),
                                    ),
                                  )),
                      ),
                    ),
                  ),
                ],
              ),

              // Middle: 16/15-Digit Card Number with Physical 3D Embossed Relief
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  formattedNumber,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.4,
                    color: cardTheme.textColor,
                    shadows: textShadows,
                  ),
                ),
              ),

              // Bottom Row: Cardholder, Expiry, and Brand Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Cardholder column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'CARDHOLDER',
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: cardTheme.labelColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          cardHolder.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'sans-serif',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: cardTheme.textColor,
                            shadows: textShadows,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Expiry date column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'EXPIRES',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: cardTheme.labelColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        expiryDate,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: cardTheme.textColor,
                          shadows: textShadows,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 16),

                  // Payment network brand
                  HorizontalBrandLogo(
                    brand: brand,
                    height: 22,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Calculates tactile chiseled bevel shadows and physical relief based on finish
  /// and interactive gyroscopic 3D tilt coordinates.
  List<Shadow> _getTextShadows(
    CardTextFinish finish,
    Color baseTextColor,
    double tiltX,
    double tiltY,
  ) {
    switch (finish) {
      case CardTextFinish.embossed:
        // Physical 3D Letterpress Embossed Relief:
        // Upper-left specular bevel catches light dynamically based on tilt;
        // lower-right cast shadow creates tangible depth punched from behind.
        final specularAlpha = (0.75 + (tiltX * 0.2)).clamp(0.4, 0.95);
        final shadowAlpha = (0.85 - (tiltX * 0.1)).clamp(0.6, 0.95);

        return [
          // Specular Bevel Highlight (Top-Left)
          Shadow(
            color: Colors.white.withValues(alpha: specularAlpha),
            offset: Offset(-1.2 - (tiltX * 0.4), -1.2 - (tiltY * 0.4)),
            blurRadius: 1.0,
          ),
          // Deep Physical Cavity Drop Shadow (Bottom-Right)
          Shadow(
            color: Colors.black.withValues(alpha: shadowAlpha),
            offset: Offset(1.6 - (tiltX * 0.4), 1.8 - (tiltY * 0.4)),
            blurRadius: 2.0,
          ),
          // Intermediate Chisel Edge Extrusion
          Shadow(
            color: Colors.black.withValues(alpha: 0.45),
            offset: const Offset(0.5, 0.8),
            blurRadius: 0.5,
          ),
        ];

      case CardTextFinish.goldFoil:
        return [
          Shadow(
            color: const Color(0xFFFFE082).withValues(alpha: 0.6),
            offset: Offset(-0.8 - (tiltX * 0.3), -0.8 - (tiltY * 0.3)),
            blurRadius: 1.2,
          ),
          Shadow(
            color: Colors.black.withValues(alpha: 0.65),
            offset: const Offset(1.2, 1.4),
            blurRadius: 2.0,
          ),
        ];

      case CardTextFinish.silverFoil:
        return [
          Shadow(
            color: Colors.white.withValues(alpha: 0.7),
            offset: Offset(-0.8 - (tiltX * 0.3), -0.8 - (tiltY * 0.3)),
            blurRadius: 1.2,
          ),
          Shadow(
            color: Colors.black.withValues(alpha: 0.65),
            offset: const Offset(1.2, 1.4),
            blurRadius: 2.0,
          ),
        ];

      case CardTextFinish.flat:
        return [
          Shadow(
            color: Colors.black.withValues(alpha: 0.35),
            offset: const Offset(0, 1.2),
            blurRadius: 2.0,
          ),
        ];
    }
  }

  String _formatCardNumber(String number) {
    final clean = number.replaceAll(' ', '');
    if (clean.isEmpty) return '••••  ••••  ••••  ••••';

    // Support 15-digit Amex format (4 - 6 - 5)
    if (clean.length == 15 || brand == CardBrand.americanExpress) {
      if (clean.length <= 4) return clean;
      if (clean.length <= 10) {
        return '${clean.substring(0, 4)}  ${clean.substring(4)}';
      }
      return '${clean.substring(0, 4)}  ${clean.substring(4, 10)}  ${clean.substring(10)}';
    }

    // Standard 16-digit format (4 - 4 - 4 - 4)
    final buffer = StringBuffer();
    for (int i = 0; i < clean.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write('  ');
      }
      buffer.write(clean[i]);
    }
    return buffer.toString();
  }

  String _formatMaskedCardNumber(String number) {
    final clean = number.replaceAll(' ', '');
    if (clean.length <= 4) return '••••  ••••  ••••  $clean';
    final lastFour = clean.substring(clean.length - 4);
    if (clean.length == 15 || brand == CardBrand.americanExpress) {
      return '••••  ••••••  •$lastFour';
    }
    return '••••  ••••  ••••  $lastFour';
  }
}
