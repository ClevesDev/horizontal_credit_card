import 'package:flutter/material.dart';
import '../models/card_text_finish.dart';
import '../models/horizontal_card_theme.dart';
import '../painters/horizontal_mesh_grid_painter.dart';
import '../painters/horizontal_orbital_rings_painter.dart';

/// Curated library of professional horizontal card themes, including
/// geometric pattern collections and minimalist solid color collections.
class CardPresets {
  const CardPresets._();

  // ===========================================================================
  // 1. COLECCIÓN PATRONES GEOMÉTRICOS (GEOMETRIC PATTERNS)
  // ===========================================================================

  /// Vibrant crimson and magenta gradient with intersecting geometric orbital rings.
  /// (Top card from international banking reference).
  static HorizontalCardTheme get crimsonOrbit => const HorizontalCardTheme(
        backgroundGradient: LinearGradient(
          colors: [
            Color(0xFFF43F5E), // Vibrant rose crimson
            Color(0xFFBE123C), // Deep ruby
            Color(0xFF881337), // Midnight magenta
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        backgroundColor: Color(0xFFBE123C),
        textColor: Colors.white,
        labelColor: Color(0xDDFECDD3),
        edgeColor: Color(0xFF9F1239),
        textFinish: CardTextFinish.embossed,
        backgroundPainter: HorizontalOrbitalRingsPainter(
          primaryColor: Color(0x38FFFFFF),
          accentColor: Color(0x20FFFFFF),
        ),
        border: Border.fromBorderSide(
          BorderSide(color: Color(0x44FDA4AF), width: 1.0),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x66BE123C),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      );

  /// Royal amethyst purple and violet gradient with intersecting geometric orbital rings.
  /// (Second card from international banking reference).
  static HorizontalCardTheme get royalAmethyst => const HorizontalCardTheme(
        backgroundGradient: LinearGradient(
          colors: [
            Color(0xFF8B5CF6), // Royal violet
            Color(0xFF6D28D9), // Deep amethyst
            Color(0xFF4C1D95), // Midnight plum
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        backgroundColor: Color(0xFF6D28D9),
        textColor: Colors.white,
        labelColor: Color(0xDDD8B4FE),
        edgeColor: Color(0xFF5B21B6),
        textFinish: CardTextFinish.embossed,
        backgroundPainter: HorizontalOrbitalRingsPainter(
          primaryColor: Color(0x38FFFFFF),
          accentColor: Color(0x20FFFFFF),
        ),
        border: Border.fromBorderSide(
          BorderSide(color: Color(0x44C4B5FD), width: 1.0),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x666D28D9),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      );

  /// Vibrant cyan and ocean azure gradient with intersecting geometric orbital rings.
  /// (Third card from international banking reference).
  static HorizontalCardTheme get oceanAzure => const HorizontalCardTheme(
        backgroundGradient: LinearGradient(
          colors: [
            Color(0xFF0EA5E9), // Ocean cyan
            Color(0xFF0284C7), // Deep azure
            Color(0xFF075985), // Midnight marine
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        backgroundColor: Color(0xFF0284C7),
        textColor: Colors.white,
        labelColor: Color(0xDDBAE6FD),
        edgeColor: Color(0xFF0369A1),
        textFinish: CardTextFinish.embossed,
        backgroundPainter: HorizontalOrbitalRingsPainter(
          primaryColor: Color(0x38FFFFFF),
          accentColor: Color(0x20FFFFFF),
        ),
        border: Border.fromBorderSide(
          BorderSide(color: Color(0x447DD3FC), width: 1.0),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x660284C7),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      );

  /// Deep midnight sapphire and obsidian navy with luminous geometric orbital rings.
  /// (Bottom card from international banking reference).
  static HorizontalCardTheme get midnightSapphire => const HorizontalCardTheme(
        backgroundGradient: LinearGradient(
          colors: [
            Color(0xFF1E293B), // Slate navy
            Color(0xFF0F172A), // Midnight sapphire
            Color(0xFF020617), // Deep abyss
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        backgroundColor: Color(0xFF0F172A),
        textColor: Color(0xFFF8FAFC),
        labelColor: Color(0xAA94A3B8),
        edgeColor: Color(0xFF1E293B),
        textFinish: CardTextFinish.silverFoil,
        backgroundPainter: HorizontalOrbitalRingsPainter(
          primaryColor: Color(0x2E38BDF8),
          accentColor: Color(0x1838BDF8),
        ),
        border: Border.fromBorderSide(
          BorderSide(color: Color(0x3338BDF8), width: 1.0),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      );

  /// High-tech cyber security card with isometric diamond/hex grid and neon cyan glow.
  static HorizontalCardTheme get cyberMesh => const HorizontalCardTheme(
        backgroundGradient: LinearGradient(
          colors: [
            Color(0xFF090D16),
            Color(0xFF0F172A),
            Color(0xFF050811),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        backgroundColor: Color(0xFF0F172A),
        textColor: Color(0xFFE0F2FE),
        labelColor: Color(0xAA38BDF8),
        edgeColor: Color(0xFF0284C7),
        textFinish: CardTextFinish.silverFoil,
        backgroundPainter: HorizontalMeshGridPainter(
          gridColor: Color(0x2238BDF8),
          spacing: 16.0,
        ),
        border: Border.fromBorderSide(
          BorderSide(color: Color(0x5538BDF8), width: 1.0),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x660284C7),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      );

  /// Iconic American Express Green Card with authentic banknote guilloche security watermark.
  static HorizontalCardTheme get amexGreen => HorizontalCardTheme.greenCard;

  // ===========================================================================
  // 2. COLECCIÓN COLORES SÓLIDOS (SOLID MINIMALIST COLORS)
  // ===========================================================================

  /// Stealth matte black solid finish with crisp silver typography.
  static HorizontalCardTheme get solidMatteBlack => const HorizontalCardTheme(
        backgroundColor: Color(0xFF18181B),
        textColor: Color(0xFFF4F4F5),
        labelColor: Color(0x80A1A1AA),
        edgeColor: Color(0xFF27272A),
        textFinish: CardTextFinish.silverFoil,
        border: Border.fromBorderSide(
          BorderSide(color: Color(0x33FFFFFF), width: 1.0),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      );

  /// Pure porcelain / ceramic white solid card (Apple Card minimalist aesthetic).
  static HorizontalCardTheme get solidCeramicWhite => const HorizontalCardTheme(
        backgroundColor: Color(0xFFFAFAFA),
        textColor: Color(0xFF09090B),
        labelColor: Color(0xFF71717A),
        edgeColor: Color(0xFFE4E4E7),
        textFinish: CardTextFinish.flat,
        border: Border.fromBorderSide(
          BorderSide(color: Color(0x33000000), width: 1.0),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      );

  /// Intense cobalt blue solid card inspired by international premium debit banking.
  static HorizontalCardTheme get solidCobaltBlue => const HorizontalCardTheme(
        backgroundColor: Color(0xFF1D4ED8),
        textColor: Colors.white,
        labelColor: Color(0xCCBFDBFE),
        edgeColor: Color(0xFF1E40AF),
        textFinish: CardTextFinish.embossed,
        border: Border.fromBorderSide(
          BorderSide(color: Color(0x3393C5FD), width: 1.0),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x661D4ED8),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      );

  /// Vibrant hot coral orange-red solid card inspired by Monzo UK.
  static HorizontalCardTheme get solidHotCoral => const HorizontalCardTheme(
        backgroundColor: Color(0xFFFF4D4D),
        textColor: Colors.white,
        labelColor: Color(0xCCFFE4E6),
        edgeColor: Color(0xFFDC2626),
        textFinish: CardTextFinish.embossed,
        border: Border.fromBorderSide(
          BorderSide(color: Color(0x33FECDD3), width: 1.0),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x66FF4D4D),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      );

  /// Iconic solid electric purple inspired by Nubank / modern Latin American fintech.
  static HorizontalCardTheme get solidNubankPurple => const HorizontalCardTheme(
        backgroundColor: Color(0xFF820AD1),
        textColor: Colors.white,
        labelColor: Color(0xCCE9D5FF),
        edgeColor: Color(0xFF6B21A8),
        textFinish: CardTextFinish.embossed,
        border: Border.fromBorderSide(
          BorderSide(color: Color(0x33E9D5FF), width: 1.0),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x66820AD1),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      );

  /// Deep Swiss private banking emerald green solid card.
  static HorizontalCardTheme get solidEmerald => const HorizontalCardTheme(
        backgroundColor: Color(0xFF047857),
        textColor: Colors.white,
        labelColor: Color(0xCCA7F3D0),
        edgeColor: Color(0xFF065F46),
        textFinish: CardTextFinish.embossed,
        border: Border.fromBorderSide(
          BorderSide(color: Color(0x33A7F3D0), width: 1.0),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x66047857),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      );

  // ===========================================================================
  // 3. COLECCIÓN LUXURY & METALES (LUXURY FINISHES)
  // ===========================================================================

  /// Deep obsidian luxury theme (Amex Centurion / Black Card style).
  static HorizontalCardTheme get obsidianBlack => HorizontalCardTheme.black;

  /// Brushed platinum titanium theme (Apple Card style).
  static HorizontalCardTheme get appleTitanium => HorizontalCardTheme.titanium;

  /// Modern neobank electric purple theme (Zinli style).
  static HorizontalCardTheme get electricPurple =>
      HorizontalCardTheme.electricPurple;

  /// Cyberpunk deep obsidian card tailored for holographic rainbow diffraction.
  static HorizontalCardTheme get cyberpunkHolo => const HorizontalCardTheme(
        backgroundColor: Color(0xFF0D0F18),
        textColor: Color(0xFFF8FAFC),
        labelColor: Color(0xFF94A3B8),
        edgeColor: Color(0xFF1E293B),
        textFinish: CardTextFinish.embossed,
        border: Border.fromBorderSide(
          BorderSide(color: Color(0x3338BDF8), width: 1.0),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x4400E5FF),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      );

  /// Polished silver platinum card tailored for security hologram badges.
  static HorizontalCardTheme get platinumHologram => const HorizontalCardTheme(
        backgroundColor: Color(0xFFE2E8F0),
        textColor: Color(0xFF0F172A),
        labelColor: Color(0xFF475569),
        edgeColor: Color(0xFFCBD5E1),
        textFinish: CardTextFinish.embossed,
        border: Border.fromBorderSide(
          BorderSide(color: Color(0xFF94A3B8), width: 1.0),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      );
}
