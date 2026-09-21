import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/holo_foil_config.dart';

/// Renders a dynamic physical thin-film diffraction grating and holographic
/// rainbow foil layer that reacts to 3D pointer and gyroscopic tilt coordinates.
class HorizontalHoloFoilPainter extends CustomPainter {
  /// The current X-axis tilt coordinate (-1.0 to 1.0).
  final double tiltX;

  /// The current Y-axis tilt coordinate (-1.0 to 1.0).
  final double tiltY;

  /// Configuration governing the style, intensity, and positioning.
  final HoloFoilConfig config;

  /// Corner radius of the card surface clipping bounds.
  final BorderRadius borderRadius;

  /// Creates a [HorizontalHoloFoilPainter] instance.
  const HorizontalHoloFoilPainter({
    required this.tiltX,
    required this.tiltY,
    required this.config,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!config.enabled || size.width <= 0 || size.height <= 0) return;

    final rect = Offset.zero & size;
    final rrect = borderRadius.toRRect(rect);

    canvas.save();
    canvas.clipRRect(rrect);

    switch (config.style) {
      case HoloStyle.full:
        _paintFullHoloSheen(canvas, size, rect);
        break;
      case HoloStyle.securityBadge:
        _paintSecurityBadge(canvas, size);
        break;
      case HoloStyle.securityStripe:
        _paintSecurityStripe(canvas, size, rect);
        break;
    }

    canvas.restore();
  }

  void _paintFullHoloSheen(Canvas canvas, Size size, Rect rect) {
    final spectrum = config.rainbowSpectrum ?? HoloFoilConfig.defaultSpectrum;
    final baseAlpha = (config.intensity * 0.35).clamp(0.0, 1.0);

    // Primary diffraction sweep based on light incidence angle
    final angle = math.atan2(tiltY, -tiltX);
    final dx = math.cos(angle);
    final dy = math.sin(angle);

    final gradientColors = spectrum.map((c) {
      return c.withValues(alpha: baseAlpha);
    }).toList();

    final primaryPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment(-dx + (tiltY * 0.8), -dy - (tiltX * 0.8)),
        end: Alignment(dx + (tiltY * 0.8), dy - (tiltX * 0.8)),
        colors: gradientColors,
        tileMode: TileMode.mirror,
      ).createShader(rect)
      ..blendMode = BlendMode.screen;

    canvas.drawRect(rect, primaryPaint);

    // Secondary harmonic interference ring (simulates microscopic nano-grooves)
    final secondaryAlpha = (config.intensity * 0.20).clamp(0.0, 1.0);
    final focalCenter = Alignment(
      (tiltY * 1.4).clamp(-1.0, 1.0),
      (-tiltX * 1.4).clamp(-1.0, 1.0),
    );

    final secondaryPaint = Paint()
      ..shader = RadialGradient(
        center: focalCenter,
        radius: 0.9,
        colors: [
          const Color(0xFF00E5FF).withValues(alpha: secondaryAlpha),
          const Color(0xFFD500F9).withValues(alpha: secondaryAlpha * 0.7),
          const Color(0xFFFFEA00).withValues(alpha: secondaryAlpha * 0.4),
          Colors.transparent,
        ],
        stops: const [0.0, 0.35, 0.65, 1.0],
      ).createShader(rect)
      ..blendMode = BlendMode.screen;

    canvas.drawRect(rect, secondaryPaint);
  }

  void _paintSecurityBadge(Canvas canvas, Size size) {
    final badgeWidth = config.badgeSize.width;
    final badgeHeight = config.badgeSize.height;

    // Calculate badge position from alignment
    final left = (size.width - badgeWidth) * (config.badgeAlignment.x + 1) / 2;
    final top = (size.height - badgeHeight) * (config.badgeAlignment.y + 1) / 2;
    final badgeRect = Rect.fromLTWH(left, top, badgeWidth, badgeHeight);
    final badgeRRect = config.badgeBorderRadius.toRRect(badgeRect);

    // 1. Metallic silver foil base with subtle shadow
    canvas.drawRRect(
      badgeRRect,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    final silverBasePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFE2E8F0),
          Color(0xFF94A3B8),
          Color(0xFFCBD5E1),
          Color(0xFF64748B),
        ],
      ).createShader(badgeRect);

    canvas.drawRRect(badgeRRect, silverBasePaint);

    canvas.save();
    canvas.clipRRect(badgeRRect);

    // 2. Micro-etched concentric hologram security circles
    final center = badgeRect.center;
    final maxRadius = math.max(badgeWidth, badgeHeight) * 0.6;
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6
      ..color = Colors.white.withValues(alpha: 0.35);

    for (double r = 4.0; r < maxRadius; r += 3.5) {
      canvas.drawCircle(center, r, linePaint);
    }

    // 3. Shifting holographic diffraction rainbow across badge
    final spectrum = config.rainbowSpectrum ?? HoloFoilConfig.defaultSpectrum;
    final badgeAlpha = (config.intensity * 0.75).clamp(0.0, 1.0);
    final angle = math.atan2(tiltY, -tiltX) + (math.pi / 4);

    final holoPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment(-math.cos(angle) + tiltY, -math.sin(angle) - tiltX),
        end: Alignment(math.cos(angle) + tiltY, math.sin(angle) - tiltX),
        colors: spectrum.map((c) => c.withValues(alpha: badgeAlpha)).toList(),
        tileMode: TileMode.mirror,
      ).createShader(badgeRect)
      ..blendMode = BlendMode.screen;

    canvas.drawRect(badgeRect, holoPaint);

    // 4. Subtle security seal icon (stylized hologram emblem)
    final emblemPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withValues(alpha: 0.85);

    final diamondPath = Path()
      ..moveTo(center.dx, center.dy - 7)
      ..lineTo(center.dx + 8, center.dy)
      ..lineTo(center.dx, center.dy + 7)
      ..lineTo(center.dx - 8, center.dy)
      ..close();

    canvas.drawPath(diamondPath, emblemPaint);

    canvas.restore();

    // 5. Beveled outer rim border
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = Colors.white.withValues(alpha: 0.6);

    canvas.drawRRect(badgeRRect, borderPaint);
  }

  void _paintSecurityStripe(Canvas canvas, Size size, Rect rect) {
    final stripeLeft = size.width * config.stripePosition.clamp(0.0, 0.95);
    final stripeWidth = config.stripeWidth;
    final stripeRect = Rect.fromLTWH(stripeLeft, 0, stripeWidth, size.height);

    canvas.save();
    canvas.clipRect(stripeRect);

    // Metallic underlay
    final basePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0x33CBD5E1),
          Color(0x5594A3B8),
          Color(0x33CBD5E1),
        ],
      ).createShader(stripeRect);

    canvas.drawRect(stripeRect, basePaint);

    // Micro-hatched security lines
    final hatchPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..strokeWidth = 0.6;

    for (double y = 0; y < size.height; y += 4.0) {
      canvas.drawLine(
        Offset(stripeLeft, y),
        Offset(stripeLeft + stripeWidth, y + 2.0),
        hatchPaint,
      );
    }

    // Shifting holographic rainbow band
    final spectrum = config.rainbowSpectrum ?? HoloFoilConfig.defaultSpectrum;
    final stripeAlpha = (config.intensity * 0.65).clamp(0.0, 1.0);
    final angle = math.atan2(tiltY, -tiltX);

    final holoPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment(-math.cos(angle), -math.sin(angle) + (tiltX * 0.5)),
        end: Alignment(math.cos(angle), math.sin(angle) + (tiltX * 0.5)),
        colors: spectrum.map((c) => c.withValues(alpha: stripeAlpha)).toList(),
        tileMode: TileMode.mirror,
      ).createShader(stripeRect)
      ..blendMode = BlendMode.screen;

    canvas.drawRect(stripeRect, holoPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant HorizontalHoloFoilPainter oldDelegate) {
    return oldDelegate.tiltX != tiltX ||
        oldDelegate.tiltY != tiltY ||
        oldDelegate.config != config ||
        oldDelegate.borderRadius != borderRadius;
  }
}
