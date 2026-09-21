import 'package:flutter/material.dart';

/// Renders a metallic EMV contact chip with circuit trace divisions.
class HorizontalEmvChip extends StatelessWidget {
  /// Width of the chip.
  final double width;

  /// Height of the chip.
  final double height;

  /// Creates a [HorizontalEmvChip].
  const HorizontalEmvChip({
    super.key,
    this.width = 44.0,
    this.height = 34.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFDF7A),
            Color(0xFFD4AF37),
            Color(0xFFA67C1E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: const Color(0x66FFFFFF),
          width: 0.8,
        ),
      ),
      child: CustomPaint(
        painter: _ChipLinesPainter(),
      ),
    );
  }
}

class _ChipLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6B4E1B).withValues(alpha: 0.6)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    // Horizontal center divider
    canvas.drawLine(Offset(0, h * 0.5), Offset(w, h * 0.5), paint);

    // Left vertical lines
    canvas.drawLine(Offset(w * 0.35, 0), Offset(w * 0.35, h * 0.5), paint);
    canvas.drawLine(Offset(w * 0.35, h * 0.5), Offset(w * 0.35, h), paint);

    // Right vertical lines
    canvas.drawLine(Offset(w * 0.65, 0), Offset(w * 0.65, h * 0.5), paint);
    canvas.drawLine(Offset(w * 0.65, h * 0.5), Offset(w * 0.65, h), paint);

    // Central contact pad
    final centerRect = Rect.fromCenter(
      center: Offset(w * 0.5, h * 0.5),
      width: w * 0.3,
      height: h * 0.35,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(centerRect, const Radius.circular(2)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
