abstract class Progress {
  double get completionRate;
}

class TimerProgress extends Progress {
  final int millisecondsPassed;
  final int targetMilliseconds;

  TimerProgress(this.millisecondsPassed, this.targetMilliseconds);

  @override
  double get completionRate => millisecondsPassed / targetMilliseconds;
}

class CounterProgress extends Progress {
  final int currentCount;
  final int targetCount;

  CounterProgress(this.currentCount, this.targetCount);

  @override
  double get completionRate => currentCount / targetCount;
}