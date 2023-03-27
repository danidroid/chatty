import 'dart:async';

class TimerService {
  static final TimerService _service = TimerService._();
  static TimerService get instance => _service;

  TimerService._();

  Timer? t;

  bool get isRunning => t?.isActive ?? false;

  void startTimer(int duration, Function(Timer t) onTime) {
    if (null != t) {
      t!.cancel();
    }
    t = Timer.periodic(const Duration(seconds: 1), onTime);
  }

  /*void onTime(Timer t) {
    print("timer: ${t.tick}");
  }*/

  void stop() {
    t?.cancel();
  }
}
