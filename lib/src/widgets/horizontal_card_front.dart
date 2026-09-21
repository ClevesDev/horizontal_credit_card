import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  /// Whether to display a subtle copy-to-clipboard button next to the card number.
  final bool enableCopy;

  /// When copying, whether to remove spaces (true) or retain formatted spacing (false).
  final bool cleanCopiedNumber;

  /// Callback triggered when the card number is copied to clipboard.
  final ValueChanged<String>? onCardNumberCopied;

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
    this.enableCopy = false,
    this.cleanCopiedNumber = true,
    this.onCardNumberCopied,
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
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
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
                      if (enableCopy) ...[
                        const SizedBox(width: 8),
                        _CopyCardNumberButton(
                          cardNumber: cardNumber,
                          cleanCopiedNumber: cleanCopiedNumber,
                          color: cardTheme.labelColor,
                          onCopied: onCardNumberCopied,
                        ),
                      ],
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

  /// Calculates tactile chiseled bevel shadows and physical relief based on finish.
  List<Shadow> _getTextShadows(
    CardTextFinish finish,
    Color baseTextColor,
    double tiltX,
    double tiltY,
  ) {
    switch (finish) {
      case CardTextFinish.embossed:
        // Physical 3D Letterpress Embossed Relief:
        // Razor-sharp upper-left bevel highlight and crisp lower-right cavity shadow.
        // Fixed offsets prevent jitter/ghosting during 3D card tilt.
        return const [
          // Crisp specular bevel highlight on upper-left edge
          Shadow(
            color: Color(0xD0FFFFFF),
            offset: Offset(-0.8, -0.8),
            blurRadius: 0.0,
          ),
          // Deep physical cavity drop shadow on lower-right edge
          Shadow(
            color: Color(0xDE000000),
            offset: Offset(1.2, 1.4),
            blurRadius: 0.8,
          ),
          // Subtle ambient depth shadow
          Shadow(
            color: Color(0x66000000),
            offset: Offset(0.4, 0.6),
            blurRadius: 0.0,
          ),
        ];

      case CardTextFinish.goldFoil:
        return const [
          Shadow(
            color: Color(0x99FFE082),
            offset: Offset(-0.8, -0.8),
            blurRadius: 0.5,
          ),
          Shadow(
            color: Color(0xAA000000),
            offset: Offset(1.0, 1.2),
            blurRadius: 1.0,
          ),
        ];

      case CardTextFinish.silverFoil:
        return const [
          Shadow(
            color: Color(0xB3FFFFFF),
            offset: Offset(-0.8, -0.8),
            blurRadius: 0.5,
          ),
          Shadow(
            color: Color(0xAA000000),
            offset: Offset(1.0, 1.2),
            blurRadius: 1.0,
          ),
        ];

      case CardTextFinish.flat:
        return const [
          Shadow(
            color: Color(0x59000000),
            offset: Offset(0, 1.0),
            blurRadius: 1.5,
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

class _CopyCardNumberButton extends StatefulWidget {
  final String cardNumber;
  final bool cleanCopiedNumber;
  final Color color;
  final ValueChanged<String>? onCopied;

  const _CopyCardNumberButton({
    required this.cardNumber,
    required this.cleanCopiedNumber,
    required this.color,
    this.onCopied,
  });

  @override
  State<_CopyCardNumberButton> createState() => _CopyCardNumberButtonState();
}

class _CopyCardNumberButtonState extends State<_CopyCardNumberButton> {
  bool _copied = false;
  Timer? _resetTimer;

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  void _handleCopy() {
    final text = widget.cleanCopiedNumber
        ? widget.cardNumber.replaceAll(' ', '')
        : widget.cardNumber;

    widget.onCopied?.call(text);

    _resetTimer?.cancel();
    if (mounted) {
      setState(() => _copied = true);
    }

    _resetTimer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() => _copied = false);
      }
    });

    Clipboard.setData(ClipboardData(text: text));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleCopy,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _copied
              ? const Color(0xFF10B981).withValues(alpha: 0.25)
              : widget.color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: _copied
                ? const Color(0xFF10B981).withValues(alpha: 0.6)
                : widget.color.withValues(alpha: 0.25),
            width: 0.8,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: _copied
              ? const Icon(
                  Icons.check_rounded,
                  key: ValueKey('copied'),
                  size: 13,
                  color: Color(0xFF10B981),
                )
              : Icon(
                  Icons.copy_rounded,
                  key: const ValueKey('copy'),
                  size: 13,
                  color: widget.color.withValues(alpha: 0.85),
                ),
        ),
      ),
    );
  }
}
