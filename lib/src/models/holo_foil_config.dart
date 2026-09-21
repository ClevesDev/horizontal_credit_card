import 'package:flutter/material.dart';

/// Style variants for the holographic security foil reflection.
enum HoloStyle {
  /// Full-surface iridescent rainbow diffraction foil across the card.
  full,

  /// Embedded micro-etched metallic security hologram sticker badge
  /// (e.g. Visa Dove or Mastercard Holo globe).
  securityBadge,

  /// Vertical holographic security ribbon commonly used in modern fintech cards.
  securityStripe,
}

/// Configuration model governing the physical optics and layout of the
/// holographic security foil shimmer feature.
@immutable
class HoloFoilConfig {
  /// Whether the holographic foil effect is active. Defaults to true.
  final bool enabled;

  /// The visual style of the holographic effect. Defaults to [HoloStyle.full].
  final HoloStyle style;

  /// Overall opacity and luminance intensity of the rainbow diffraction layer (0.0 to 1.0).
  /// Defaults to 0.35.
  final double intensity;

  /// Positional alignment of the hologram badge when [style] is [HoloStyle.securityBadge].
  /// Defaults to top-right quadrant `Alignment(0.68, -0.62)`.
  final Alignment badgeAlignment;

  /// Physical dimensions of the security badge. Defaults to 38.0 x 26.0 logical pixels.
  final Size badgeSize;

  /// Corner radius of the security badge. Defaults to 4.0 logical pixels.
  final BorderRadius badgeBorderRadius;

  /// Horizontal width of the vertical security stripe when [style] is [HoloStyle.securityStripe].
  /// Defaults to 32.0 logical pixels.
  final double stripeWidth;

  /// Left offset fraction (0.0 to 1.0) for the vertical stripe across the card width.
  /// Defaults to 0.72 (near the right payment logo area).
  final double stripePosition;

  /// Custom list of diffraction gradient colors. If omitted, uses an 8-stop
  /// prismatic rainbow spectrum: Red, Orange, Yellow, Green, Cyan, Blue, Violet, Red.
  final List<Color>? rainbowSpectrum;

  /// Creates a [HoloFoilConfig] configuration instance.
  const HoloFoilConfig({
    this.enabled = true,
    this.style = HoloStyle.full,
    this.intensity = 0.35,
    this.badgeAlignment = const Alignment(0.68, -0.62),
    this.badgeSize = const Size(38.0, 26.0),
    this.badgeBorderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.stripeWidth = 32.0,
    this.stripePosition = 0.72,
    this.rainbowSpectrum,
  }) : assert(intensity >= 0.0 && intensity <= 1.0,
            'Holo intensity must be between 0.0 and 1.0');

  /// Default prismatic rainbow spectrum colors.
  static const List<Color> defaultSpectrum = [
    Color(0xFFFF1744), // Crimson
    Color(0xFFFF9100), // Amber / Orange
    Color(0xFFFFEA00), // Gold / Yellow
    Color(0xFF00E676), // Emerald Green
    Color(0xFF00E5FF), // Cyan
    Color(0xFF2979FF), // Royal Blue
    Color(0xFFD500F9), // Purple / Violet
    Color(0xFFFF1744), // Loop back to Crimson
  ];

  /// Creates a copy of this configuration with modified properties.
  HoloFoilConfig copyWith({
    bool? enabled,
    HoloStyle? style,
    double? intensity,
    Alignment? badgeAlignment,
    Size? badgeSize,
    BorderRadius? badgeBorderRadius,
    double? stripeWidth,
    double? stripePosition,
    List<Color>? rainbowSpectrum,
  }) {
    return HoloFoilConfig(
      enabled: enabled ?? this.enabled,
      style: style ?? this.style,
      intensity: intensity ?? this.intensity,
      badgeAlignment: badgeAlignment ?? this.badgeAlignment,
      badgeSize: badgeSize ?? this.badgeSize,
      badgeBorderRadius: badgeBorderRadius ?? this.badgeBorderRadius,
      stripeWidth: stripeWidth ?? this.stripeWidth,
      stripePosition: stripePosition ?? this.stripePosition,
      rainbowSpectrum: rainbowSpectrum ?? this.rainbowSpectrum,
    );
  }
}
