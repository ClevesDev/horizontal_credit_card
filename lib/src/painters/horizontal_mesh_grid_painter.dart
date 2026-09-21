import 'package:flutter/material.dart';

/// Renders a precision isometric micro-grid pattern for modern fintech cards,
/// representing digital encryption, blockchain nodes, or high-tech security architecture.
class HorizontalMeshGridPainter extends CustomPainter {
  /// Color of the grid lines.
  final Color gridColor;

  /// Spacing between grid points.
  final double spacing;

  /// Creates a [HorizontalMeshGridPainter].
  const HorizontalMeshGridPainter({
    this.gridColor = const Color(0x1838BDF8),
    this.spacing = 18.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final paint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final dotPaint = Paint()
      ..color = gridColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    // Diagonal isometric cross-grid
    for (double x = -size.height; x < size.width + size.height; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint,
      );
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }

    // Micro-dots at grid intersections
    for (double x = 0; x < size.width; x += spacing * 2) {
      for (double y = 0; y < size.height; y += spacing * 2) {
        canvas.drawCircle(Offset(x, y), 1.2, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant HorizontalMeshGridPainter oldDelegate) {
    return oldDelegate.gridColor != gridColor || oldDelegate.spacing != spacing;
  }
}
