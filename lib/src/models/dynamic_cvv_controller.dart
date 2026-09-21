import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'dynamic_cvv_config.dart';

/// Controller for orchestrating dynamic rolling CVV generation, countdown timers,
/// and external backend synchronization.
class DynamicCvvController extends ChangeNotifier {
  /// The configuration guiding duration, callbacks, and formatting.
  final DynamicCvvConfig config;

  final math.Random _random = math.Random();
  Timer? _timer;
  late String _currentCvv;
  late int _remainingSeconds;
  bool _isRunning = false;
  bool _isDisposed = false;

  /// Creates a [DynamicCvvController] instance.
  DynamicCvvController({
    this.config = const DynamicCvvConfig(),
    String? initialCvv,
  }) {
    _remainingSeconds = config.duration.inSeconds;
    if (initialCvv != null && initialCvv.isNotEmpty) {
      _currentCvv = initialCvv;
    } else {
      _currentCvv = _generateRandomCode();
    }
  }

  /// Current 3 or 4-digit security code.
  String get currentCvv => _currentCvv;

  /// Remaining seconds until next code regeneration.
  int get remainingSeconds => _remainingSeconds;

  /// Fraction of time remaining from 1.0 down to 0.0.
  double get progress {
    final total = config.duration.inSeconds;
    if (total <= 0) return 0.0;
    return (_remainingSeconds / total).clamp(0.0, 1.0);
  }

  /// Whether the countdown ticker is currently active.
  bool get isRunning => _isRunning;

  /// Starts the countdown timer.
  void start() {
    if (_isDisposed || _isRunning) return;
    _isRunning = true;
    _startPeriodicTimer();
    notifyListeners();
  }

  /// Stops / pauses the countdown timer without altering current code.
  void stop() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    notifyListeners();
  }

  /// Resets the remaining seconds to the full duration and restarts.
  void reset() {
    _remainingSeconds = config.duration.inSeconds;
    notifyListeners();
  }

  /// Force-regenerates a new CVV code immediately and resets the timer.
  Future<void> regenerate() async {
    if (_isDisposed) return;

    String newCode;
    if (config.onGenerate != null) {
      newCode = await config.onGenerate!();
    } else {
      newCode = _generateRandomCode();
    }

    _currentCvv = newCode;
    _remainingSeconds = config.duration.inSeconds;
    config.onCvvChanged?.call(_currentCvv);

    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void _startPeriodicTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_isDisposed) {
        timer.cancel();
        return;
      }

      if (_remainingSeconds > 1) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        // Rollover when countdown reaches 0
        await regenerate();
      }
    });
  }

  String _generateRandomCode() {
    final max = config.digitsLength == 4 ? 10000 : 1000;
    final code = _random.nextInt(max);
    return code.toString().padLeft(config.digitsLength, '0');
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
