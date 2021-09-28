abstract class Progress {
  double get completionRate;
}

class TimerProgress extends Progress {
  final int millisecondsPassed;
  final int targetMilliseconds;

  TimerProgress(this.millisecondsPassed, this.targetMilliseconds);

  @override
  double get completionRate => millisecondsPassed / targetMilliseconds;

  TimerProgress.initial(this.targetMilliseconds) : millisecondsPassed = 0;
}

class CounterProgress extends Progress {
  final int currentCount;
  final int targetCount;

  CounterProgress(this.currentCount, this.targetCount);

  @override
  double get completionRate => currentCount / targetCount;

  CounterProgress.initial(this.targetCount) : currentCount = 0;
}