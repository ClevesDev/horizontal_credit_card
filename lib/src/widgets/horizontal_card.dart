import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/card_brand.dart';
import '../models/card_text_finish.dart';
import '../models/dynamic_cvv_config.dart';
import '../models/dynamic_cvv_controller.dart';
import '../models/horizontal_card_theme.dart';
import '../painters/horizontal_specular_glare_painter.dart';
import 'horizontal_card_back.dart';
import 'horizontal_card_front.dart';

/// A modern, customizable horizontal credit and debit card widget with
/// interactive 3D perspective physics, gyroscopic specular lighting,
/// tap-to-flip animation, and frozen security states.
class HorizontalCard extends StatefulWidget {
  /// The 16-digit card number.
  final String cardNumber;

  /// The cardholder's full name.
  final String cardHolder;

  /// Expiry date formatted as MM/YY.
  final String expiryDate;

  /// 3 or 4 digit card verification value (CVV/CVC).
  final String cvv;

  /// The payment network brand (Visa, Mastercard, Amex, etc.).
  final CardBrand brand;

  /// The visual theme styling the card surface.
  final HorizontalCardTheme cardTheme;

  /// Tactile physical typography finish override (defaults to theme finish).
  final CardTextFinish? textFinish;

  /// Physical 3D thickness of the card rim in logical pixels. Defaults to 3.5 (~1.0mm).
  /// Set to 0.0 for a completely flat card.
  final double thickness;

  /// Overall width of the card. Default is 320.0.
  final double width;

  /// Overall height of the card. Conforms to ISO/IEC 7810 ID-1 standard ($1.586:1$).
  /// Defaults to 202.0 when width is 320.0.
  final double? height;

  /// Programmatic control over whether the reverse face is shown.
  final bool isFlipped;

  /// Mask sensitive numbers and CVV with bullet dots.
  final bool isMasked;

  /// Enables dynamic rolling CVV with 60-second countdown timer.
  final bool isDynamicCvv;

  /// Configuration options for dynamic rolling CVV.
  final DynamicCvvConfig? dynamicCvvConfig;

  /// Optional external controller for dynamic rolling CVV.
  final DynamicCvvController? dynamicCvvController;

  /// Locks the card in a frozen security state with frosted ice crystals.
  final bool isFrozen;

  /// Marks the card with an expired banner.
  final bool isExpired;

  /// Optional bank logo injected at the top-right of the front face.
  final Widget? bankLogo;

  /// Enables interactive 3D pointer tilt when dragging over the card.
  final bool enableTilt;

  /// Callback fired when the card is tapped.
  final VoidCallback? onTap;

  /// Callback fired when the card flips between front and back.
  final ValueChanged<bool>? onFlip;

  /// Creates an instance of [HorizontalCard].
  const HorizontalCard({
    super.key,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cvv,
    this.brand = CardBrand.visa,
    this.cardTheme = HorizontalCardTheme.black,
    this.textFinish,
    this.thickness = 3.5,
    this.width = 320.0,
    this.height,
    this.isFlipped = false,
    this.isMasked = false,
    this.isDynamicCvv = false,
    this.dynamicCvvConfig,
    this.dynamicCvvController,
    this.isFrozen = false,
    this.isExpired = false,
    this.bankLogo,
    this.enableTilt = true,
    this.onTap,
    this.onFlip,
  });

  @override
  State<HorizontalCard> createState() => _HorizontalCardState();
}

class _HorizontalCardState extends State<HorizontalCard>
    with TickerProviderStateMixin {
  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;

  late final AnimationController _springController;
  late Animation<double> _tiltXAnimation;
  late Animation<double> _tiltYAnimation;

  double _tiltX = 0.0;
  double _tiltY = 0.0;
  bool _isBackVisible = false;

  @override
  void initState() {
    super.initState();
    _isBackVisible = widget.isFlipped;

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
      value: widget.isFlipped ? 1.0 : 0.0,
    );

    _flipAnimation = CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOutCubic,
    );

    _flipAnimation.addListener(() {
      final shouldShowBack = _flipAnimation.value >= 0.5;
      if (shouldShowBack != _isBackVisible) {
        setState(() {
          _isBackVisible = shouldShowBack;
        });
      }
    });

    _springController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _tiltXAnimation = const AlwaysStoppedAnimation(0.0);
    _tiltYAnimation = const AlwaysStoppedAnimation(0.0);
  }

  @override
  void didUpdateWidget(covariant HorizontalCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _flipController.forward();
      } else {
        _flipController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    _springController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }

    if (_flipController.isAnimating) return;
    final targetValue = _flipController.value < 0.5 ? 1.0 : 0.0;
    if (targetValue == 1.0) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
    widget.onFlip?.call(targetValue == 1.0);
  }

  void _onPointerMove(PointerMoveEvent event, Size size) {
    if (!widget.enableTilt) return;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    setState(() {
      _tiltX = ((event.localPosition.dy - centerY) / centerY).clamp(-1.0, 1.0);
      _tiltY = ((event.localPosition.dx - centerX) / centerX).clamp(-1.0, 1.0);
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    if (!widget.enableTilt) return;

    _tiltXAnimation = Tween<double>(
      begin: _tiltX,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _springController,
      curve: Curves.easeOutBack,
    ));

    _tiltYAnimation = Tween<double>(
      begin: _tiltY,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _springController,
      curve: Curves.easeOutBack,
    ));

    _springController.forward(from: 0.0).then((_) {
      _tiltX = 0.0;
      _tiltY = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ISO/IEC 7810 ID-1 standard ratio is 1.586 : 1
    final cardHeight = widget.height ?? (widget.width / 1.586);
    final cardSize = Size(widget.width, cardHeight);

    return AnimatedBuilder(
      animation: Listenable.merge([_flipAnimation, _springController]),
      builder: (context, child) {
        final activeTiltX =
            _springController.isAnimating ? _tiltXAnimation.value : _tiltX;
        final activeTiltY =
            _springController.isAnimating ? _tiltYAnimation.value : _tiltY;

        // 3D perspective rotation matrix
        final angle = _flipAnimation.value * math.pi;
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.0010)
          ..rotateY(angle)
          ..rotateX(-activeTiltX * 0.16)
          ..rotateY(activeTiltY * 0.20);

        return Listener(
          onPointerMove: (e) => _onPointerMove(e, cardSize),
          onPointerUp: _onPointerUp,
          child: GestureDetector(
            onTap: _handleTap,
            child: SizedBox(
              width: widget.width,
              height: cardHeight,
              child: Transform(
                transform: transform,
                alignment: Alignment.center,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Physical 3D Extruded Rim (simulating real card thickness in mm)
                    ..._buildExtrudedRim(
                      thickness: widget.thickness,
                      edgeColor: widget.cardTheme.edgeColor ??
                          widget.cardTheme.backgroundColor,
                      borderRadius: widget.cardTheme.borderRadius,
                      width: widget.width,
                      height: cardHeight,
                      angle: angle,
                    ),

                    // Main Card Body Container
                    Container(
                      width: widget.width,
                      height: cardHeight,
                      decoration: BoxDecoration(
                        borderRadius: widget.cardTheme.borderRadius,
                        gradient: widget.cardTheme.backgroundGradient,
                        color: widget.cardTheme.backgroundGradient == null
                            ? widget.cardTheme.backgroundColor
                            : null,
                        border: widget.cardTheme.border,
                        boxShadow: widget.thickness > 0
                            ? null
                            : widget.cardTheme.shadows,
                      ),
                      child: ClipRRect(
                        borderRadius: widget.cardTheme.borderRadius,
                        child: Stack(
                          children: [
                            // Card Face Content (Front or Back)
                            _isBackVisible
                                ? Transform(
                                    transform: Matrix4.identity()
                                      ..rotateY(math.pi),
                                    alignment: Alignment.center,
                                    child: HorizontalCardBack(
                                      cvv: widget.cvv,
                                      brand: widget.brand,
                                      cardTheme: widget.cardTheme,
                                      isMasked: widget.isMasked,
                                      isDynamicCvv: widget.isDynamicCvv,
                                      dynamicCvvConfig: widget.dynamicCvvConfig,
                                      dynamicCvvController:
                                          widget.dynamicCvvController,
                                    ),
                                  )
                                : HorizontalCardFront(
                                    cardNumber: widget.cardNumber,
                                    cardHolder: widget.cardHolder,
                                    expiryDate: widget.expiryDate,
                                    brand: widget.brand,
                                    cardTheme: widget.cardTheme,
                                    textFinish: widget.textFinish ??
                                        widget.cardTheme.textFinish,
                                    tiltX: activeTiltX,
                                    tiltY: activeTiltY,
                                    isMasked: widget.isMasked,
                                    bankLogo: widget.bankLogo,
                                  ),

                            // Dynamic Specular Glare Layer
                            Positioned.fill(
                              child: IgnorePointer(
                                child: CustomPaint(
                                  painter: HorizontalSpecularGlarePainter(
                                    tiltX: activeTiltX,
                                    tiltY: activeTiltY,
                                    glareColor: widget.cardTheme.glareColor,
                                    borderRadius: widget.cardTheme.borderRadius,
                                  ),
                                ),
                              ),
                            ),

                            // Frozen Card Overlay
                            if (widget.isFrozen)
                              Positioned.fill(
                                child: _FrozenCardOverlay(
                                  borderRadius: widget.cardTheme.borderRadius,
                                ),
                              ),

                            // Expired Card Overlay
                            if (widget.isExpired)
                              Positioned.fill(
                                child: _ExpiredCardOverlay(
                                  borderRadius: widget.cardTheme.borderRadius,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildExtrudedRim({
    required double thickness,
    required Color edgeColor,
    required BorderRadius borderRadius,
    required double width,
    required double height,
    required double angle,
  }) {
    if (thickness <= 0.0) return const [];

    const sliceCount = 6;
    final flipDirection = math.cos(angle) >= 0 ? 1.0 : -1.0;
    final layers = <Widget>[];

    for (int i = sliceCount; i >= 1; i--) {
      final progress = i / sliceCount;
      final z = -thickness * progress * flipDirection;

      final shadedColor = Color.lerp(
        edgeColor,
        Colors.black,
        progress * 0.35,
      )!;

      layers.add(
        Transform(
          transform: Matrix4.translationValues(0.0, 0.0, z),
          alignment: Alignment.center,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: shadedColor,
              border: Border.all(
                color: shadedColor.withValues(alpha: 0.9),
                width: 0.5,
              ),
              boxShadow: i == sliceCount ? widget.cardTheme.shadows : null,
            ),
          ),
        ),
      );
    }

    return layers;
  }
}

class _FrozenCardOverlay extends StatelessWidget {
  final BorderRadius borderRadius;

  const _FrozenCardOverlay({required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: const Color(0x7738BDF8),
        border: Border.all(
          color: const Color(0xCCBAE6FD),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xDD0F172A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0x6638BDF8), width: 1),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock, color: Color(0xFF38BDF8), size: 16),
              SizedBox(width: 8),
              Text(
                'FROZEN',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpiredCardOverlay extends StatelessWidget {
  final BorderRadius borderRadius;

  const _ExpiredCardOverlay({required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: Colors.black.withValues(alpha: 0.5),
      ),
      child: Center(
        child: Transform.rotate(
          angle: -0.15,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xDDDC2626),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: const Text(
              'EXPIRED',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 13,
                letterSpacing: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
