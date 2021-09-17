abstract class GoalProgress {
  double get completionRate;
}

class TimerGoalProgress extends GoalProgress {
  final int millisecondsPassed;
  final int targetMilliseconds;

  TimerGoalProgress(this.millisecondsPassed, this.targetMilliseconds);

  @override
  double get completionRate => millisecondsPassed / targetMilliseconds;
}

class CounterGoalProgress extends GoalProgress {
  final int currentCount;
  final int targetCount;

  CounterGoalProgress(this.currentCount, this.targetCount);

  @override
  double get completionRate => currentCount / targetCount;
}