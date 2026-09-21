import 'package:flutter/material.dart';

/// Renders a vector contactless NFC payment icon.
class HorizontalContactless extends StatelessWidget {
  /// Size of the icon.
  final double size;

  /// Stroke color of the waves.
  final Color color;

  /// Creates a [HorizontalContactless] indicator.
  const HorizontalContactless({
    super.key,
    this.size = 20.0,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ContactlessPainter(color: color),
      ),
    );
  }
}

class _ContactlessPainter extends CustomPainter {
  final Color color;

  _ContactlessPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width * 0.15, size.height * 0.5);

    // Radiating concentric wave arcs
    for (int i = 1; i <= 4; i++) {
      final radius = size.width * (0.22 * i);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -0.7,
        1.4,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ContactlessPainter oldDelegate) =>
      oldDelegate.color != color;
}
