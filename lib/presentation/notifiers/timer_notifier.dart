import 'dart:async';

import 'package:flutter/material.dart';

import '../services/timer_service.dart';

class TimerNotifier extends ChangeNotifier {
  final TimerService timerService = TimerService.instance;

  String end = "";
  String duration = "";
  VoidCallback? onUpdate;

  init({int duration = 0, String endTime = "", VoidCallback? onUpdate}) {
    end = endTime;
    this.onUpdate = onUpdate;
    timerService.startTimer(duration, onTime);
  }

  stop({bool notify = true}) {
    timerService.stop();

    if (notify) {
      notifyListeners();
    }
  }

  void onTime(Timer t) {
    print("onTime: ${t.tick}");

    duration = t.tick.toString();

    notifyListeners();

    if (onUpdate != null) {
      onUpdate!();
    }
  }

  bool get isRunning => timerService.isRunning;
}
