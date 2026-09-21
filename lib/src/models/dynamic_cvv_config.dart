import 'dart:async';
import 'package:flutter/material.dart';

/// Configuration options for the dynamic rolling CVV/CVC feature.
@immutable
class DynamicCvvConfig {
  /// Whether dynamic rolling CVV is enabled. Defaults to true.
  final bool enabled;

  /// Duration of each dynamic security code lifecycle before regeneration.
  /// Defaults to 60 seconds (1 minute).
  final Duration duration;

  /// Whether to show the circular countdown progress ring. Defaults to true.
  final bool showTimer;

  /// Whether to display remaining seconds text alongside the timer. Defaults to true.
  final bool showRemainingSeconds;

  /// Whether tapping the CVV badge manually regenerates the code and restarts the timer.
  /// Defaults to true.
  final bool tapToRefresh;

  /// Number of digits in the security code. Defaults to 3 (or 4 for Amex).
  final int digitsLength;

  /// Color of the circular countdown progress ring during normal countdown.
  /// If null, defaults to theme accent or blue (#2563EB).
  final Color? ringColor;

  /// Color of the circular countdown ring when time remaining drops below [warningThreshold].
  /// Defaults to red (#EF4444).
  final Color? ringWarningColor;

  /// Threshold duration for triggering the warning color state. Defaults to 10 seconds.
  final Duration warningThreshold;

  /// Optional asynchronous or synchronous generator function for fintech backend integration.
  /// When omitted, a cryptographically/pseudo-random 3-digit number is generated.
  final FutureOr<String> Function()? onGenerate;

  /// Callback triggered whenever a new dynamic CVV is generated.
  final ValueChanged<String>? onCvvChanged;

  /// Creates a [DynamicCvvConfig] configuration instance.
  const DynamicCvvConfig({
    this.enabled = true,
    this.duration = const Duration(seconds: 60),
    this.showTimer = true,
    this.showRemainingSeconds = true,
    this.tapToRefresh = true,
    this.digitsLength = 3,
    this.ringColor,
    this.ringWarningColor,
    this.warningThreshold = const Duration(seconds: 10),
    this.onGenerate,
    this.onCvvChanged,
  }) : assert(digitsLength >= 3 && digitsLength <= 4,
            'CVV code must be 3 or 4 digits');

  /// Creates a copy with modified values.
  DynamicCvvConfig copyWith({
    bool? enabled,
    Duration? duration,
    bool? showTimer,
    bool? showRemainingSeconds,
    bool? tapToRefresh,
    int? digitsLength,
    Color? ringColor,
    Color? ringWarningColor,
    Duration? warningThreshold,
    FutureOr<String> Function()? onGenerate,
    ValueChanged<String>? onCvvChanged,
  }) {
    return DynamicCvvConfig(
      enabled: enabled ?? this.enabled,
      duration: duration ?? this.duration,
      showTimer: showTimer ?? this.showTimer,
      showRemainingSeconds: showRemainingSeconds ?? this.showRemainingSeconds,
      tapToRefresh: tapToRefresh ?? this.tapToRefresh,
      digitsLength: digitsLength ?? this.digitsLength,
      ringColor: ringColor ?? this.ringColor,
      ringWarningColor: ringWarningColor ?? this.ringWarningColor,
      warningThreshold: warningThreshold ?? this.warningThreshold,
      onGenerate: onGenerate ?? this.onGenerate,
      onCvvChanged: onCvvChanged ?? this.onCvvChanged,
    );
  }
}
