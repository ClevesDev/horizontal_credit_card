import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/dynamic_cvv_config.dart';
import '../models/dynamic_cvv_controller.dart';

/// An interactive digital security display for the back of the horizontal card,
/// featuring a dynamic rolling CVV code, an animated countdown progress ring,
/// remaining seconds indicator, and tap-to-refresh capability.
class HorizontalDynamicCvv extends StatefulWidget {
  /// Configuration options governing countdown duration and styling.
  final DynamicCvvConfig config;

  /// Optional external controller. If null, an internal controller is managed.
  final DynamicCvvController? controller;

  /// Initial fallback CVV when controller is created internally.
  final String? initialCvv;

  /// Whether to mask the digits with bullet dots.
  final bool isMasked;

  /// Creates a [HorizontalDynamicCvv] widget.
  const HorizontalDynamicCvv({
    super.key,
    this.config = const DynamicCvvConfig(),
    this.controller,
    this.initialCvv,
    this.isMasked = false,
  });

  @override
  State<HorizontalDynamicCvv> createState() => _HorizontalDynamicCvvState();
}

class _HorizontalDynamicCvvState extends State<HorizontalDynamicCvv>
    with SingleTickerProviderStateMixin {
  DynamicCvvController? _internalController;
  late AnimationController _pulseController;
  late Animation<double> _pulseScale;

  DynamicCvvController get _effectiveController =>
      widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _internalController = DynamicCvvController(
        config: widget.config,
        initialCvv: widget.initialCvv,
      );
      _internalController!.start();
    }

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    _pulseScale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant HorizontalDynamicCvv oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        _internalController?.dispose();
        _internalController = null;
      }
      if (widget.controller == null) {
        _internalController = DynamicCvvController(
          config: widget.config,
          initialCvv: widget.initialCvv,
        );
        _internalController!.start();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _internalController?.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (!widget.config.tapToRefresh) return;

    await _pulseController.forward();
    await _pulseController.reverse();
    await _effectiveController.regenerate();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _effectiveController,
      builder: (context, _) {
        final remainingSeconds = _effectiveController.remainingSeconds;
        final progress = _effectiveController.progress;
        final isWarning =
            remainingSeconds <= widget.config.warningThreshold.inSeconds;

        final activeRingColor = isWarning
            ? (widget.config.ringWarningColor ?? const Color(0xFFEF4444))
            : (widget.config.ringColor ?? const Color(0xFF2563EB));

        return ScaleTransition(
          scale: _pulseScale,
          child: GestureDetector(
            onTap: _handleTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: isWarning
                      ? activeRingColor.withValues(alpha: 0.7)
                      : const Color(0xFFCBD5E1),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 3,
                    offset: const Offset(0, 1.5),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Rolling animated CVV digits
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 320),
                    transitionBuilder: (child, animation) {
                      return ClipRect(
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 0.7),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      widget.isMasked ? '•••' : _effectiveController.currentCvv,
                      key: ValueKey<String>(
                        widget.isMasked
                            ? 'masked'
                            : _effectiveController.currentCvv,
                      ),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1.5,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),

                  if (widget.config.showTimer) ...[
                    const SizedBox(width: 8),

                    // Circular Countdown Timer Progress Ring
                    SizedBox(
                      width: 19,
                      height: 19,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(19, 19),
                            painter: _DynamicCvvRingPainter(
                              progress: progress,
                              ringColor: activeRingColor,
                              trackColor: const Color(0xFFE2E8F0),
                              strokeWidth: 2.2,
                            ),
                          ),
                          if (widget.config.showRemainingSeconds)
                            Text(
                              '$remainingSeconds',
                              style: TextStyle(
                                fontSize: 7.5,
                                fontWeight: FontWeight.w800,
                                color: activeRingColor,
                                height: 1.0,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DynamicCvvRingPainter extends CustomPainter {
  final double progress;
  final Color ringColor;
  final Color trackColor;
  final double strokeWidth;

  const _DynamicCvvRingPainter({
    required this.progress,
    required this.ringColor,
    required this.trackColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track circle
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0.0) return;

    // Sweeping progress arc
    final sweepAngle = 2 * math.pi * progress;
    final progressPaint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Start at 12 o'clock (-pi / 2) and sweep clockwise
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DynamicCvvRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.ringColor != ringColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
