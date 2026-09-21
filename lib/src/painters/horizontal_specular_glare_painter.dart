import 'package:flutter/material.dart';

/// Renders a dynamic, realistic specular lighting reflection that glides across
/// the card surface according to 3D tilt coordinates using hardware screen/overlay blending.
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

    final w = size.width;
    final h = size.height;

    // Light focal center glides opposite to tilt deflection
    final lightCenterX = w * 0.5 - (tiltY * w * 0.7);
    final lightCenterY = h * 0.5 + (tiltX * h * 0.7);

    // 1. Soft Ambient Radial Light Sheen (BlendMode.screen preserves contrast)
    final radialPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment(
          ((lightCenterX / w) * 2 - 1).clamp(-1.2, 1.2),
          ((lightCenterY / h) * 2 - 1).clamp(-1.2, 1.2),
        ),
        radius: 0.85,
        colors: [
          glareColor.withValues(alpha: 0.18),
          glareColor.withValues(alpha: 0.06),
          glareColor.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(rect)
      ..blendMode = BlendMode.screen;

    canvas.drawRect(rect, radialPaint);

    // 2. Diagonal Specular Flare Streak (Sleek light gleam across landscape card)
    final streakPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment(
          -1.0 + (tiltY * 1.5),
          -1.0 - (tiltX * 1.5),
        ),
        end: Alignment(
          1.0 + (tiltY * 1.5),
          1.0 - (tiltX * 1.5),
        ),
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.14),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.35, 0.50, 0.65],
      ).createShader(rect)
      ..blendMode = BlendMode.overlay;

    canvas.drawRect(rect, streakPaint);
  }

  @override
  bool shouldRepaint(covariant HorizontalSpecularGlarePainter oldDelegate) {
    return oldDelegate.tiltX != tiltX ||
        oldDelegate.tiltY != tiltY ||
        oldDelegate.glareColor != glareColor ||
        oldDelegate.borderRadius != borderRadius;
  }
}
