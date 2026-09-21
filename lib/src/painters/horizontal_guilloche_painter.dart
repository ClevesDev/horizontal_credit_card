import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Renders authentic banknote security guilloche patterns, geometric intaglio
/// borders, and a centered classical medallion crest for heritage financial cards
/// such as the American Express Green Card.
class HorizontalGuillochePainter extends CustomPainter {
  /// Primary color used for the geometric guilloche security waves.
  final Color primaryColor;

  /// Accent color for the central circular medallion and inner border.
  final Color accentColor;

  /// Creates a [HorizontalGuillochePainter].
  const HorizontalGuillochePainter({
    this.primaryColor = const Color(0x1A86EFAC),
    this.accentColor = const Color(0x2286EFAC),
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final width = size.width;
    final height = size.height;

    // 1. Geometric Banknote Security Border
    final borderPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const margin = 8.0;
    const cornerSize = 14.0;
    final borderPath = Path()
      ..moveTo(margin + cornerSize, margin)
      ..lineTo(width - margin - cornerSize, margin)
      ..lineTo(width - margin, margin + cornerSize)
      ..lineTo(width - margin, height - margin - cornerSize)
      ..lineTo(width - margin - cornerSize, height - margin)
      ..lineTo(margin + cornerSize, height - margin)
      ..lineTo(margin, height - margin - cornerSize)
      ..lineTo(margin, margin + cornerSize)
      ..close();

    canvas.drawPath(borderPath, borderPaint);

    // Inner fine dotted border line
    final innerBorderPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    const innerMargin = 11.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          innerMargin,
          innerMargin,
          width - innerMargin * 2,
          height - innerMargin * 2,
        ),
        const Radius.circular(8),
      ),
      innerBorderPaint,
    );

    // 2. Intaglio Guilloche Sine Waves across Card Body
    final wavePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final centerY = height * 0.52;
    for (int i = -3; i <= 3; i++) {
      final wavePath = Path();
      final yOffset = centerY + (i * 18.0);
      final amplitude = 12.0 + (i.abs() * 3.0);
      final frequency = 0.024 - (i.abs() * 0.001);

      wavePath.moveTo(0, yOffset);
      for (double x = 0; x <= width; x += 3.0) {
        final y = yOffset + math.sin(x * frequency + (i * 0.5)) * amplitude;
        wavePath.lineTo(x, y);
      }
      canvas.drawPath(wavePath, wavePaint);
    }

    // 3. Centered Circular Security Medallion (Roman Centurion / Heritage Seal)
    final center = Offset(width * 0.5, height * 0.48);
    const medallionRadius = 42.0;

    // Concentric geometric rings
    final medallionPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;

    canvas.drawCircle(center, medallionRadius, medallionPaint);
    canvas.drawCircle(center, medallionRadius - 4, innerBorderPaint);
    canvas.drawCircle(center, medallionRadius - 9, innerBorderPaint);
    canvas.drawCircle(center, medallionRadius - 16, innerBorderPaint);

    // Radial spokes around the medallion perimeter
    final spokePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    const spokeCount = 24;
    for (int i = 0; i < spokeCount; i++) {
      final angle = (i * 2 * math.pi) / spokeCount;
      final x1 = center.dx + math.cos(angle) * (medallionRadius - 4);
      final y1 = center.dy + math.sin(angle) * (medallionRadius - 4);
      final x2 = center.dx + math.cos(angle) * medallionRadius;
      final y2 = center.dy + math.sin(angle) * medallionRadius;
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), spokePaint);
    }

    // Centurion / Gladiator Helmet Silhouette Silhouette Curves
    final emblemPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    // Crest arc
    final crestPath = Path()
      ..moveTo(center.dx - 12, center.dy + 8)
      ..cubicTo(
        center.dx - 16,
        center.dy - 12,
        center.dx - 6,
        center.dy - 20,
        center.dx + 8,
        center.dy - 16,
      )
      ..cubicTo(
        center.dx + 16,
        center.dy - 12,
        center.dx + 14,
        center.dy + 4,
        center.dx + 4,
        center.dy + 12,
      );
    canvas.drawPath(crestPath, emblemPaint);

    // Profile visor curve
    final visorPath = Path()
      ..moveTo(center.dx - 4, center.dy - 12)
      ..lineTo(center.dx + 12, center.dy - 4)
      ..lineTo(center.dx + 8, center.dy + 2)
      ..lineTo(center.dx - 2, center.dy - 2)
      ..close();
    canvas.drawPath(visorPath, emblemPaint);
  }

  @override
  bool shouldRepaint(covariant HorizontalGuillochePainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.accentColor != accentColor;
  }
}
