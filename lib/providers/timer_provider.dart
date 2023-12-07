import 'dart:async';

import 'package:flutter/foundation.dart';

class TimerProvider extends ChangeNotifier {

  int _seconds = 0;
  Timer? _timer;
  bool _isRunning = false;

  int get seconds => _seconds;
  bool get isRunning => _isRunning;

  // Constructor
  TimerProvider() {
    startTimer();
  }

  // Start timer
  void startTimer() {
    _isRunning = true;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        _seconds++;
        notifyListeners();
      },
    );
  }

  // Stop timer
  void stopTimer() {
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  // Dispose timer
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

}