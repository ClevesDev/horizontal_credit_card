import 'package:flutter/material.dart';

/// Renders sleek, modern intersecting circular arcs and orbital rings
/// inspired by contemporary international banking cards and fintech visual identities.
class HorizontalOrbitalRingsPainter extends CustomPainter {
  /// Color of the primary intersecting orbital rings.
  final Color primaryColor;

  /// Accent color for the secondary orbital glow rings.
  final Color accentColor;

  /// Creates a [HorizontalOrbitalRingsPainter].
  const HorizontalOrbitalRingsPainter({
    this.primaryColor = const Color(0x33FFFFFF),
    this.accentColor = const Color(0x1FFFFFFF),
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final w = size.width;
    final h = size.height;

    // Center 1: Lower-right primary orbit cluster
    final center1 = Offset(w * 0.72, h * 0.65);

    // Center 2: Upper-center secondary orbit cluster
    final center2 = Offset(w * 0.38, h * 0.28);

    // Center 3: Far lower-left subtle wave arc
    final center3 = Offset(w * 0.12, h * 0.85);

    final ringPaint1 = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final ringPaint2 = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final ringPaintThick = Paint()
      ..color = primaryColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;

    // Cluster 1: Concentric rings around center 1
    canvas.drawCircle(center1, 32, ringPaint2);
    canvas.drawCircle(center1, 58, ringPaint1);
    canvas.drawCircle(center1, 92, ringPaint2);
    canvas.drawCircle(center1, 128, ringPaintThick);
    canvas.drawCircle(center1, 168, ringPaint2);

    // Cluster 2: Intersecting rings around center 2
    canvas.drawCircle(center2, 45, ringPaint2);
    canvas.drawCircle(center2, 80, ringPaint1);
    canvas.drawCircle(center2, 120, ringPaint2);
    canvas.drawCircle(center2, 160, ringPaintThick);

    // Cluster 3: Subtle sweeping perimeter rings around center 3
    canvas.drawCircle(center3, 64, ringPaint2);
    canvas.drawCircle(center3, 110, ringPaint1);
    canvas.drawCircle(center3, 170, ringPaint2);
  }

  @override
  bool shouldRepaint(covariant HorizontalOrbitalRingsPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.accentColor != accentColor;
  }
}
