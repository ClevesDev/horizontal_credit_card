import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Renders a dynamic specular lighting reflection that sweeps across the
/// landscape card surface according to the 3D tilt coordinates.
class HorizontalSpecularGlarePainter extends CustomPainter {
  /// The current X-axis tilt coordinate (-1.0 to 1.0).
  final double tiltX;

  /// The current Y-axis tilt coordinate (-1.0 to 1.0).
  final double tiltY;

  /// The color of the specular reflection band.
  final Color glareColor;

  /// Corner radius of the card surface clipping bounds.
  final BorderRadius borderRadius;

  /// Creates a [HorizontalSpecularGlarePainter].
  const HorizontalSpecularGlarePainter({
    required this.tiltX,
    required this.tiltY,
    required this.glareColor,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final rect = Offset.zero & size;
    final rrect = borderRadius.toRRect(rect);
    canvas.clipRRect(rrect);

    // Calculate light source focal center
    final centerX = size.width * (0.5 - tiltY * 0.4);
    final centerY = size.height * (0.5 + tiltX * 0.4);
    final radius = math.max(size.width, size.height) * 0.85;

    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment(
          (centerX / size.width) * 2 - 1,
          (centerY / size.height) * 2 - 1,
        ),
        radius: 0.9,
        colors: [
          glareColor,
          glareColor.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(centerX, centerY),
        radius: radius,
      ));

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant HorizontalSpecularGlarePainter oldDelegate) {
    return oldDelegate.tiltX != tiltX ||
        oldDelegate.tiltY != tiltY ||
        oldDelegate.glareColor != glareColor ||
        oldDelegate.borderRadius != borderRadius;
  }
}
