import 'package:flutter/material.dart';
import '../models/card_brand.dart';
import '../models/horizontal_card_theme.dart';
import 'horizontal_brand_logo.dart';
import 'horizontal_contactless.dart';
import 'horizontal_emv_chip.dart';

/// The landscape front face of the horizontal credit card.
class HorizontalCardFront extends StatelessWidget {
  /// 16-digit card number.
  final String cardNumber;

  /// Cardholder name.
  final String cardHolder;

  /// Expiry date formatted as MM/YY.
  final String expiryDate;

  /// Payment network brand.
  final CardBrand brand;

  /// Visual theme configuration.
  final HorizontalCardTheme cardTheme;

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
    this.isMasked = false,
    this.bankLogo,
  });

  @override
  Widget build(BuildContext context) {
    final formattedNumber = isMasked
        ? _formatMaskedCardNumber(cardNumber)
        : _formatCardNumber(cardNumber);

    return Container(
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
                        Text(
                          'GLOBAL BANK',
                          style: TextStyle(
                            fontFamily: 'sans-serif',
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.0,
                            color: cardTheme.textColor.withValues(alpha: 0.9),
                          ),
                        ),
                  ),
                ),
              ),
            ],
          ),

          // Middle: 16-Digit Card Number with 3D Embossed Relief
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
                shadows: [
                  Shadow(
                    color: Colors.white.withValues(alpha: 0.35),
                    offset: const Offset(-0.8, -0.8),
                    blurRadius: 1,
                  ),
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.7),
                    offset: const Offset(1.2, 1.4),
                    blurRadius: 2,
                  ),
                ],
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
    );
  }

  String _formatCardNumber(String number) {
    final clean = number.replaceAll(' ', '');
    if (clean.isEmpty) return '••••  ••••  ••••  ••••';

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
    return '••••  ••••  ••••  $lastFour';
  }
}
