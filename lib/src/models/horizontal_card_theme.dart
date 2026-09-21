import 'package:flutter/material.dart';
import '../painters/horizontal_guilloche_painter.dart';
import 'card_text_finish.dart';

/// Defines visual and stylistic attributes for a horizontal credit card.
class HorizontalCardTheme {
  /// The primary background gradient or color style.
  final Gradient? backgroundGradient;

  /// The solid background color if gradient is not specified.
  final Color backgroundColor;

  /// The primary text color for numbers, names, and labels.
  final Color textColor;

  /// Secondary text color for labels (e.g., 'CARDHOLDER', 'EXPIRES').
  final Color labelColor;

  /// Tactile physical typography finish (flat, embossed, goldFoil, silverFoil).
  final CardTextFinish textFinish;

  /// Optional background painter for custom security watermarks or guilloche patterns.
  final CustomPainter? backgroundPainter;

  /// The card corner border radius.
  final BorderRadius borderRadius;

  /// Border decoration around the card perimeter.
  final BoxBorder? border;

  /// Box shadows cast by the card in space.
  final List<BoxShadow>? shadows;

  /// Specular glare color reflecting light off the card surface.
  final Color glareColor;

  /// The physical 3D core edge rim color visible when the card tilts.
  final Color? edgeColor;

  /// Creates a [HorizontalCardTheme] configuration.
  const HorizontalCardTheme({
    this.backgroundGradient,
    this.backgroundColor = const Color(0xFF1E293B),
    this.textColor = Colors.white,
    this.labelColor = const Color(0x99FFFFFF),
    this.textFinish = CardTextFinish.flat,
    this.backgroundPainter,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.border,
    this.shadows,
    this.glareColor = const Color(0x33FFFFFF),
    this.edgeColor,
  });

  /// Deep obsidian luxury theme (Amex Centurion / Black Card style).
  static const HorizontalCardTheme black = HorizontalCardTheme(
    backgroundGradient: LinearGradient(
      colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF0A0F1D)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    textColor: Color(0xFFE2E8F0),
    labelColor: Color(0x8094A3B8),
    edgeColor: Color(0xFF1E293B),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0x33FFFFFF), width: 1),
    ),
    shadows: [
      BoxShadow(
        color: Color(0x66000000),
        blurRadius: 24,
        offset: Offset(0, 12),
      ),
    ],
  );

  /// Modern neobank electric purple theme (Zinli / Nubank style).
  static const HorizontalCardTheme electricPurple = HorizontalCardTheme(
    backgroundGradient: LinearGradient(
      colors: [Color(0xFF6B21A8), Color(0xFF4C1D95), Color(0xFF3B0764)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    textColor: Colors.white,
    labelColor: Color(0xAAFFFFFF),
    edgeColor: Color(0xFF581C87),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0x33C084FC), width: 1),
    ),
    shadows: [
      BoxShadow(
        color: Color(0x66581C87),
        blurRadius: 24,
        offset: Offset(0, 12),
      ),
    ],
  );

  /// Brushed platinum titanium theme (Apple Card style).
  static const HorizontalCardTheme titanium = HorizontalCardTheme(
    backgroundGradient: LinearGradient(
      colors: [Color(0xFFF1F5F9), Color(0xFFCBD5E1), Color(0xFF94A3B8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    backgroundColor: Color(0xFFCBD5E1),
    textColor: Color(0xFF0F172A),
    labelColor: Color(0xFF475569),
    edgeColor: Color(0xFF94A3B8),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0x66FFFFFF), width: 1),
    ),
    shadows: [
      BoxShadow(
        color: Color(0x40000000),
        blurRadius: 20,
        offset: Offset(0, 10),
      ),
    ],
  );

  /// Heritage American Express Green Card theme with authentic banknote guilloche,
  /// geometric security border, centurion medallion, and physical 3D embossed letterpress.
  static const HorizontalCardTheme greenCard = HorizontalCardTheme(
    backgroundGradient: LinearGradient(
      colors: [
        Color(0xFF285A3C),
        Color(0xFF1E452E),
        Color(0xFF143321),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    backgroundColor: Color(0xFF1E452E),
    textColor: Color(0xFFF1F5F9),
    labelColor: Color(0xCCA7C4B0),
    edgeColor: Color(0xFF163D26),
    textFinish: CardTextFinish.embossed,
    backgroundPainter: HorizontalGuillochePainter(),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0x4486EFAC), width: 1),
    ),
    glareColor: Color(0x2E86EFAC),
    shadows: [
      BoxShadow(
        color: Color(0x66000000),
        blurRadius: 24,
        offset: Offset(0, 12),
      ),
    ],
  );
}
